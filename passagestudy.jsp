<%@ include file="defines/tiles.jsp" %>
<%
	Vector toolsTreeOpen = (Vector)session.getAttribute("toolsTreeOpen");
	String resetModule = request.getParameter("mod");
	if (resetModule != null)
		session.setAttribute("ActiveModule", resetModule);
	String activeModuleName = (String) session.getAttribute("ActiveModule");
	SWModule activeModule = mgr.getModuleByName((activeModuleName == null) ? defaultBible : activeModuleName);
	String promoLine = activeModule.getConfigEntry("ShortPromo");

	String resetKey = request.getParameter("key");
	if (resetKey != null)
		session.setAttribute("ActiveKey", resetKey);
	String activeKey = (String) session.getAttribute("ActiveKey");
	if (activeKey == null)
		activeKey = "jas 1:19";

	if (toolsTreeOpen == null) {
		toolsTreeOpen = new Vector();
		session.setAttribute("toolsTreeOpen", toolsTreeOpen);
	}

	boolean strongs = "on".equals((String) session.getAttribute("strongs"));
	String buf = request.getParameter("strongs");
	strongs = (buf != null) ? "on".equalsIgnoreCase(buf) : strongs;
	session.setAttribute("strongs", (strongs)?"on":"off");

	boolean morph = "on".equals((String) session.getAttribute("morph"));
	buf = request.getParameter("morph");
	morph = (buf != null) ? "on".equalsIgnoreCase(buf) : morph;
	session.setAttribute("morph", (morph)?"on":"off");

	String showStrong = request.getParameter("showStrong");
	String showMorph = request.getParameter("showMorph");

	mgr.setGlobalOption("Headings", ("Off".equalsIgnoreCase(headings)) ? "Off":"On");

	for (int i = 0; i < 2; i++) {
		String []nodes = request.getParameterValues((i>0)?"close":"open");
		if (nodes != null) {
			for (int j = 0; j < nodes.length; j++) {
				String node = nodes[j];
				if (node != null) {
					if (i>0)
						toolsTreeOpen.remove(node);
					else {
						if (!toolsTreeOpen.contains(node)) {
							toolsTreeOpen.add(node);
						}
					}
				}
			}
		}
	}
%>

<tiles:insert beanName="basic" flush="true" >
	<tiles:put name="title" value="Passage Bible study" />
	<tiles:put name="pintro" type="string" ><div></div></tiles:put>
	<tiles:put name="sidebar_left" type="string">
		<div id="translations">
		<h2>Translations:</h2>
		<h3>Preferred Translations</h3>

	<% if (prefBibles.size() > 0) { %>
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
	<% } else { %>
		<ul>
		<li>Preferred Translations can be selected from the preferences tab</li>
		</ul>
	<% } %>


		<%
			boolean open = toolsTreeOpen.contains("allBibles");
		%>
