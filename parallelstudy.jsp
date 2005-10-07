<%@ include file="init.jsp" %>
<%@ page import="org.crosswire.swordweb.*" %>

<%
	session.setAttribute("lastModType", "Bible");
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
		parDispModules.add(0, defaultBible); //our standard, fallback module
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

	boolean startList = false;

	String parallelViewType = (String) session.getAttribute("parallelViewType");
	buf = request.getParameter("parallelViewType");
	if (buf != null) {
		parallelViewType = buf;
	}
	if (parallelViewType == null) {
		parallelViewType = "sidebyside";
	}
	session.setAttribute("parallelViewType", parallelViewType);
	
	SidebarModuleView sidebarView = new SimpleModuleView(mgr);
	SidebarItemRenderer delModRenderer = new SidebarItemRenderer() {
		public String renderModuleItem(SWModule module) {
			StringBuffer ret = new StringBuffer();
			ret.append("<li><a href=\"parallelstudy.jsp?del=")
				.append(URLEncoder.encode(module.getName()))
				.append("#cv\" title=\"Remove from displayed modules\">")
				.append(module.getDescription().replaceAll("&", "&amp;"))
				.append("</a></li>");

			return ret.toString();
		}
	};
	
	SidebarItemRenderer addModRenderer = new SidebarItemRenderer() {
		public String renderModuleItem(SWModule module) {
			StringBuffer ret = new StringBuffer();
			ret.append("<li><a href=\"parallelstudy.jsp?add=")
				.append(URLEncoder.encode(module.getName()))
				.append("#cv\" title=\"Add to displayed modules\">")
				.append(module.getDescription().replaceAll("&", "&amp;"))
				.append("</a></li>");

			return ret.toString();
		}
	};
%>


<tiles:insert beanName="basic" flush="true" >
	<%-- override lookup URL, so this script is used to display the keys --%>
	<tiles:put name="lookup_url" value="parallelstudy.jsp" />
	<tiles:put name="title" value="Parallel Bible study" />
	<tiles:put name="pintro" type="string" ><div></div></tiles:put>

	<tiles:put name="sidebar_left" type="string">

		<div id="translations">

		<h2><t:t>Translations:</t:t></h2>
		<h3><t:t>Displayed modules</t:t></h3>
		<p><t:t>click to remove</t:t></p>
		<%
			Vector modules = new Vector();
			
			modules.clear();
			for (int i = 0; i < parDispModules.size(); i++) {
				SWModule module = mgr.getModuleByName((String)parDispModules.get(i));
				if (module != null && ((module.getCategory().equals(SwordOrb.BIBLES))||(module.getCategory().equals("Cults / Unorthodox / Questionable Material")))) {
					modules.add(module.getName());
				}
			}

			out.print( sidebarView.renderView(modules, delModRenderer) );
		%>

		<h3><t:t>Available modules</t:t></h3>
		<p><t:t>click to add</t:t></p>
		<%
			
			modules.clear();
			for (int i = 0; i < modInfo.length; i++) {
				if (modInfo[i].category.equals(SwordOrb.BIBLES) && !parDispModules.contains(modInfo[i].name)) {
					modules.add(modInfo[i].name);
				}
			}

			out.print( sidebarView.renderView(modules, addModRenderer) );
		%>

		<h3><t:t>Cults / Unorthodox / Questionable Material</t:t></h3><p><t:t>click to add</t:t></p>
		<%
			modules.clear();
			for (int i = 0; i < modInfo.length; i++) {
				if (modInfo[i].category.equals("Cults / Unorthodox / Questionable Material") && !parDispModules.contains(modInfo[i].name)) {
					modules.add(modInfo[i].name);
				}
			}

			out.print( sidebarView.renderView(modules, addModRenderer) );	
		%>

		</div>

	</tiles:put>

	<tiles:put name="sidebar_right" type="string">
<!--
		<div id="studytools">
			<h2><t:t>Word Study:</t:t></h2>
			<ul>
				<li><a href="parallelstudy.jsp?strongs=<%= (strongs) ? "off" : "on" %>" title="Turn <%= (strongs) ? "off" : "on"%> Strongs numbers"><%= (strongs) ? "Hide" : "Show" %> Strongs</a></li>
				<li><a href="parallelstudy.jsp?morph=<%= (morph) ? "off" : "on" %>" title="Turn <%= (morph) ? "off" : "on" %> morphology"><%= (morph) ? "Hide" : "Show" %> Morphology</a></li>
			</ul>
		</div>
