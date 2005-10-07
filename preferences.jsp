<%@ include file="init.jsp" %>
<%@ page import="org.crosswire.swordweb.*" %>

<%
	String addModule = (String)request.getParameter("add");
	if (addModule != null) {
		SWModule mod = mgr.getModuleByName(addModule);
		if (mod != null) {
			if (mod.getCategory().equals(SwordOrb.BIBLES)) {
				prefBibles.remove(mod.getName());
				prefBibles.add(0, mod.getName());
			}
			if (mod.getCategory().equals(SwordOrb.COMMENTARIES)) {
				prefCommentaries.remove(mod.getName());
				prefCommentaries.add(0, mod.getName());
			}
		}
	}

	String delModule = (String)request.getParameter("del");
	if (delModule != null) {
		SWModule mod = mgr.getModuleByName(delModule);
		if (mod != null) {
			if (mod.getCategory().equals(SwordOrb.BIBLES)) {
				prefBibles.remove(mod.getName());
			}
			if (mod.getCategory().equals(SwordOrb.COMMENTARIES)) {
				prefCommentaries.remove(mod.getName());
			}
		}
	}
	session.setAttribute("PrefBibles", prefBibles);
	session.setAttribute("PrefCommentaries", prefCommentaries);
	saveModPrefsCookie(response, "PrefBibles", prefBibles);
	saveModPrefsCookie(response, "PrefCommentaries", prefCommentaries);

	SidebarModuleView sidebarView = new SimpleModuleView(mgr);
	SidebarItemRenderer selectModRenderer = new SidebarItemRenderer() { //an anonymous class which renders a list of modules with links to read each of them
		public String renderModuleItem(SWModule module) {
			StringBuffer ret = new StringBuffer();
			ret.append("<li><a href=\"preferences.jsp?add=")
				.append(URLEncoder.encode(module.getName()))
				.append("#cv\" title=\"Add this module\">")
				.append(module.getDescription().replaceAll("&", "&amp;"))
				.append("</a></li>");

			return ret.toString();
		}
	};
	SidebarItemRenderer removeModRenderer = new SidebarItemRenderer() { //an anonymous class which renders a list of modules with links to read each of them
		public String renderModuleItem(SWModule module) {
			StringBuffer ret = new StringBuffer();
			ret.append("<li><a href=\"preferences.jsp?del=")
				.append(URLEncoder.encode(module.getName()))
				.append("#cv\" title=\"Remove this module\">")
				.append(module.getDescription().replaceAll("&", "&amp;"))
				.append("</a></li>");

			return ret.toString();
		}
	};
%>

