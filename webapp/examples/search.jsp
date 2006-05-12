<%@ page
    language="java"
    contentType="text/html;charset=utf-8"
%>

<%@ page import="org.crosswire.sword.orb.*" %>



<%
	SWMgr mgr = SwordOrb.getSWMgrInstance(request);
	SWModule book = mgr.getModuleByName("NASB");
%>

<html>
<body>

<h1>SWORDWeb Search Example</h1>

<%
	String searchTerm = "God love world";
	SearchType searchType = SearchType.MULTIWORD;
	int searchOptions = 2;	// 2=ignore case. cheezy, should be a define
	String searchRange = "";  // use anything intelligible, eg. "mat-joh5;acts"

	SearchHit[] results = book.search(searchTerm, searchType, searchOptions, searchRange);
%>

<p> There are <%= results.length %> results searching for "<%= searchTerm %>" in <%= book.getName() %></p>
<table border="1">
<tr><th>Reference</th><th>Text</th></tr>

<%
	for (int i = 0; i < results.length && i < 100; i++) {
		book.setKeyText(results[i].key);
%>

<tr><td><%= book.getKeyText() %></td><td><%= new String(book.getRenderText().getBytes("iso8859-1"), "UTF-8") %></td></tr>

<%
	}
%>

</table>


</body>
</html>