<h3>All Translations</h3>
			<%
			if (open) { //already open
			%>
				<p><a class="closed" href="passagestudy.jsp?close=allBibles" title="Hide all translations">Hide All</a></p>
			<%
			}
			else { //closed
			%>
				<p><a class="open" href="passagestudy.jsp?open=allBibles" title="View all translations">View All</a></p>
			<%
			}
			%>
		<%
			if ((open) && (modInfo.length > 0)) {
%>
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
<%
			}
		%>
		</div>
	</tiles:put>
	<tiles:put name="sidebar_right" type="string">
	<div class="promoLine"><%= promoLine %></div>
	<div id="studytools">
		<h2>Word Study:</h2>
			<ul>
			<li><a href="passagestudy.jsp?strongs=<%= (strongs) ? "off" : "on" %>#cv" title="Turn <%= (strongs) ? "off" : "on"%> Strongs numbers"><%= (strongs) ? "Hide" : "Show" %> Strongs</a></li>
			<li><a href="passagestudy.jsp?morph=<%= (morph) ? "off" : "on" %>#cv" title="Turn <%= (morph) ? "off" : "on" %> morphology"><%= (morph) ? "Hide" : "Show" %> Morphology</a></li>
			</ul>
	</div>

	<div id="commentaries">
		<h2>Comentaries:</h2>
		<h3>Preferred Comentaries:</h3>
	<% if (prefCommentaries.size() > 0) { %>
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
	<% } else { %>
		<ul>
		<li>Preferred commentaries can be selected from the preferences tab</li>
		</ul>
	<% } %>



		<%
			boolean open = toolsTreeOpen.contains("allComm");
		%>
		<h3>All Commentaries</h3>
		<%
			if (open) { //already open
		%>
			<p><a class="closed" href="passagestudy.jsp?close=allComm" title="Hide all commentaries">Hide All</a></p>
		<%
		}
		else { //closed
		%>
			<p><a class="open" href="passagestudy.jsp?open=allComm" title="View all commentaries">View All</a></p>
		<%
		}
		%>

		<%
			if ((open) && (modInfo.length > 0)) {
%>
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
<%
			}
		%>
		</div>

	</tiles:put>
	<tiles:put name="content" type="string">
		<%
			activeModule.setKeyText(activeKey);
			activeKey = activeModule.getKeyText(); 	// be sure it is formatted nicely
		%>

		<div id="passagestudy">
		<h2><%= activeKey %></h2>
		<h3><a href="fulllibrary.jsp?show=<%= URLEncoder.encode(activeModule.getName()) %>"><%= activeModule.getDescription().replaceAll("&", "&amp;") + " (" + activeModule.getName() + ")" %></a></h3>

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
			<li><a href="passagestudy.jsp?key=<%= URLEncoder.encode(prevChapterString) %>" title="Display <%= prevChapterString %>">previous chapter</a></li>
			<!-- <li><a href="" title="display all of Romans 8">this chapter</a></li> -->
			<li><a href="passagestudy.jsp?key=<%= URLEncoder.encode(nextChapterString) %>" title="Display <%= nextChapterString %>">next chapter</a></li>
		</ul>

		<%
			if (activeModule.getCategory().equals(SwordOrb.BIBLES)) {
				String chapterPrefix = activeKey.substring(0, activeKey.indexOf(":"));
				int activeVerse = Integer.parseInt(activeKey.substring(activeKey.indexOf(":")+1));
				int anchorVerse = (activeVerse > 2)?activeVerse - 2: -1;
				for (activeModule.setKeyText(chapterPrefix + ":1"); (activeModule.error() == (char)0); activeModule.next()) {
					String keyText = activeModule.getKeyText();
					int curVerse = Integer.parseInt(keyText.substring(keyText.indexOf(":")+1));
					if (!chapterPrefix.equals(keyText.substring(0, keyText.indexOf(":"))))
						break;
					mgr.setGlobalOption("Strong's Numbers",
							((strongs) && (curVerse >= activeVerse -1) && (curVerse <= activeVerse + 1)) ? "on" : "off");
					mgr.setGlobalOption("Morphological Tags",
							((morph) && (curVerse >= activeVerse -1) && (curVerse <= activeVerse + 1)) ? "on" : "off");
					boolean rtol = ("RtoL".equalsIgnoreCase(activeModule.getConfigEntry("Direction")));
			%>
				<div <%= rtol ? "dir=\"rtl\"" : "" %> class="<%= (keyText.equals(activeKey)) ? "currentverse" : "verse" %>">
			<%
					String[] heads = activeModule.getEntryAttribute("Heading", "Preverse", "0");
					if (heads.length > 0)
						out.print("<h3>" + heads[0] + "</h3>");
			%>
					<span class="versenum"><a <%= (curVerse == anchorVerse)?"id=\"cv\"":"" %> href="passagestudy.jsp?key=<%= URLEncoder.encode(keyText)+"#cv" %>">
						<%= keyText.substring(keyText.indexOf(":")+1) %></a>
					</span>

					<%
					String lang = activeModule.getConfigEntry("Lang");
					%>
					<span xml:lang="<%= (lang.equals("")) ? "en" : lang %>">
					<%= new String(activeModule.getRenderText().getBytes("iso8859-1"), "UTF-8") %>
					</span>
				</div>
		<%
				if (keyText.equals(activeKey)) {
					if (showStrong != null) {
						String [] keyInfo = activeModule.getKeyChildren();
						SWModule lex =  mgr.getModuleByName(("1".equals(keyInfo[0])) ? "StrongsHebrew":"StrongsGreek");
						lex.setKeyText(showStrong);
				%>
						<div class="lexiconentry"><p>
						<%= new String(lex.getRenderText().getBytes("iso8859-1"), "UTF-8") %>
						</p></div>
				<%	} %>
				<%
					if (showMorph != null) {
						String [] keyInfo = activeModule.getKeyChildren();
						SWModule lex =  mgr.getModuleByName(("1".equals(keyInfo[0])) ? "StrongHebrew":"Robinson");
						lex.setKeyText(showMorph);
				%>
						<div class="lexiconentry"><p>
						<%= new String(lex.getRenderText().getBytes("iso8859-1"), "UTF-8") %>
						</p></div>
				<%	}
				}
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
			String copyLine = activeModule.getConfigEntry("ShortCopyright");
			if (copyLine.equalsIgnoreCase("<swnull>"))
				copyLine = "";
			if (promoLine.equalsIgnoreCase("<swnull>"))
				promoLine = "";
		%>
		<div class="copyLine"><%= copyLine %></div>
		<ul class="booknav">
			<li><a href="passagestudy.jsp?key=<%= URLEncoder.encode(prevChapterString) %>" title="Display <%= prevChapterString %>">previous chapter</a></li>
			<!-- <li><a href="" title="display all of Romans 8">this chapter</a></li> -->
			<li><a href="passagestudy.jsp?key=<%= URLEncoder.encode(nextChapterString) %>" title="Display <%= nextChapterString %>">next chapter</a></li>
		</ul>
		<div class="promoLine"><%= promoLine %></div>
		</div>
	</tiles:put>
</tiles:insert>
