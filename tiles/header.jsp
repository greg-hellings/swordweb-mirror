<%@ include file="../init.jsp" %>

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
	for (int i = 0; i < tabNames.size(); i++) {
		String u = (String)request.getRequestURI();
		String n = (String)tabNames.get(i);
		String t = (String)tabTitles.get(i);
		String l = (String)tabLinks.get(i);
		boolean show = !("false".equals((String)showTabs.get(i)));
		if ((show) || ("preferences.jsp".equals(l))) {
%>
      <li><a <%= (u.endsWith(l))?"id=\"current\"":"" %> href="<%= l %>" title="<%= t %>"><%= n %></a></li>
<%		}
	}	%>
    </ul>
  </div>
