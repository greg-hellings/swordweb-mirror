<%@ include file="defines/defines.jsp" %>
<%
	String resetModule = request.getParameter("mod");
	if (resetModule != null)
		session.setAttribute("ActiveModule", mgr.getModuleByName(resetModule));
	SWModule activeModule = (SWModule) session.getAttribute("ActiveModule");
	if (activeModule == null) activeModule = mgr.getModuleByName("KJV");

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
	   	<h2>Translations:</h2>
      	   	<ul>
		<%
			for (int i = 0; i < prefBibles.size(); i++) {
				SWModule module = mgr.getModuleByName((String)prefBibles.get(i));
		%>
				<li><a href="passagestudy.jsp?mod=<%= URLEncoder.encode(module.getName()) %>" title="view Romans 8:26-39 in <%= module.getDescription().replaceAll("&", "&amp;") %>"><%= module.getDescription().replaceAll("&", "&amp;") %></a></li>
		<%
			}
		%>
		<hr/>
		<%
			for (int i = 0; i < modInfo.length; i++) {
				if (modInfo[i].type.equals(SwordOrb.BIBLES)) {
					SWModule module = mgr.getModuleByName(modInfo[i].name);
		%>
				<li><a href="passagestudy.jsp?mod=<%= URLEncoder.encode(modInfo[i].name) %>" title="view Romans 8:26-39 in <%= module.getDescription().replaceAll("&", "&amp;") %>"><%= module.getDescription().replaceAll("&", "&amp;") %></a></li>
		<%
				}
			}
		%>
		</ul>

	</tiles:put>
	<tiles:put name="sidebar_right" type="string">
		<h2>Comentaries:</h2>
	      	<ul>

		<%
			for (int i = 0; i < prefCommentaries.size(); i++) {
				SWModule module = mgr.getModuleByName((String)prefCommentaries.get(i));
		%>
				<li><a href="passagestudy.jsp?mod=<%= URLEncoder.encode(module.getName()) %>" title="view Romans 8:26-39 in <%= module.getDescription().replaceAll("&", "&amp;") %>"><%= module.getDescription().replaceAll("&", "&amp;") %></a></li>
		<%
			}
		%>
		<hr />
		<%
			for (int i = 0; i < modInfo.length; i++) {
				if (modInfo[i].type.equals(SwordOrb.COMMENTARIES)) {
					SWModule module = mgr.getModuleByName(modInfo[i].name);
		%>
				<li><a href="passagestudy.jsp?mod=<%= URLEncoder.encode(modInfo[i].name) %>" title="view Romans 8:26-39 in <%= module.getDescription().replaceAll("&", "&amp;") %>"><%= module.getDescription().replaceAll("&", "&amp;") %></a></li>
		<%
				}
			}
		%>
		</ul>

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
			if (activeModule.getType().equals(SwordOrb.BIBLES)) {
				String chapterPrefix = activeKey.substring(0, activeKey.indexOf(":"));
				for (activeModule.setKeyText(chapterPrefix + ":1"); (activeModule.error() == (char)0); activeModule.next()) {
					String keyText = activeModule.getKeyText();
					if (!chapterPrefix.equals(keyText.substring(0, keyText.indexOf(":"))))
						break;
					boolean rtol = ("RtoL".equalsIgnoreCase(activeModule.getConfigEntry("Direction")));
			%>
				<div class="<%= (keyText.equals(activeKey)) ? "currentverse" : "verse" %>">
		<%			if (!rtol) {	%>
				<span class="versenum"><a href="passagestudy.jsp?key=<%= URLEncoder.encode(keyText) %>"><%= keyText.substring(keyText.indexOf(":")+1) %></a></span>
		<%			}	%>

					<%= new String(activeModule.getRenderText().getBytes(), "UTF-8") %>
		<%			if (rtol) {	%>
				<span class="versenum"><a href="passagestudy.jsp?key=<%= URLEncoder.encode(keyText) %>"><%= keyText.substring(keyText.indexOf(":")+1) %></a></span>
		<%			}	%>
				</div>
			<%
				}
			}
			else {
			%>
				<div class="verse">
				<span class="versenum"><%= activeKey %></span>
					<%= new String(activeModule.getRenderText().getBytes(), "UTF-8") %>
				</div>
		<%
			}
		%>
	</tiles:put>
</tiles:insert>
