<%@ include file="defines/defines.jsp" %>

<%
	String addModule = (String)request.getParameter("add");
	if (addModule != null) {
		SWModule m = mgr.getModuleByName( addModule );
		if (m != null) {
			parDispModules.remove(addModule);
			parDispModules.add(parDispModules.size(),addModule);
		}
	}

	String delModule = (String)request.getParameter("del");
	if (delModule != null) {
		parDispModules.remove(delModule);
	}


	if (parDispModules.size() == 0) {
		parDispModules.add(0, "KJV");
	}

	SWModule activeModule = mgr.getModuleByName((String)parDispModules.get(0));

	String resetKey = request.getParameter("key");
	if (resetKey != null)
		session.setAttribute("ActiveKey", resetKey);
	String activeKey = (String) session.getAttribute("ActiveKey");
	if (activeKey == null)
		activeKey = "jas 1:19";
%>


<tiles:insert beanName="basic" flush="true" >
	<%-- override lookup URL, so this script is used to display the keys --%>
	<tiles:put name="lookup_url" value="parallelstudy.jsp" />

	<tiles:put name="title" value="Parallel Bible study" />
	<tiles:put name="sidebar_left" type="string">
	      	<h2>Translations:</h2>
		<p class="textname">Displayed modules (click to remove)</p>
		<ul>

		<%
			for (int i = 0; i < parDispModules.size(); i++) {
				SWModule module = mgr.getModuleByName((String)parDispModules.get(i));
				if (module != null && module.getType().equals(SwordOrb.BIBLES)) {
		%>

					<li><a href="parallelstudy.jsp?del=<%= URLEncoder.encode(module.getName()) %>" title="Remove from displayed modules"><%= module.getDescription().replaceAll("&", "&amp;") %></a></li>
		<%
				}
			}
		%>

		</ul>

		<hr/>

		<p class="textname">Available modules (click to add)</p>
		<ul>
		<%
			for (int i = 0; i < modInfo.length; i++) {
				if (modInfo[i].type.equals(SwordOrb.BIBLES)) {
					SWModule module = mgr.getModuleByName(modInfo[i].name);
					if ( parDispModules.contains(module.getName()) ) {
						continue;
					}

		%>
				<li><a href="parallelstudy.jsp?add=<%= URLEncoder.encode(modInfo[i].name) %>" title="Add to displayed modules"><%= module.getDescription().replaceAll("&", "&amp;") %></a></li>
		<%
				}
			}
		%>
		</ul>

	</tiles:put>
	<tiles:put name="sidebar_right" type="string">
      		<h2>Comentaries:</h2>
		<p class="textname">Displayed modules (click to remove)</p>
      		<ul>

		<%
			for (int i = 0; i < parDispModules.size(); i++) {
				SWModule module = mgr.getModuleByName((String)parDispModules.get(i));
				if (module != null && module.getType().equals(SwordOrb.COMMENTARIES)) {
		%>
				<li><a href="parallelstudy.jsp?del=<%= URLEncoder.encode(module.getName()) %>" title="Remove from displayed modules"><%= module.getDescription().replaceAll("&", "&amp;") %></a></li>
		<%
				}
			}
		%>
		</ul>

		<hr/>

		<p class="textname">Available modules (click to add)</p>
		<ul>
		<%
			for (int i = 0; i < modInfo.length; i++) {
				if (modInfo[i].type.equals(SwordOrb.COMMENTARIES)) {
					SWModule module = mgr.getModuleByName(modInfo[i].name);
					if ( parDispModules.contains(module.getName()) ) {
						continue;
					}
		%>
				<li><a href="parallelstudy.jsp?add=<%= URLEncoder.encode(modInfo[i].name) %>" title="Add to displaued modules"><%= module.getDescription().replaceAll("&", "&amp;") %></a></li>
		<%
				}
			}
		%>
		</ul>

	</tiles:put>
	<tiles:put name="content" type="string">
		<%
			if (activeModule != null) {
				activeModule.setKeyText(activeKey);
				activeKey = activeModule.getKeyText(); 	// be sure it's formatted nicely
			}
		%>
		<h2><%= activeKey %></h2>
		<p class="textname">&raquo; <%= activeModule.getDescription().replaceAll("&", "&amp;") + " (" + activeModule.getName() + ")" %></p>
		<ul class="booknav">
			<li><a href="" title="display Romans 7">previous chapter</a></li>
			<li><a href="" title="display all of Romans 8">this chapter</a></li>
			<li><a href="" title="display Romans 10">next chapter</a></li>
		</ul>
		<%
			activeModule = mgr.getModuleByName((String)parDispModules.get(0));
			if (activeModule.getType().equals(SwordOrb.BIBLES) ||
			    activeModule.getType().equals(SwordOrb.COMMENTARIES))
			{
		%>
			<div style="clear:both;float:left;display:table-row;width:100%;"">
		<% //insert module names at the top
				for (int i = 0; i < parDispModules.size(); i++) {
					SWModule mod = mgr.getModuleByName((String)parDispModules.get(i));
		%>
					<div style="padding:3px; float:left; text-align:left; display:table-cell; width:<%= 100/parDispModules.size() %>%;">
					<b><%= mod.getDescription() %></b>
					</div>
		<%
				}
		%>
			</div>
		<%
				String chapterPrefix = activeKey.substring(0, activeKey.indexOf(":"));
				for (activeModule.setKeyText(chapterPrefix + ":1"); (activeModule.error() == (char)0); activeModule.next()) {
					String keyText = activeModule.getKeyText();
					if (!chapterPrefix.equals(keyText.substring(0, keyText.indexOf(":"))))
						break;

		%>
					<div style="clear:both;float:left;display:table-row;width:100%;">
		<%
					for (int i = 0; i < parDispModules.size(); i++) {
						SWModule mod = mgr.getModuleByName((String)parDispModules.get(i));
						if (mod != activeModule)
							mod.setKeyText( keyText );
						boolean rtol = ("RtoL".equalsIgnoreCase(mod.getConfigEntry("Direction")));
		%>
						<div style="float:left;display:table-cell;padding:3px;width:<%= 100/parDispModules.size() %>%; <%= i<parDispModules.size() ? "padding-right:10px;" : ""%>" dir="<%= rtol ? "rtl" : "ltr" %>" class="<%= (keyText.equals(activeKey)) ? "currentverse" : "verse" %>">
						<span class="versenum">
							<a href="parallelstudy.jsp?key=<%= URLEncoder.encode(keyText) %>">
								<%= keyText.substring(keyText.indexOf(":")+1) %>
							</a>
						</span>

							<%= new String(mod.getRenderText().getBytes("iso-8859-1"), "UTF-8") %>
						</div>

		<%
					}
		%>

					</div>
			<%
				}
			}
			%>
	</tiles:put>
</tiles:insert>