<%@ include file="defines/defines.jsp" %>

<%
	String resetModule = request.getParameter("mod");
	if (resetModule != null)
		session.setAttribute("ActiveModule", mgr.getModuleByName(resetModule));
	SWModule activeModule = (SWModule) session.getAttribute("ActiveModule");
	if (activeModule == null) activeModule = mgr.getModuleByName("KJV");

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
		Search results for "<%= activeSearchTerm %>"
	</tiles:put>

	<tiles:put name="sidebar_left" type="string">
		<h2>Translations:</h2>
		<ul>
		<%
			for (int i = 0; i < modInfo.length; i++) {
				if (modInfo[i].type.equals(SwordOrb.BIBLES)) {
					SWModule module = mgr.getModuleByName(modInfo[i].name);
		%>
				<li><a href="wordsearchresults.jsp?mod=<%= URLEncoder.encode(modInfo[i].name) %>" title="view Romans 8:26-39 in <%= module.getDescription() %>"><%= module.getDescription() %></a></li>
		<%
				}
			}
		%>
		</ul>
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
		<h2>Results for "<em><%= activeSearchTerm %></em>"</h2>
		<%
			String[] results = null;
			if ((activeSearchTerm != null) && (activeSearchTerm.trim().length() > 0))
				results = activeModule.search(activeSearchTerm, stype, soptions, range);
			else	results = new String[0];
		%>
		<p class="textname">&raquo; <%= results.length %> result<%= (results.length == 1)?"s":""%> in the text of <%= activeModule.getDescription() %></p>
		<ul class="searchresultsnav">
			<li>Result Page:</li>
			<li><a href="" title="page 1: Genesis 3:24-Exodus 15:9">1</a></li>
			<li><a href="" title="page 2 of search results">2</a></li>
			<li><a href="" title="page 3 of search results">3</a></li>
			<li><a href="" title="page 4 of search results">4</a></li>
			<li><a href="" title="page 5 of search results">5</a></li>
			<li><a href="" title="page 6 of search results">6</a></li>
			<li><a href="" title="page 7 of search results">7</a></li>
			<li><a href="" title="page 8 of search results">8</a></li>
			<li><a href="" title="page 9 of search results">9</a></li>
			<li><a href="" title="page 10 of search results">10</a></li>
			<li><a href="" title="next page of search results">Next</a></li>
		</ul>
		<dl>
		<%
			for (int i = 0; i < results.length; i++) {
				activeModule.setKeyText(results[i]);
		%>
			<dt><a href="passagestudy.jsp?key=<%= URLEncoder.encode(results[i]) %>" title="<%= results[i] %>"><%= results[i] %></a></dt>
			<dd><%= activeModule.getRenderText() %></dd>
		<%
			}
		%>

		</dl>
		<ul class="searchresultsnav">
			<li>Result Page:</li>
			<li><a href="" title="page 1: Genesis 3:24-Exodus 15:9">1</a></li>
			<li><a href="" title="page 2 of search results">2</a></li>
			<li><a href="" title="page 3 of search results">3</a></li>
			<li><a href="" title="page 4 of search results">4</a></li>
			<li><a href="" title="page 5 of search results">5</a></li>
			<li><a href="" title="page 6 of search results">6</a></li>
			<li><a href="" title="page 7 of search results">7</a></li>
			<li><a href="" title="page 8 of search results">8</a></li>
			<li><a href="" title="page 9 of search results">9</a></li>
			<li><a href="" title="page 10 of search results">10</a></li>
			<li><a href="" title="next page of search results">Next</a></li>
		</ul>

	</tiles:put>
</tiles:insert>