<tiles:insert beanName="basic" flush="true" >
	<tiles:put name="title" value="Preferences" />
	<tiles:put name="pintro" type="string" ><div></div></tiles:put>
	<tiles:put name="sidebar_left" type="string">
		<div id="translations">

		<h2><t:t>Translations:</t:t></h2>
		<h3><t:t>Preferred Translations</t:t></h3>
		<%
			
			out.print( sidebarView.renderView(prefBibles, selectModRenderer) ); //render the preferred Bibles section
		%>

		<h3><t:t>All Translations</t:t></h3>
		<%
			Vector modules = new Vector();
			for (int i = 0; i < modInfo.length; i++) {
				if (modInfo[i].category.equals(SwordOrb.BIBLES)) {
					modules.add(modInfo[i].name);
				}
			}
			modules.removeAll(prefBibles); //don't insert the pref mods again
			
			out.print( sidebarView.renderView(modules, selectModRenderer) ); //render the preferred Bibles section
		%>

		</div>
	</tiles:put>

	<tiles:put name="sidebar_right" type="string">
		<div id="commentaries">

		<h2><t:t>Comentaries:</t:t></h2>
		<h3><t:t>Preferred Comentaries</t:t></h3>
		
		<%
			out.print( sidebarView.renderView(prefCommentaries, selectModRenderer) ); //render the preferred Bibles section
		%>


		<h3><t:t>All Comentaries</t:t></h3>
		<%
			Vector modules = new Vector();
			for (int i = 0; i < modInfo.length; i++) {
				if (modInfo[i].category.equals(SwordOrb.COMMENTARIES)) {
					modules.add(modInfo[i].name);
				}
			} 
			modules.removeAll(prefCommentaries);//don't show the preferred mods again
			
			out.print( sidebarView.renderView(modules, selectModRenderer) ); //render the preferred Bibles section
		%>

		</div>
	</tiles:put>

	<tiles:put name="content" type="string">
	<div id="preferences">
		<h2><t:t>Preferred Translations</t:t></h2>
		<p><t:t>Click to remove. Reselect on the side to move to the top.</t:t></p>
		<%
			out.print( sidebarView.renderView(prefBibles, removeModRenderer) ); //render the preferred Bibles section
		%>
		<h2><t:t>Preferred Commentaries</t:t></h2>
		<p><t:t>Click to remove. Reselect on the side to move to the top.</t:t></p>
		<%
			out.print( sidebarView.renderView(prefCommentaries, removeModRenderer) ); //render the preferred Bibles section
		%>
		
		<h2><t:t>Preferred Style</t:t></h2>
		<ul>
			<% for (int i = 0; i < styleNames.size(); i++) { %>
				<li><a href="preferences.jsp?setStyle=<%= URLEncoder.encode((String)styleNames.get(i)) %>" title="<%= (String) styleNames.get(i) %>"><t:t><%= (String) styleNames.get(i) %></t:t></a></li>
			<% } %>
		</ul>

		<h2><t:t>Tabs</t:t></h2>
		<ul>
		<% 	for (int i = 0; i < tabNames.size(); i++) {
				boolean visible = !"false".equals(showTabs.get(i));
				String n = (String)tabNames.get(i);
				String l = (String)tabLinks.get(i);
				if (!"preferences.jsp".equals(l)) {
		%>
					<li><a href="preferences.jsp?<%=(visible)?"hide":"show"%>Tab=<%= Integer.toString(i)%>" title="<%= ((visible)?"Hide ":"Show ") + n %> Tab"><t:t><%= ((visible)?"Hide ":"Show ") + n %> Tab</t:t></a></li>
		<% 		}
			} 
		%>
		</ul>
		
		<h2 id="misc"><t:t>Misc Options</t:t></h2>
		<ul>
			<li><a id="headings" href="preferences.jsp?Headings=<%= "Off".equalsIgnoreCase(headings)?"On":"Off" %>#misc" title="<%= "Off".equalsIgnoreCase(headings)?"Show":"Hide" %> Headings in Bibles"><t:t><%= "Off".equalsIgnoreCase(headings)?"Show":"Hide" %> Headings in Bibles</t:t></a></li>
			<li><a id="javascript" href="preferences.jsp?Javascript=<%= "Off".equalsIgnoreCase(javascript)?"On":"Off" %>#misc" title="<%= "Off".equalsIgnoreCase(javascript)?"Use":"Don't Use" %> Javascript"><t:t><%= "Off".equalsIgnoreCase(javascript)?"Use":"Don't Use" %> Javascript</t:t></a></li>
		</ul>

	</div>
	</tiles:put>
</tiles:insert>

<%!
private void saveModPrefsCookie(HttpServletResponse response, String name, Vector modPrefs) {
	StringBuffer fullText = new StringBuffer("GodLuvsU");
	for (int i = 0; i < modPrefs.size(); i++) {
		fullText.append("+");
		fullText.append((String)modPrefs.get(i));
	}
/*
	// serialize out to cookie
	ByteArrayOutputStream bytes = new ByteArrayOutputStream();
	Base64.OutputStream bos = new Base64.OutputStream(bytes);
	ObjectOutputStream oos = new ObjectOutputStream(bos);
	oos.writeObject(prefBibles);
	oos.writeObject(prefCommentaries);
	Cookie c = new Cookie("prefMods", new String(bytes.toByteArray()));
*/
	Cookie c = new Cookie(name, fullText.toString());
	c.setMaxAge(java.lang.Integer.MAX_VALUE);
	c.setPath("/");
//out.println("Cookie being set is ("+c.getName()+"):" + c.getValue());
	response.addCookie(c);
}
%>
