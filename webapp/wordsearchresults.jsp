<%@ include file="init.jsp" %>

<%
	String colorKeys[] = request.getParameterValues("colorKey");
	String colorMorph  = request.getParameter("colorMorph");
	String resetModule = request.getParameter("mod");
	String lastModType = (String) session.getAttribute("lastModType");
	String activeModuleName = (resetModule != null)?resetModule : ((String) session.getAttribute(("GBS".equals(lastModType))?"gbsBook":"ActiveModule"));
	SWModule activeModule = mgr.getModuleByName((activeModuleName == null) ? defaultBible : activeModuleName);
	if ((resetModule != null) && (activeModule != null)) {
		if ("Generic Books".equals(activeModule.getCategory())) {
			session.setAttribute("gbsBook", resetModule);
			session.setAttribute("lastModType", "GBS");
		}
		else {
			session.setAttribute("ActiveModule", resetModule);
			session.setAttribute("lastModType", "Bible");
		}
	}
	lastModType = (String) session.getAttribute("lastModType");

	String resetSearchTerm = request.getParameter("searchTerm");
	if (resetSearchTerm != null) {
		resetSearchTerm = new String(resetSearchTerm.getBytes("iso8859-1"), "UTF-8");
		mgr.setGlobalOption("Greek Accents", "Off");
		session.setAttribute("ActiveSearchTerm", mgr.filterText("Greek Accents", resetSearchTerm));
		mgr.setGlobalOption("Greek Accents", "On");
	}
	String activeSearchTerm = (String) session.getAttribute("ActiveSearchTerm");

	String tmp = request.getParameter("range");
	if (tmp != null) {
		tmp = new String(tmp.getBytes("iso8859-1"), "UTF-8");
		session.setAttribute("ActiveRange", tmp);
	}
	String range = (String) session.getAttribute("ActiveRange");
	if (range == null) {
		range = "";
	}

	SearchType stype = null;
	tmp = request.getParameter("stype");
	if (tmp != null) {
		if (tmp.equalsIgnoreCase("P")) {
			stype = SearchType.PHRASE;
		}
		if (tmp.equalsIgnoreCase("R")) {
			stype = SearchType.REGEX;
		}
		session.setAttribute("ActiveSearchType", stype);
	}

	stype = (SearchType) session.getAttribute("ActiveSearchType");
	if (stype == null) {
		stype = (activeModule.hasSearchFramework()) ? SearchType.LUCENE : SearchType.MULTIWORD;
	}

	int soptions = 0;
	tmp = request.getParameter("icase");
	if ((tmp != null) && (tmp.equals("1"))) {
		soptions = 2;
		session.setAttribute("ActiveSearchOptions", soptions);
	}
	Integer itmp = (Integer) session.getAttribute("ActiveSearchOptions");
	if (itmp == null) {
		itmp = 0;	// default to NOT ignore case
	}
	soptions = itmp;
%>
<tiles:insert beanName="basic" flush="true" >
	<tiles:put name="title" type="string">
		Search results for <%= activeSearchTerm %>
	</tiles:put>
	<tiles:put name="pintro" type="string" >
<div>
<%
	if (colorKeys != null) {
%>
    <script type="text/javascript" language="JavaScript">
<!--
function onPageLoad() {
<%
		for (int k = 0; k < colorKeys.length; k++) {
%>
	colorLemmas('x','<%=colorKeys[k]%>','<%=colorMorph%>', true);
<%
		}
%>
}
// -->
    </script>
<%
	}
