<%@ include file="defines/tiles.jsp" %>
<%
	String resetModule = request.getParameter("mod");
	if (resetModule != null)
		session.setAttribute("ActiveModule", resetModule);
	String activeModuleName = (String) session.getAttribute("ActiveModule");
	SWModule activeModule = mgr.getModuleByName((activeModuleName == null) ? "WEB" : activeModuleName);

	String resetKey = request.getParameter("key");
	if (resetKey != null)
		session.setAttribute("ActiveKey", resetKey);
	String activeKey = (String) session.getAttribute("ActiveKey");
	if (activeKey == null)
		activeKey = "jas 1:19";
%>

<tiles:insert beanName="basic" flush="true" >
	<tiles:put name="title" value="Passage Bible study" />
	<tiles:put name="sidebar_left" type="string">
		<div id="translations">
		<h2>Translations:</h2>
      	<ul>
		<%
			for (int i = 0; i < prefBibles.size(); i++) {
				SWModule module = mgr.getModuleByName((String)prefBibles.get(i));
		%>
				<li><a href="passagestudy.jsp?mod=<%= URLEncoder.encode(module.getName())+"#cv" %>" title="view Romans 8:26-39 in <%= module.getDescription().replaceAll("&", "&amp;") %>"><%= module.getDescription().replaceAll("&", "&amp;") %></a></li>
		<%
			}
		%>
		</ul>
		<hr/>

		<ul>
		<%
			for (int i = 0; i < modInfo.length; i++) {
				if (modInfo[i].category.equals(SwordOrb.BIBLES)) {
					SWModule module = mgr.getModuleByName(modInfo[i].name);
		%>
				<li><a href="passagestudy.jsp?mod=<%= URLEncoder.encode(modInfo[i].name)+"#cv" %>" title="view Romans 8:26-39 in <%= module.getDescription().replaceAll("&", "&amp;") %>"><%= module.getDescription().replaceAll("&", "&amp;") %></a></li>
		<%
				}
			}
		%>
		</ul>
		</div>
	</tiles:put>
	<tiles:put name="sidebar_right" type="string">
		<div id="commentaries">
		<h2>Comentaries:</h2>
	      	<ul>

		<%
			for (int i = 0; i < prefCommentaries.size(); i++) {
				SWModule module = mgr.getModuleByName((String)prefCommentaries.get(i));
		%>
				<li><a href="passagestudy.jsp?mod=<%= URLEncoder.encode(module.getName())+"#cv" %>" title="view Romans 8:26-39 in <%= module.getDescription().replaceAll("&", "&amp;") %>"><%= module.getDescription().replaceAll("&", "&amp;") %></a></li>
		<%
			}
		%>
		</ul>
		<hr />
		<ul>
		<%
			for (int i = 0; i < modInfo.length; i++) {
				if (modInfo[i].category.equals(SwordOrb.COMMENTARIES)) {
					SWModule module = mgr.getModuleByName(modInfo[i].name);
		%>
				<li><a href="passagestudy.jsp?mod=<%= URLEncoder.encode(modInfo[i].name)+"#cv" %>" title="view Romans 8:26-39 in <%= module.getDescription().replaceAll("&", "&amp;") %>"><%= module.getDescription().replaceAll("&", "&amp;") %></a></li>
		<%
				}
			}
		%>
		</ul>
		</div>

	</tiles:put>
	<tiles:put name="content" type="string">
		<%
			activeModule.setKeyText(activeKey);
			activeKey = activeModule.getKeyText(); 	// be sure it's formatted nicely
		%>
		<h2><%= activeKey %></h2>
		<p class="textname">&raquo; <%= activeModule.getDescription().replaceAll("&", "&amp;") + " (" + activeModule.getName() + ")" %></p>
		<ul class="booknav">
			<li><a href="" title="display Romans 7">previous chapter</a></li>
			<li><a href="" title="display all of Romans 8">this chapter</a></li>
			<li><a href="" title="display Romans 10">next chapter</a></li>
		</ul>
		<%
			if (activeModule.getCategory().equals(SwordOrb.BIBLES)) {
				String chapterPrefix = activeKey.substring(0, activeKey.indexOf(":"));
				for (activeModule.setKeyText(chapterPrefix + ":1"); (activeModule.error() == (char)0); activeModule.next()) {
					String keyText = activeModule.getKeyText();
					if (!chapterPrefix.equals(keyText.substring(0, keyText.indexOf(":"))))
						break;
					boolean rtol = ("RtoL".equalsIgnoreCase(activeModule.getConfigEntry("Direction")));
			%>
				<div dir="<%= rtol ? "rtl" : "ltr" %>" class="<%= (keyText.equals(activeKey)) ? "currentverse" : "verse" %>">
					<span class="versenum"><a <%= (keyText.equals(activeKey))?"name=\"cv\"":"" %> href="passagestudy.jsp?key=<%= URLEncoder.encode(keyText)+"#cv" %>">
						<%= keyText.substring(keyText.indexOf(":")+1) %></a>
					</span>

					<%= new String(activeModule.getRenderText().getBytes("iso8859-1"), "UTF-8") %>
				</div>
			<%
				}
			}
			else {
			%>
				<div class="verse">
				<span class="versenum"><%= activeKey %></span>
					<%= new String(activeModule.getRenderText().getBytes("iso8859-1"), "UTF-8") %>
				</div>
		<%
			}
		%>
	</tiles:put>
</tiles:insert>
