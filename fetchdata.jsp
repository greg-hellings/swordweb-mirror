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

	// hack until LXXM morph is cleaned up -----
	if ("Packard".equals(modName)) {
		while (key.indexOf("  ") > -1) key = key.replaceAll("  ", " ");
	}
	// end of LXXM Packard hack ----------------

	if (!"betacode".equals(modName)) {
		if (modName != null) {
			book = mgr.getModuleByName(modName);
		}
		if ((key != null) && (book != null)) {
			book.setKeyText(key);
%>
			<%= new String(book.getRenderText().getBytes("iso8859-1"), "UTF-8") %>
<%
		}
	}
	// betacode lookup from perseus
	else {
		key = new String(key.getBytes("iso8859-1"), "UTF-8");
		String ls = org.crosswire.swordweb.PerseusUtils.getLiddellScottDef(key);
		if (ls.length() > 15+key.length()) {
%>
		<%= ls %>
<div class="copyLine">from Liddell and Scott, <i>An Intermediate Greek-English Lexicon</i><br/>
Courtesy of <a href="http://www.perseus.tufts.edu">Perseus Digital Library</a></div>
<%
		}
		else {
%>
		<%= key %>
<%
		}
	}
%>
