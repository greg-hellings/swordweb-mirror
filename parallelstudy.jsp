<%@ include file="defines/tiles.jsp" %>
<%
	String []addMods = request.getParameterValues("add");
	if (addMods != null) {
		for (int i = 0; i < addMods.length; i++) {
			String addModule = addMods[i];
			if (addModule != null) {
				SWModule m = mgr.getModuleByName(addModule);
				if (m != null) {
					parDispModules.remove(addModule);
					parDispModules.add(parDispModules.size(), addModule);
				}
			}
		}
	}

	String delModule = (String)request.getParameter("del");
	if ( (delModule != null) && parDispModules.contains(delModule)) {
		parDispModules.remove(delModule);
	}

	if (parDispModules.size() == 0) {
		parDispModules.add(0, "WEB"); //our standard, fallback module
	}

	SWModule activeModule = mgr.getModuleByName((String)parDispModules.get(0));

	String resetKey = request.getParameter("key");
	if (resetKey != null)
		session.setAttribute("ActiveKey", resetKey);
	String activeKey = (String) session.getAttribute("ActiveKey");
	if (activeKey == null)
		activeKey = "jas 1:19"; // our fallback key
%>


<tiles:insert beanName="basic" flush="true" >
	<%-- override lookup URL, so this script is used to display the keys --%>
	<tiles:put name="lookup_url" value="parallelstudy.jsp" />
	<tiles:put name="title" value="Parallel Bible study" />

	<tiles:put name="sidebar_left" type="string">

		<div id="translations">

		<h2>Translations:</h2>
		<h3>Displayed modules </h3>
		<p>click to remove</p>
		<% if (parDispModules.size() > 0) { %>
		<ul>
		<%
			for (int i = 0; i < parDispModules.size(); i++) {
				SWModule module = mgr.getModuleByName((String)parDispModules.get(i));
				if (module != null && module.getCategory().equals(SwordOrb.BIBLES)) {
		%>
					<li>
						<a href="parallelstudy.jsp?del=<%= URLEncoder.encode(module.getName()) %>#cv" title="Remove from displayed modules">
							<%= module.getDescription().replaceAll("&", "&amp;") %>
						</a>
					</li>
		<%
				}
			}
		%>

		</ul>
		<% } %>


		<hr/>

		<h3>Available modules</h3><p>click to add</p>
		<% if (modInfo.length > 0) { %>

		<ul>
		<%
			for (int i = 0; i < modInfo.length; i++) {
				if (modInfo[i].category.equals(SwordOrb.BIBLES)) {
					SWModule module = mgr.getModuleByName(modInfo[i].name);
					if ( parDispModules.contains(module.getName()) ) {
						continue;
					}

		%>
				<li>
					<a href="parallelstudy.jsp?add=<%= URLEncoder.encode(modInfo[i].name) %>#cv" title="Add to displayed modules">
						<%= module.getDescription().replaceAll("&", "&amp;") %>
					</a>
				</li>
		<%
				}
			}
		%>
		</ul>
		<% } %>

		</div>

	</tiles:put>

	<tiles:put name="sidebar_right" type="string">

		<div id="commentaries">

		<h2>Comentaries:</h2>

		<h3>Displayed modules</h3> <p>click to remove</p>
		<% if (parDispModules.size() > 0) { %>
		<ul>
		<%
			for (int i = 0; i < parDispModules.size(); i++) {
				SWModule module = mgr.getModuleByName((String)parDispModules.get(i));
				if (module != null && module.getCategory().equals(SwordOrb.COMMENTARIES)) {
		%>
				<li>
					<a href="parallelstudy.jsp?del=<%= URLEncoder.encode(module.getName()) %>#cv" title="Remove from displayed modules">
						<%= module.getDescription().replaceAll("&", "&amp;") %>
					</a>
				</li>
		<%
				}
			}
		%>
		</ul>
		<% } %>

		<hr/>

		<h3>Available modules</h3> <p>click to add</p>
		<% if (modInfo.length > 0) { %>
		<ul>
		<%
			for (int i = 0; i < modInfo.length; i++) {
				if (modInfo[i].category.equals(SwordOrb.COMMENTARIES)) {
					SWModule module = mgr.getModuleByName(modInfo[i].name);
					if ( parDispModules.contains(module.getName()) ) {
						continue;
					}
		%>
				<li>
					<a href="parallelstudy.jsp?add=<%= URLEncoder.encode(modInfo[i].name) %>#cv" title="Add to displayed modules">
						<%= module.getDescription().replaceAll("&", "&amp;") %>
					</a>
				</li>
		<%
				}
			}
		%>
		</ul>
		<% } %>

		</div>

	</tiles:put>
	<tiles:put name="content" type="string">
		<%
			if (activeModule != null) {
				activeModule.setKeyText(activeKey);
				activeKey = activeModule.getKeyText(); 	// be sure it's formatted nicely
			}
		%>

		<div id="paralleldisplay">

		<h2>Parallel Viewing: <%= activeKey %></h2>
		<p>
		Parallel viewing allows you to see two or more texts side by side.
		For example, you could view two Bible versions of the same verse next to
		each other, or a verse from a specific translation and what a commentary
		has to say about that specific verse.
		</p>

		<ul class="booknav">
			<%= activeKey %>
			<li><a href="">previous chapter</a></li>
			<li><a href="">this chapter</a></li>
			<li><a href="">next chapter</a></li>
		</ul>


		<%-- table which contains all verse items --%>
		<table>
		<caption>
		</caption>
		<thead>

		<%
			activeModule = mgr.getModuleByName((String)parDispModules.get(0));
			if (activeModule.getCategory().equals(SwordOrb.BIBLES) ||
			    activeModule.getCategory().equals(SwordOrb.COMMENTARIES))
			{
		%>

		<tr>

		<% //insert module names at the top
				for (int i = 0; i < parDispModules.size(); i++) {
					SWModule mod = mgr.getModuleByName((String)parDispModules.get(i));
		%>
					<th>
						&quot;<%= mod.getDescription().replaceAll("&", "&amp;") + " (" + mod.getName() + ")" %>&quot;
					</th>
		<%
				}
		%>

		</tr>
		</thead>

		<tbody>
		<%
				String chapterPrefix = activeKey.substring(0, activeKey.indexOf(":"));
				for (activeModule.setKeyText(chapterPrefix + ":1"); (activeModule.error() == (char)0); activeModule.next()) {
					String keyText = activeModule.getKeyText();
					if (!chapterPrefix.equals(keyText.substring(0, keyText.indexOf(":"))))
						break;

		%>
					<tr>
		<%
					for (int i = 0; i < parDispModules.size(); i++) {
						SWModule mod = mgr.getModuleByName((String)parDispModules.get(i));
						boolean rtol = ("RtoL".equalsIgnoreCase(mod.getConfigEntry("Direction")));

						if (mod != activeModule)
							mod.setKeyText( keyText );
		%>
							<td width="<%= 100/parDispModules.size() %>%" dir="<%= rtol ? "rtl" : "ltr" %>" class="<%= (keyText.equals(activeKey)) ? "currentverse" : "verse" %>">
								<span class="versenum">
									<a <%= (keyText.equals(activeKey)) ? "name=\"cv\"" : "" %> href="parallelstudy.jsp?key=<%= URLEncoder.encode(keyText) %>#cv">
										<%= keyText.substring(keyText.indexOf(":")+1) %>
									</a>
								</span>

					<%
						boolean utf8 = ("UTF-8".equalsIgnoreCase(mod.getConfigEntry("Encoding")));
						if (utf8) {
							out.println("<span class=\"unicode\">");
						}
						%>

						<%= new String(mod.getRenderText().getBytes("iso8859-1"), "UTF-8") %>

						<%
						if (utf8) {
							out.println("</span>");
						}
					%>

					</td>
		<%
					}
		%>
				</tr>
		<%
				}
			}
		%>

		</tbody>
		</table>

		</div>
	</tiles:put>
</tiles:insert>