%>
</div>
</tiles:put>
	<tiles:put name="sidebar_left" type="string">
		<div id="translations">
		<h2><t:t>Translations:</t:t></h2>
		<ul>
		<%
			for (int i = 0; i < modInfo.length; i++) {
				if (modInfo[i].category.equals(SwordOrb.BIBLES)) {
					SWModule module = mgr.getModuleByName(modInfo[i].name);
		%>
				<li><a href="wordsearchresults.jsp?mod=<%= URLEncoder.encode(modInfo[i].name) %>" title="<t:t>Conduct search with same search term in</t:t> <%= module.getDescription() %>"><%= module.getDescription() %></a></li>
		<%
				}
			}
		%>
		</ul>
		</div>
	</tiles:put>

	<tiles:put name="sidebar_right" type="string">
		<h2><t:t>Original Language:</t:t></h2>
	</tiles:put>

	<tiles:put name="content" type="string">
	<div id="searchresults">
		<h2><t:t>Results for</t:t> <em><%= activeSearchTerm %></em></h2>
		<%
			SearchHit[] results = null;
			if ((activeSearchTerm != null) && (activeSearchTerm.trim().length() > 0)) {
				mgr.setGlobalOption("Greek Accents", "Off");
				results = activeModule.search(activeSearchTerm, stype, soptions, range);
				// let's make some intuitive decisions on when to sort by score
				if ((results.length > 100) && (activeSearchTerm.indexOf(" ") > 0)
						 && (activeSearchTerm.indexOf("+") < 1)
						 && (activeSearchTerm.indexOf("\"") < 1)
						 && (activeSearchTerm.indexOf("~") < 1)
						) {
					Arrays.sort(results, new Comparator() {
						public int compare(Object o1, Object o2) {
							return ((SearchHit)o2).score - ((SearchHit)o1).score;
						}
					});
				}
				mgr.setGlobalOption("Greek Accents", "On");

				//save the search result into the session so it can be retrived later on to browse through it
				session.setAttribute("SearchResults", results);
			}
			else if ( activeSearchTerm == null ) { //no search term given, try to see if we have a valid search result saved
				results = (SearchHit[]) session.getAttribute("SearchResults");
			}

			if ( results == null ) {
				results = new SearchHit[0];
			}
		%>

		<p class="textname">&raquo; <%= results.length %> result<%= (results.length == 1)?"s":""%> <t:t>in the text of </t:t><%= activeModule.getDescription() %></p>
		<dl class="<%= activeModule.getConfigEntry("Lang")%>">
		<%
			Integer resultStart = new Integer(request.getParameter("start") != null ? request.getParameter("start") : "0");
			Integer resultLimit = new Integer(30);
			boolean rtol = ("RtoL".equalsIgnoreCase(activeModule.getConfigEntry("Direction")));

			for (int i = resultStart.intValue(); i < results.length && i < resultStart.intValue() + resultLimit.intValue(); i++)
			{
				activeModule.setKeyText(results[i].key);
				String dispKey = results[i].key;
		%>
				<dt>
					<a href="<%= ("GBS".equals(lastModType))?"bookdisplay.jsp?gbsEntry=":"passagestudy.jsp?key=" %><%= URLEncoder.encode(dispKey)+"#cv" %>" title="<%= dispKey %>"><%= dispKey %></a>
				
				</dt>
				
				<dd dir="<%= rtol ? "rtl" : "" %>">
					<%= activeModule.getRenderText() %>
				</dd>

		<%
			}
		%>

		</dl>

		<ul class="searchresultsnav">
			<%
				int navStart = (resultStart.intValue() / resultLimit.intValue()) - 5;
				if (navStart < 0) {
					navStart = 0;
				}

				int navEnd = navStart + 10;
				if ( navEnd*resultLimit.intValue() > results.length ) {
					navEnd = (results.length / resultLimit.intValue()) + ((results.length % resultLimit.intValue()) > 0 ? 1 : 0);
				}
			%>

			<li><t:t>Result Page:</t:t></li>

		<%
			if ( navStart > 0 ) {
		%>
				<li><a href="wordsearchresults.jsp?start=0" title="<t:t>First page (</t:t><%= results[0].key %><t:t>) of search results</t:t>">1</a>&nbsp;[...]</li>
		<%
			}
			else {
				if (results.length < resultLimit.intValue()) {
		%>
					<li><%= 1 %></li>
		<%
				}
			}
			String linkOptions = "";
			if (colorKeys != null) {
				for (int k = 0; k < colorKeys.length; k++) {
					linkOptions += "colorKey=" + colorKeys[k] + "&";  // we always force a final param to let this & be ok
				}
			}
			linkOptions += "colorMorph=" + colorMorph;

			for (int i = navStart; i < navEnd; ++i) {
				if (i == (resultStart.intValue() / resultLimit.intValue())) {
		%>
					<li><%= i+1 %></li>
		<%		}
				else {
		%>
					<li><a href="wordsearchresults.jsp?start=<%= i * resultLimit.intValue() %>&<%= linkOptions %>" title="<t:t>page </t:t><%= i+1 %> (<%= results[i * resultLimit.intValue()].key %><t:t>) of search results</t:t>"><%= i+1 %></a></li>
		<%
				}
			}
			int lastPage = (results.length / resultLimit.intValue()) + ((results.length % resultLimit.intValue()) > 0 ? 1 : 0) -1;
			if (navEnd < lastPage) {
		%>
				<li>&nbsp;[...] <a href="wordsearchresults.jsp?start=<%= lastPage*resultLimit.intValue() %>&<%= linkOptions %>" title="<t:t>>Last page (</t:t><%= results[lastPage].key %><t:t>) of search results</t:t>"><%= lastPage+1 %></a></li>
		<%
			}
		%>
		</ul>
	</div>

	</tiles:put>
</tiles:insert>
