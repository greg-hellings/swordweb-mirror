<%@ include file="defines/tiles.jsp" %>

<%
	String resetModule = request.getParameter("mod");
	if (resetModule != null)
		session.setAttribute("ActiveModule", resetModule);
	String activeModuleName = (String) session.getAttribute("ActiveModule");
	SWModule activeModule = mgr.getModuleByName((activeModuleName == null) ? "KJV" : activeModuleName);

	String resetSearchTerm = request.getParameter("searchTerm");
	if (resetSearchTerm != null)
		session.setAttribute("ActiveSearchTerm", resetSearchTerm);
	String activeSearchTerm = (String) session.getAttribute("ActiveSearchTerm");

	String range = "";
	String tmp = request.getParameter("range");
	if (tmp != null)
		range = tmp;

	SearchType stype = SearchType.MULTIWORD;
	tmp = request.getParameter("stype");
	if (tmp != null) {
		if (tmp.equalsIgnoreCase("P"))
			stype = SearchType.PHRASE;
		if (tmp.equalsIgnoreCase("R"))
			stype = SearchType.REGEX;
	}

	int soptions = 2;	// default to ignore case
	tmp = request.getParameter("icase");
	if ((tmp != null) && (!tmp.equals("1")))
		soptions = 0;
%>

<tiles:insert beanName="basic" flush="true" >
	<tiles:put name="title" type="string">
		Search results for <%= new String(activeSearchTerm.getBytes("iso8859-1"), "UTF-8") %>
	</tiles:put>

	<tiles:put name="sidebar_left" type="string">
		<div id="translations">
		<h2>Translations:</h2>
		<ul>
		<%
			for (int i = 0; i < modInfo.length; i++) {
				if (modInfo[i].category.equals(SwordOrb.BIBLES)) {
					SWModule module = mgr.getModuleByName(modInfo[i].name);
		%>
				<li><a href="wordsearchresults.jsp?mod=<%= URLEncoder.encode(modInfo[i].name) %>" title="view Romans 8:26-39 in <%= module.getDescription() %>"><%= module.getDescription() %></a></li>
		<%
				}
			}
		%>
		</ul>
		</div>
	</tiles:put>

	<tiles:put name="sidebar_right" type="string">
		<h2>Original Language:</h2>
		<p>The KJV translates 6 different Hebrew words and 3 Greek words into the English "<strong>sword</strong>."</p>
		<h3>Hebrew:</h3>
		<ul>
			<li><a href="" title="If we want to we can place the full Strongs definition in here and a link to more info on this word. ">H1300 <em>baraq</em></a></li>
			<li><a href="" title="If we want to we can place the full Strongs definition in here and a link to more info on this word. ">H2719 <em>chereb</em></a></li>
			<li><a href="" title="If we want to we can place the full Strongs definition in here and a link to more info on this word. ">H3027 <em>yad</em></a></li>
			<li><a href="" title="If we want to we can place the full Strongs definition in here and a link to more info on this word. ">H6609 <em>petiychah</em></a></li>
			<li><a href="" title="If we want to we can place the full Strongs definition in here and a link to more info on this word. ">H7524 <em>retsach</em></a></li>
			<li><a href="" title="If we want to we can place the full Strongs definition in here and a link to more info on this word. ">H7973 <em>shelach</em></a></li>
		</ul>
		<h3>Greek:</h3>
		<ul>
			<li><a href="" title="If we want to we can place the full Strongs definition in here and a link to more info on this word. ">G3162 <em>machaira</em></a></li>
			<li><a href="" title="If we want to we can place the full Strongs definition in here and a link to more info on this word. ">G4501 <em>romphaia</em></a></li>
			<li><a href="" title="If we want to we can place the full Strongs definition in here and a link to more info on this word. ">G5408 <em>phonos</em></a></li>
		</ul>
	</tiles:put>

	<tiles:put name="content" type="string">
	<div id="searchresults">
		<h2>Results for "<em><%= new String(activeSearchTerm.getBytes("iso8859-1"), "UTF-8") %></em>"</h2>
		<%
			SearchHit[] results = null;
			if ((activeSearchTerm != null) && (activeSearchTerm.trim().length() > 0)) {
				results = activeModule.search(activeSearchTerm, stype, soptions, range);

				//save the search reusult into the session so it can be retrived later on to browse through it
				session.setAttribute("SearchResults", results);
			}
			else if ( activeSearchTerm == null ) { //no search term given, try to see if we have a valid search result saved
				results = (SearchHit[]) session.getAttribute("SearchResults");
			}

			if ( results == null )
				results = new SearchHit[0];
		%>

		<p class="textname">&raquo; <%= results.length %> result<%= (results.length == 1)?"s":""%> in the text of <%= activeModule.getDescription() %></p>

		<dl>
		<%
			Integer resultStart = new Integer(request.getParameter("start") != null ? request.getParameter("start") : "0");
			Integer resultLimit = new Integer(30);

			for (int i = resultStart.intValue(); i < results.length && i < resultStart.intValue() + resultLimit.intValue(); i++)
			{
				activeModule.setKeyText(results[i].key);
		%>
				<dt>
					<a href="passagestudy.jsp?key=<%= URLEncoder.encode(results[i].key)+"#cv" %>" title="<%= results[i].key %>"><%= results[i].key %></a>
					<span><%= (results[i].score > 0)?("score: " + results[i].score) : "" %></span>
				</dt>
				<% boolean rtol = ("RtoL".equalsIgnoreCase(activeModule.getConfigEntry("Direction"))); %>
				<dd dir="<%= rtol ? "rtl" : "" %>">
					<%= new String(activeModule.getRenderText().getBytes("iso-8859-1"), "UTF-8") %>
				</dd>

		<%
			}
		%>

		</dl>

		<ul class="searchresultsnav">
			<%
				int navStart = (resultStart.intValue() / resultLimit.intValue()) - 5;
				if (navStart < 0)
					navStart = 0;

				int navEnd = navStart + 10;
				if ( navEnd*resultLimit.intValue() > results.length ) {
					navEnd = (results.length / resultLimit.intValue()) + ((results.length % resultLimit.intValue()) > 0 ? 1 : 0);
				}
			%>

			<li>Result Page:</li>

		<%
			if ( navStart > 0 ) {
		%>
				<li><a href="wordsearchresults.jsp?start=0" title="First page (<%= results[0].key %>) of search results">1</a>&nbsp;[...]</li>
		<%
			}
			else {
				if (results.length < resultLimit.intValue()) {
		%>
					<li><%= 1 %></li>
		<%
				}
			}
			for (int i = navStart; i < navEnd; ++i) {
				if (i == (resultStart.intValue() / resultLimit.intValue())) {
		%>
					<li><%= i+1 %></li>
		<%	}
				else {
		%>
					<li><a href="wordsearchresults.jsp?start=<%= i * resultLimit.intValue() %>" title="page <%= i+1 %> (<%= results[i * resultLimit.intValue()].key %>) of search results"><%= i+1 %></a></li>
		<%
				}
			}
		%>

		<%
				int lastPage = (results.length / resultLimit.intValue()) + ((results.length % resultLimit.intValue()) > 0 ? 1 : 0) -1;
			if (navEnd < lastPage) {
		%>
				<li>&nbsp;[...] <a href="wordsearchresults.jsp?start=<%= lastPage*resultLimit.intValue() %>" title="Last page (<%= results[lastPage].key %>) of search results"><%= lastPage+1 %></a></li>
		<%
			}
		%>
		</ul>
	</div>

	</tiles:put>
</tiles:insert>
