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
	<tiles:put name="sidebar_left" type="string">
		<div id="translations">

		<h2>Translations:</h2>
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

		<hr/>

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

		<ul>
		<hr/>
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
		<h2>Preferred Bibles</h2>
		Click to remove.  Reselect on the side to move to the top.
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
		Click to remove.  Reselect on the side to move to the top.
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
