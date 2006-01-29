<%@ page
    language="java"
    contentType="text/html;charset=utf-8"
%>

<%@ page import="org.crosswire.sword.orb.*" %>


<%
	SWMgr mgr = SwordOrb.getSWMgrInstance(session);
%>

<html>
<body>

<h1>SWORDWeb Book List Example</h1>

<table border="1">
<tr><th>Name</th><th>Category</th><th>Description</th></tr>
<%
	ModInfo[] modInfo = mgr.getModInfoList();
	for (int i = 0; i < modInfo.length; i++) {
		SWModule book = mgr.getModuleByName(modInfo[i].name);
%>

<tr><td><%= modInfo[i].name %></td><td><%= modInfo[i].category %></td><td><%= book.getDescription() %></td></tr>

<%
	}
%>

</table>

</body>
</html>



