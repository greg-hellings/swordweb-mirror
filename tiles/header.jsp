<%@ taglib uri="/WEB-INF/lib/crosswire-i18n.tld" prefix="t" %>
<%@ page import="java.util.Vector" %>
<div id="contentTray0">
<div id="contentTray1">
<div id="contentTray2">
  <div id="pageBorderTop"></div>
  <div id="header">
    <h1>The Bible Tool</h1>
  </div>
  <div id="navlist">
    <ul>
<%
	Vector [] tabs = (Vector[])session.getAttribute("tabs");
	Vector showTabs = (Vector)session.getAttribute("showTabs");
	for (int i = 0; i < tabs[0].size(); i++) {
		String u = (String)request.getRequestURI();
		String n = (String)tabs[0].get(i);
		String t = (String)tabs[1].get(i);
		String l = (String)tabs[2].get(i);
		boolean show = !("false".equals((String)showTabs.get(i)));
		if ((show) || ("preferences.jsp".equals(l))) {
%>
      <li><a <%= (u.endsWith(l))?"id=\"current\"":"" %> href="<%= l %>" title="<%= t %>"><t:t><%= n %></t:t></a></li>
<%		}
	}	%>
    </ul>
  </div>
