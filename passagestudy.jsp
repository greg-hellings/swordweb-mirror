<%@ include file="init.jsp" %>
<%@ page import="org.crosswire.swordweb.*" %>

<%
	session.setAttribute("lastModType", "Bible");
	Vector toolsTreeOpen = (Vector)session.getAttribute("toolsTreeOpen");
	String resetModule = request.getParameter("mod");
	if (resetModule != null)
		session.setAttribute("ActiveModule", resetModule);
	String activeModuleName = (String) session.getAttribute("ActiveModule");
	SWModule activeModule = mgr.getModuleByName((activeModuleName == null) ? defaultBible : activeModuleName);
	String promoLine = activeModule.getConfigEntry("ShortPromo");
	if (promoLine.equalsIgnoreCase("<swnull>"))
		promoLine = "";

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

	//the sidebar rendering object is shared in the left (Bibles) and right (Commentaries) sidebar
	SidebarModuleView sidebarView = new SimpleModuleView(mgr);
	SidebarItemRenderer displayModRenderer = new SidebarItemRenderer() { //an anonymous class which renders a list of modules with links to read each of them
		public String renderModuleItem(SWModule module) {
			StringBuffer ret = new StringBuffer();
			ret.append("<li><a href=\"passagestudy.jsp?mod=")
				.append(URLEncoder.encode(module.getName()))
				.append("#cv\" title=\"Read text of this module\">")
				.append(module.getDescription().replaceAll("&", "&amp;"))
				.append("</a></li>");

			return ret.toString();
		}
	};
%>

