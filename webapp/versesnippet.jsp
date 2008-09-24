<%@ page
    language="java"
    contentType="text/html;charset=utf-8"
%>
<%@ page import="org.crosswire.sword.orb.*" %>
<%@ page import="java.net.URLEncoder" %>
<%

	SWMgr mgr = SwordOrb.getSWMgrInstance(request);
	SWModule book = null;
	String ks = request.getParameter("key");
	String modName = request.getParameter("mod");

	if ((modName != null) && (ks != null)) {
		book = mgr.getModuleByName(modName);
		if (book != null) {
			String k[] = book.parseKeyList(ks);
			for (int i = 0; i < k.length; i++) {
				String key = k[i];
				book.setKeyText(key);
		%>
				<div>
					<%= book.getRenderText() %>
				</div>
		<%
			}
		}
	}
%>
