<%@ include file="defines/tiles.jsp" %>

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

%>

<tiles:insert beanName="basic" flush="true" >
	<tiles:put name="title" value="Preferences" />
	<tiles:put name="pintro" type="string" ><div></div></tiles:put>
	<tiles:put name="sidebar_left" type="string">
		<div id="translations">

		<h2>Translations:</h2>
		<h3>Preferred Translations</h3>
		<ul>
		<%
			for (int i = 0; i < prefBibles.size(); i++) {
				SWModule module = mgr.getModuleByName((String)prefBibles.get(i));
		%>
				<li><a href="preferences.jsp?add=<%= URLEncoder.encode(module.getName()) %>" title="Add <%= module.getDescription().replaceAll("&", "&amp;") %>"><%= module.getDescription().replaceAll("&", "&amp;") %></a></li>
		<%
			}
		%>
		</ul>

		<h3>All Translations</h3>
		<ul>
		<%
			for (int i = 0; i < modInfo.length; i++) {
				if (modInfo[i].category.equals(SwordOrb.BIBLES)) {
					SWModule module = mgr.getModuleByName(modInfo[i].name);
		%>
				<li><a href="preferences.jsp?add=<%= URLEncoder.encode(modInfo[i].name) %>" title="Add <%= module.getDescription().replaceAll("&", "&amp;") %>"><%= module.getDescription().replaceAll("&", "&amp;") %></a></li>
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
		<h3>Preferred Comentaries</h3>
		<ul>
		<%
			for (int i = 0; i < prefCommentaries.size(); i++) {
				SWModule module = mgr.getModuleByName((String)prefCommentaries.get(i));
		%>
				<li><a href="preferences.jsp?add=<%= URLEncoder.encode(module.getName()) %>" title="Add <%= module.getDescription().replaceAll("&", "&amp;") %>"><%= module.getDescription().replaceAll("&", "&amp;") %></a></li>
		<%
			}
		%>
		</ul>


<h3>All Comentaries</h3>
		<ul>
		<%
			for (int i = 0; i < modInfo.length; i++) {
				if (modInfo[i].category.equals(SwordOrb.COMMENTARIES)) {
					SWModule module = mgr.getModuleByName(modInfo[i].name);
		%>
				<li><a href="preferences.jsp?add=<%= URLEncoder.encode(modInfo[i].name) %>" title="Add <%= module.getDescription().replaceAll("&", "&amp;") %>"><%= module.getDescription().replaceAll("&", "&amp;") %></a></li>
		<%
				}
			}
		%>
		</ul>

		</div>
	</tiles:put>

	<tiles:put name="content" type="string">
<div id="preferences">
		<h2>Preferred Translations</h2>
		<p>Click to remove.  Reselect on the side to move to the top.</p>
		<ul>
		<%
			for (int i = 0; i < prefBibles.size(); i++) {
				SWModule mod = mgr.getModuleByName((String)prefBibles.get(i));
		%>
				<li><a href="preferences.jsp?del=<%= URLEncoder.encode(mod.getName()) %>"><%= mod.getDescription() %> (<%= mod.getName() %>)</a></li>

		<%
			}
		%>
		</ul>
		<h2>Preferred Commentaries</h2>
		<p>Click to remove.  Reselect on the side to move to the top.</p>
		<ul>
		<%
			for (int i = 0; i < prefCommentaries.size(); i++) {
				SWModule mod = mgr.getModuleByName((String)prefCommentaries.get(i));
		%>
				<li><a href="preferences.jsp?del=<%= URLEncoder.encode(mod.getName()) %>"><%= mod.getDescription() %> (<%= mod.getName() %>)</a></li>

		<%
			}
		%>
		</ul>
		<h2>Preferred Style</h2>
		<ul>
<% for (int i = 0; i < styleNames.size(); i++) { %>
			<li><a href="preferences.jsp?setStyle=<%= URLEncoder.encode((String)styleNames.get(i)) %>" title="<%= (String) styleNames.get(i) %>"><%= (String) styleNames.get(i) %></a></li>
<% } %>
		</ul>

		<h2>Tabs</h2>
		<ul>
<% for (int i = 0; i < tabNames.size(); i++) {
	boolean visible = !"false".equals(showTabs.get(i));
	String n = (String)tabNames.get(i);
	String l = (String)tabLinks.get(i);
	if (!"preferences.jsp".equals(l)) {
 %>
			<li><a href="preferences.jsp?<%=(visible)?"hide":"show"%>Tab=<%= Integer.toString(i)%>" title="<%= ((visible)?"Hide ":"Show ") + n %> Tab"><%= ((visible)?"Hide ":"Show ") + n %> Tab</a></li>
<% }} %>
		</ul>
		<h2 id="misc">Misc Options</h2>
		<ul>
			<li><a id="headings" href="preferences.jsp?Headings=<%= "Off".equalsIgnoreCase(headings)?"On":"Off" %>#misc" title=<%= "Off".equalsIgnoreCase(headings)?"Show":"Hide" %> Headings in Bibles"><%= "Off".equalsIgnoreCase(headings)?"Show":"Hide" %> Headings in Bibles</a></li>
			<li><a id="javascript" href="preferences.jsp?Javascript=<%= "Off".equalsIgnoreCase(javascript)?"On":"Off" %>#misc" title=<%= "Off".equalsIgnoreCase(javascript)?"Use":"Don't Use" %> Javascript"><%= "Off".equalsIgnoreCase(javascript)?"Use":"Don't Use" %> Javascript</a></li>
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
