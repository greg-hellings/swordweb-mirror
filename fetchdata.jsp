<%@ page
    language="java"
    contentType="text/html;charset=utf-8"
%>

<%@ page import="org.crosswire.sword.orb.*" %>

<%
	SWMgr mgr = SwordOrb.getSWMgrInstance(session);
	SWModule book = null;
	String key = request.getParameter("key");
	String modName = request.getParameter("mod");
	if (modName != null) {
		book = mgr.getModuleByName(modName);
	}
	if ((key != null) && (book != null)) {
		book.setKeyText(key);
%>
		<%= new String(book.getRenderText().getBytes("iso8859-1"), "UTF-8") %>
<%
	}
%>
