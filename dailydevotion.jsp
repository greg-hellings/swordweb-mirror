<%@ include file="defines/tiles.jsp" %>

<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%
	String resetModule = request.getParameter("mod");
	if (resetModule != null)
		session.setAttribute("ActiveDevo", resetModule);
	String activeDevoName = (String) session.getAttribute("ActiveDevo");
	SWModule activeDevo = mgr.getModuleByName((activeDevoName == null) ? "SME" : activeDevoName);

	SimpleDateFormat formatter;
%>


<tiles:insert beanName="basic" flush="true" >
	<tiles:put name="title" value="Daily devotional" />
	<tiles:put name="pintro" type="string" ><div></div></tiles:put>
	<tiles:put name="sidebar_left" type="string">
<div id="devotionals">
		<h2>Daily Devotionals:</h2>
		<ul>
		<%
			for (int i = 0; i < modInfo.length; i++) {
				SWModule module = mgr.getModuleByName(modInfo[i].name);
				if ((SwordOrb.DAILYDEVOS.equals(modInfo[i].category)) ||
					 (SwordOrb.DAILYDEVOS.equals(module.getConfigEntry("Category")))) {
	%>
			<li><a href="dailydevotion.jsp?mod=<%= URLEncoder.encode(modInfo[i].name) %>" title="Add <%= module.getDescription().replaceAll("&", "&amp;") %>"><%= module.getDescription().replaceAll("&", "&amp;") %></a></li>
	<%
				}
			}
			formatter = new SimpleDateFormat("MM.dd");
			activeDevo.setKeyText(formatter.format(new Date()));
		%>
		</ul>
</div>
	</tiles:put>

	<tiles:put name="sidebar_right" type="string">
	</tiles:put>

	<tiles:put name="content" type="string">
		<%
			formatter = new SimpleDateFormat("EEEE, MMM dd");
		%>
<div id="daily">
		<h2>Today's Devotion (<%= formatter.format(new Date()) %>)</h2>

		<h3>; <%= activeDevo.getDescription().replaceAll("&", 
"&amp;") + " (" + activeDevo.getName() + ")" %></h3>

		<div class="verse">
			<%= new String(activeDevo.getRenderText().getBytes(), "UTF-8") %>
		</div>
</div>
	</tiles:put>
</tiles:insert>
