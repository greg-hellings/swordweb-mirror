<%@ include file="defines/tiles.jsp" %>

<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%
	String resetModule = request.getParameter("mod");
	if (resetModule != null)
		session.setAttribute("ActiveDevo", mgr.getModuleByName(resetModule));
	SWModule activeDevo = (SWModule) session.getAttribute("ActiveDevo");
	if (activeDevo == null) activeDevo = mgr.getModuleByName("SME");

	SimpleDateFormat formatter;
%>


<tiles:insert beanName="basic" flush="true" >
	<tiles:put name="title" value="Daily devotional" />
	<tiles:put name="sidebar_left" type="string">
		<h2>Daily Devotionals:</h2>
		<ul>
		<%
			for (int i = 0; i < modInfo.length; i++) {
				SWModule module = mgr.getModuleByName(modInfo[i].name);
				if (("Daily Devotional".equals(modInfo[i].type)) ||
					 ("Daily Devotional".equals(module.getConfigEntry("Category")))) {
	%>
			<li><a href="dailydevotion.jsp?mod=<%= URLEncoder.encode(modInfo[i].name) %>" title="Add <%= module.getDescription().replaceAll("&", "&amp;") %>"><%= module.getDescription().replaceAll("&", "&amp;") %></a></li>
	<%
				}
			}
			formatter = new SimpleDateFormat("MM.dd");
			activeDevo.setKeyText(formatter.format(new Date()));
		%>
		</ul>

	</tiles:put>

	<tiles:put name="sidebar_right" type="string">
	</tiles:put>

	<tiles:put name="content" type="string">
		<%
			formatter = new SimpleDateFormat("EEEE, MMM dd");
		%>
		<h2>Today's Devotion (<%= formatter.format(new Date()) %>)</h2>
		<br/>
		From:
		<p class="textname">&raquo; <%= activeDevo.getDescription().replaceAll("&", "&amp;") + " (" + activeDevo.getName() + ")" %></p>
		<br/>
		<div class="verse">
			<%= new String(activeDevo.getRenderText().getBytes(), "UTF-8") %>
		</div>
	</tiles:put>
</tiles:insert>
