<%@ page
    language="java"
    contentType="text/html;charset=utf-8"
%>
<%@ page import="org.crosswire.sword.orb.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.util.Comparator" %>
<%@ page import="java.net.URL" %>
<%
	int MAX_RESULTS = 100;

	String requestURI = request.getRequestURI();
	int pe = requestURI.lastIndexOf('/', requestURI.length()-2);
	requestURI = (pe > 0) ? requestURI.substring(0, pe) : "";
	URL baseURL = new URL(request.getScheme(), request.getServerName(), request.getServerPort(), requestURI);
	URL appBaseURL = new URL(request.getScheme(), request.getServerName(), request.getServerPort(), "/study/");

	SWMgr mgr = SwordOrb.getSWMgrInstance(request);

	String colorKeys[] = request.getParameterValues("colorKey");
	String colorMorph  = request.getParameter("colorMorph");
	String activeModuleName = request.getParameter("mod");
	if (activeModuleName == null) activeModuleName = "WHNU";
	SWModule activeModule = mgr.getModuleByName(activeModuleName);

	String activeSearchTerm = request.getParameter("searchTerm");
	// assert we have a search term
	if (activeSearchTerm == null) return;
	activeSearchTerm = new String(activeSearchTerm.getBytes("iso8859-1"), "UTF-8");
	mgr.setGlobalOption("Greek Accents", "Off");
	activeSearchTerm = mgr.filterText("Greek Accents", activeSearchTerm);
	mgr.setGlobalOption("Greek Accents", "On");

	String range = "";
	String tmp = request.getParameter("range");
	if (tmp != null) {
		range = tmp;
	}

	SearchType stype = (activeModule.hasSearchFramework()) ? SearchType.LUCENE : SearchType.MULTIWORD;
	tmp = request.getParameter("stype");
	if (tmp != null) {
		if (tmp.equalsIgnoreCase("P")) {
			stype = SearchType.PHRASE;
		}
		if (tmp.equalsIgnoreCase("R")) {
			stype = SearchType.REGEX;
		}
	}

	int soptions = 0;	// default to NOT ignore case
	tmp = request.getParameter("icase");
	if ((tmp != null) && (tmp.equals("1"))) {
		soptions = 2;
	}

	SearchHit[] results = null;
	if ((activeSearchTerm != null) && (activeSearchTerm.trim().length() > 0)) {
		mgr.setGlobalOption("Greek Accents", "Off");
		results = activeModule.search(activeSearchTerm, stype, soptions, range);
/*
		// let's make some intuitive decisions on when to sort by score
		if ((results.length > 100) && (activeSearchTerm.indexOf(" ") > 0)
				 && (activeSearchTerm.indexOf("+") < 1)
				 && (activeSearchTerm.indexOf("\"") < 1)
				 && (activeSearchTerm.indexOf("~") < 1)
				) {
*/
			Arrays.sort(results, new Comparator() {
				public int compare(Object o1, Object o2) {
					return ((SearchHit)o2).score - ((SearchHit)o1).score;
				}
			});
//		}
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
<%= (results.length > MAX_RESULTS) ? "Showing " + MAX_RESULTS : results.length %>%%%
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
<div>
	<div>
		<dl class="<%= activeModule.getConfigEntry("Lang")%>">
		<%
			Integer resultStart = new Integer(request.getParameter("start") != null ? request.getParameter("start") : "0");
			Integer resultLimit = new Integer(MAX_RESULTS);
			boolean rtol = ("RtoL".equalsIgnoreCase(activeModule.getConfigEntry("Direction")));

			for (int i = resultStart.intValue(); i < results.length && i < resultStart.intValue() + resultLimit.intValue(); i++)
			{
				activeModule.setKeyText(results[i].key);
				String dispKey = results[i].key;
		%>
				<dt>
					<a href="#" onclick="lookup('<%= dispKey %>'); return false;" title="<%= dispKey %>"><%= dispKey %></a>
				
				</dt>
				
				<dd dir="<%= rtol ? "rtl" : "" %>">
					<%= activeModule.getRenderText() %>
				</dd>

		<%
			}
		%>

		</dl>
	</div>
</div>