<tiles:insert beanName="basic" flush="true" >
	<tiles:put name="title" value="Passage Bible study" />
	<tiles:put name="pintro" type="string" ><div></div></tiles:put>
	<tiles:put name="sidebar_left" type="string">
		<div id="translations">
		<h2><t:t>Translations:</t:t></h2>
		<h3><t:t>Preferred Translations</t:t></h3>

	<% if (prefBibles.size() > 0) {
		out.print( sidebarView.renderView(prefBibles, displayModRenderer) ); //render the preferred Bibles section
		
	} else { //no preferred Bibles
	%>
		<ul>
		<li><t:t>Preferred Translations can be selected from the preferences tab</t:t></li>
		</ul>
	<% } %>


	<%
		boolean open = toolsTreeOpen.contains("allBibles");
	%>
	<h3><t:t>All Translations</t:t></h3>
			<%
			if (open) { //already open
			%>
				<p><a class="closed" href="passagestudy.jsp?close=allBibles" title="Hide all translations"><t:t>Hide All</t:t></a></p>
			<%
			}
			else { //closed
			%>
				<p><a class="open" href="passagestudy.jsp?open=allBibles" title="View all translations"><t:t>View All</t:t></a></p>
			<%
			}
			%>
		<%
			if (open && (modInfo.length > 0)) {
				Vector modules = new Vector();
				for (int i = 0; i < modInfo.length; i++) {
					if (modInfo[i].category.equals(SwordOrb.BIBLES)) {
						modules.add(modInfo[i].name);
					}
				}
				modules.removeAll( prefBibles );
				out.print( sidebarView.renderView(modules, displayModRenderer) ); //render the complete Bible modules list
			}
		%>
		</div>
	</tiles:put>
	<tiles:put name="sidebar_right" type="string">
	<div class="promoLine"><%= promoLine %></div>
	<div id="studytools">
		<h2>Word Study:</h2>
			<ul>
			<li><a href="passagestudy.jsp?strongs=<%= (strongs) ? "off" : "on" %>#cv" title="Turn <%= (strongs) ? "off" : "on"%> Strongs numbers"><t:t><%= (strongs) ? "Hide" : "Show" %> Strongs</t:t></a></li>
			<li><a href="passagestudy.jsp?morph=<%= (morph) ? "off" : "on" %>#cv" title="Turn <%= (morph) ? "off" : "on" %> morphology"><t:t><%= (morph) ? "Hide" : "Show" %> Morphology</t:t></a></li>
			</ul>
	</div>

	<div id="commentaries">
		<h2><t:t>Comentaries:</t:t></h2>
		<h3><t:t>Preferred Comentaries:</t:t></h3>
	<% 
		if (prefCommentaries.size() > 0) {
			out.print( sidebarView.renderView(prefCommentaries, displayModRenderer) ); //render the preferred Commentaries list
	   	} else { 
	%>
			<ul>
				<li><t:t>Preferred commentaries can be selected from the preferences tab</t:t></li>
			</ul>
	<% 	} %>



		<%
			boolean open = toolsTreeOpen.contains("allComm");
		%>
		<h3><t:t>All Commentaries</t:t></h3>
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
			if (open && (modInfo.length > 0)) {
				Vector modules = new Vector();
				
				for (int i = 0; i < modInfo.length; i++) {
					if (modInfo[i].category.equals(SwordOrb.COMMENTARIES)) {
						modules.add(modInfo[i].name);
					}
				}
				modules.removeAll( prefCommentaries );
				
				out.print( sidebarView.renderView(modules, displayModRenderer) ); //render the complete Commentary module list
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
<%--  		<h2><%= activeKey %></h2>  --%>

		<% //insert next and previous chapter links
			String prevChapterString = RangeInformation.getPreviousChapter(activeKey, activeModule);
			String nextChapterString = RangeInformation.getNextChapter(activeKey, activeModule);
		%>
		<ul class="booknav">
			<li><a href="passagestudy.jsp?key=<%= URLEncoder.encode(prevChapterString) %>" title="Display <%= prevChapterString %>"><t:t>previous chapter</t:t></a></li>
			<li><h3><%= activeKey %></h3></li>
			<li><a href="passagestudy.jsp?key=<%= URLEncoder.encode(nextChapterString) %>" title="Display <%= nextChapterString %>"><t:t>next chapter</t:t></a></li>
		</ul>

		<%
			Vector moduleList = new Vector();
			moduleList.add( activeModule );
			
			Vector entryList;
			if ((activeModule.getCategory().equals("Cults / Unorthodox / Questionable Material")) || (activeModule.getCategory().equals(SwordOrb.BIBLES))) {
				entryList = RangeInformation.getChapterEntryList(activeKey, activeModule);
			}
			else { //a simple commentary entry, not multiple ones
				entryList = new Vector();
				entryList.add(activeKey);
			}
				
			ModuleTextRendering rendering = new HorizontallyParallelTextRendering(); //passagestudy is a parallel view with just one module at the same time
			ModuleEntryRenderer entryRenderer = new StandardEntryRenderer( new String("passagestudy.jsp"), activeKey, mgr );
			if (strongs) {
				entryRenderer.enableFilterOption("Strong's Numbers");
			}
			if (morph) {
				entryRenderer.enableFilterOption("Morphological Tags");
			}
			
			//Do the actual rendering
			out.print( rendering.render(moduleList, entryList, entryRenderer) );
						
			String copyLine = activeModule.getConfigEntry("ShortCopyright");
			if (copyLine.equalsIgnoreCase("<swnull>")) {
				copyLine = "";
			}
			if (activeModule.getCategory().equals("Cults / Unorthodox / Questionable Material")) {
				copyLine = "<t:t>WARNING: This text is considered unorthodox by most of Christendom.</t:t> " + copyLine;
			}
		%>
		
		<div class="copyLine"><%= copyLine %></div>
<%-- 		<ul class="booknav">
			<li><a href="passagestudy.jsp?key=<%= URLEncoder.encode(prevChapterString) %>" title="Display <%= prevChapterString %>"><t:t>previous chapter</t:t></a></li>
			<li><h3><%= activeKey %></h3></li>
			<li><a href="passagestudy.jsp?key=<%= URLEncoder.encode(nextChapterString) %>" title="Display <%= nextChapterString %>"><t:t>next chapter</t:t></a></li>
		</ul> --%>
		<div class="promoLine"><%= promoLine %></div>
		</div>
	</tiles:put>
</tiles:insert>
