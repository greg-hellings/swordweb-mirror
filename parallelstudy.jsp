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
		parDispModules.add(0, "KJV"); //our standard, fallback module
	}

	SWModule activeModule = mgr.getModuleByName((String)parDispModules.get(0));

	String resetKey = request.getParameter("key");
	if (resetKey != null)
		session.setAttribute("ActiveKey", resetKey);
	String activeKey = (String) session.getAttribute("ActiveKey");
	if (activeKey == null)
		activeKey = "jas 1:19"; // our fallback key


	//taken from passagestudy.jsp. It's here useful, too.
	boolean strongs = "on".equals((String) session.getAttribute("strongs"));
	String buf = request.getParameter("strongs");
	strongs = (buf != null) ? "on".equalsIgnoreCase(buf) : strongs;
	session.setAttribute("strongs", (strongs)?"on":"off");

	boolean morph = "on".equals((String) session.getAttribute("morph"));
	buf = request.getParameter("morph");
	morph = (buf != null) ? "on".equalsIgnoreCase(buf) : morph;
	session.setAttribute("morph", (morph)?"on":"off");

%>


<tiles:insert beanName="basic" flush="true" >
	<%-- override lookup URL, so this script is used to display the keys --%>
	<tiles:put name="lookup_url" value="parallelstudy.jsp" />
	<tiles:put name="title" value="Parallel Bible study" />
	<tiles:put name="pintro" type="string" ><div></div></tiles:put>

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
		<div id="studytools">
			<h2>Word Study:</h2>
			<ul>
				<li><a href="parallelstudy.jsp?strongs=<%= (strongs) ? "off" : "on" %>" title="Turn <%= (strongs) ? "off" : "on"%> Strongs numbers"><%= (strongs) ? "Hide" : "Show" %> Strongs</a></li>
				<li><a href="parallelstudy.jsp?morph=<%= (morph) ? "off" : "on" %>" title="Turn <%= (morph) ? "off" : "on" %> morphology"><%= (morph) ? "Hide" : "Show" %> Morphology</a></li>
			</ul>
		</div>

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
		<div id="introhelp">
		<p>
		Parallel viewing allows you to see two or more texts side by side.
		For example, you could view two Bible versions of the same verse next to
		each other, or a verse from a specific translation and what a commentary
		has to say about that specific verse.
		</p>
		</div>

		<% //insert next and previous chapter links
			// activeKey contains the current key ATM
			// Split up into book, chapter and verse.
			// Then add and subtract 1 to the chapter to the next and previous one

			String bookname = activeKey.substring(0, activeKey.lastIndexOf(" "));
			int chapter = Integer.parseInt( activeKey.substring(activeKey.lastIndexOf(" ")+1, activeKey.indexOf(":")) );
			//int verse = Integer.parseInt(activeKey.substring(activeKey.indexOf(":")+1));

			String prevChapterString = bookname + " " + String.valueOf(chapter-1) + ":1";
			String nextChapterString = bookname + " " + String.valueOf(chapter+1) + ":1";

		%>
		<ul class="booknav">
			<li><a href="parallelstudy.jsp?key=<%= URLEncoder.encode(prevChapterString) %>" title="Display <%= prevChapterString %>">previous chapter</a></li>
			<!-- <li><a href="" title="display all of Romans 8">this chapter</a></li> -->
			<li><a href="parallelstudy.jsp?key=<%= URLEncoder.encode(nextChapterString) %>" title="Display <%= nextChapterString %>">next chapter</a></li>
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
			int activeVerse = Integer.parseInt(activeKey.substring(activeKey.indexOf(":")+1));
			for (activeModule.setKeyText(chapterPrefix + ":1"); (activeModule.error() == (char)0); activeModule.next()) {

				String keyText = activeModule.getKeyText();
				if (!chapterPrefix.equals(keyText.substring(0, keyText.indexOf(":"))))
					break;

				int curVerse = Integer.parseInt(keyText.substring(keyText.indexOf(":")+1));
				mgr.setGlobalOption("Strong's Numbers",
					((strongs) && (curVerse >= activeVerse -1) && (curVerse <= activeVerse + 1)) ? "on" : "off");
				mgr.setGlobalOption("Morphological Tags",
					((morph) && (curVerse >= activeVerse -1) && (curVerse <= activeVerse + 1)) ? "on" : "off");
			%>


				<tr>
		<%
					for (int i = 0; i < parDispModules.size(); i++) {
						SWModule mod = mgr.getModuleByName((String)parDispModules.get(i));
						boolean rtol = ("RtoL".equalsIgnoreCase(mod.getConfigEntry("Direction")));

						if (mod != activeModule)
							mod.setKeyText( keyText );
		%>
							<td width="<%= 100/parDispModules.size() %>%" <%= rtol ? "dir=\"rtl\"" : "" %>" class="<%= (keyText.equals(activeKey)) ? "currentverse" : "verse" %>">
								<span class="versenum">
									<a <%= (keyText.equals(activeKey)) ? "name=\"cv\"" : "" %> href="parallelstudy.jsp?key=<%= URLEncoder.encode(keyText) %>#cv"> <%= keyText.substring(keyText.indexOf(":")+1) %></a>
								</span>

					<%
					String lang = mod.getConfigEntry("Lang");
					%>

					<span xml:lang="<%= (lang.equals("")) ? "en" : lang %>">
					<%= new String(mod.getRenderText().getBytes("iso8859-1"), "UTF-8") %>
					</span>

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
