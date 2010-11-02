<%@ page
    language="java"
    contentType="text/html;charset=utf-8"
%>

<%@ page import="org.crosswire.sword.orb.*" %>



<%
	SWMgr mgr = SwordOrb.getSWMgrInstance(request);
	SWModule book = mgr.getModuleByName("KJV");
%>

<html>
<body>

<h1>SWORDWeb Lookup Example</h1>

<%
	book.setKeyText("jn3:16");
%>
<p>The <%= book.getDescription() %>'s entry for <%= book.getKeyText() %> is:</p>
<p><%= book.getRenderText() %></p>


</body>
</html>