-->
		<div id="studytools">
			<h2><t:t>Parallel viewing:</t:t></h2>
			<ul>
				<li><a href="parallelstudy.jsp?parallelViewType=sidebyside">Side by side</a></li>
				<li><a href="parallelstudy.jsp?parallelViewType=toptobottom">Top to bottom</a></li>
			</ul>
		</div>

		<div id="commentaries">
		<h2><t:t>Comentaries:</t:t></h2>

		<h3><t:t>Displayed modules</t:t></h3>
		<p><t:t>click to remove</t:t></p>
		<%
			Vector modules =  new Vector();
			for (int i = 0; i < parDispModules.size(); i++) {
				SWModule module = mgr.getModuleByName((String)parDispModules.get(i));
				if (module != null && module.getCategory().equals(SwordOrb.COMMENTARIES)) {
					modules.add(module.getName());
				}
			}

			out.print( sidebarView.renderView(modules, delModRenderer) );
		%>

		<h3><t:t>Available modules</t:t></h3>
		<p><t:t>click to add</t:t></p>
		<%
			modules.clear();
			for (int i = 0; i < modInfo.length; i++) {
				if (modInfo[i].category.equals(SwordOrb.COMMENTARIES) && !parDispModules.contains(modInfo[i].name)) {
					modules.add(modInfo[i].name);
				}
			}
			
			out.print( sidebarView.renderView(modules, addModRenderer) );
		%>

		</div>

	</tiles:put> 	<%--  	end of right sightbat tag area  --%>
	
	<tiles:put name="content" type="string">
		<%
			if (activeModule != null) {
				activeModule.setKeyText(activeKey);
				activeKey = activeModule.getKeyText(); 	// be sure it's formatted nicely
			}
		%>

		<div id="paralleldisplay">

		<h2><t:t>Parallel Viewing: </t:t><%= activeKey %></h2>
		<div id="introhelp">
		<p><t:t>Parallel viewing allows you to see two or more texts side by side.  For example, you could view two Bible versions of the same verse next to each other, or a verse from a specific translation and what a commentary has to say about that specific verse.</t:t></p>
		</div>

		<% //insert next and previous chapter links
			String prevChapterString = RangeInformation.getPreviousChapter(activeKey, activeModule);
			String nextChapterString = RangeInformation.getNextChapter(activeKey, activeModule);
		%>
		<ul class="booknav">
			<li><a href="parallelstudy.jsp?key=<%= URLEncoder.encode(prevChapterString) %>" title="Display <%= prevChapterString %>"><t:t>previous chapter</t:t></a></li>
			<li><h3><%= activeKey %></h3></li>
			<li><a href="parallelstudy.jsp?key=<%= URLEncoder.encode(nextChapterString) %>" title="Display <%= nextChapterString %>"><t:t>next chapter</t:t></a></li>
		</ul>


		<%-- table which contains all verse items --%>
		<%
			Vector moduleList = new Vector();
			for (int i = 0; i < parDispModules.size(); i++) {
				moduleList.add( mgr.getModuleByName((String)parDispModules.get(i)) );
			}
			
			Vector entryList = null;
			if ((activeModule.getCategory().equals("Cults / Unorthodox / Questionable Material")) || (activeModule.getCategory().equals(SwordOrb.BIBLES))) {
				entryList = RangeInformation.getChapterEntryList(activeKey, activeModule);
			}
			else { //a simple commentary entry, not multiple ones
				entryList = new Vector();
				entryList.add(activeKey);
			}
			
			ModuleTextRendering rendering = null;
			ModuleEntryRenderer entryRenderer = null;
			if (parallelViewType.equals("sidebyside")) {
				rendering = new HorizontallyParallelTextRendering();
				entryRenderer = new StandardEntryRenderer( new String("parallelstudy.jsp"), activeKey, mgr );
			}
			else { //if (parallelViewType.equals("toptobottom"))
				rendering = new VerticallyParallelTextRendering();
				entryRenderer = new SimpleEntryRenderer( new String("parallelstudy.jsp"), activeKey, mgr );
			}

			if (strongs) {
				entryRenderer.enableFilterOption("Strong's Numbers");
			}
			if (morph) {
				entryRenderer.enableFilterOption("Morphological Tags");
			}
			
			out.print( rendering.render(moduleList, entryList, entryRenderer) ); //print out the text page
			
			
			String copyLine = activeModule.getConfigEntry("ShortCopyright");
			if (copyLine.equalsIgnoreCase("<swnull>")) {
				copyLine = "";
			}
			if (activeModule.getCategory().equals("Cults / Unorthodox / Questionable Material")) {
				copyLine = "<t:t>WARNING: This text is considered unorthodox by most of Christendom.</t:t> " + copyLine;
			}
		%>


		</div>
	</tiles:put>
</tiles:insert>
