<%@ include file="defines/tiles.jsp" %>

<%
	String resetModule = request.getParameter("mod");
	if (resetModule != null)
		session.setAttribute("ActiveModule", resetModule);
	String activeModuleName = (String) session.getAttribute("ActiveModule");
	SWModule activeModule = mgr.getModuleByName((activeModuleName == null) ? "WEB" : activeModuleName);
%>

<tiles:insert beanName="basic" flush="true" >
	<tiles:put name="title" value="Powersearch" />
	<tiles:put name="sidebar_left" type="string">

	<div id="translations">

		<h2>Translations:</h2>
		<ul>
		<%
			for (int i = 0; i < prefBibles.size(); i++) {
				SWModule module = mgr.getModuleByName((String)prefBibles.get(i));
		%>
				<li><a href="powersearch.jsp?mod=<%= URLEncoder.encode(module.getName()) %>" title="Add <%= module.getDescription().replaceAll("&", "&amp;") %>"><%= module.getDescription().replaceAll("&", "&amp;") %></a></li>
		<%
			}
		%>
		<hr/>
		<%
			for (int i = 0; i < modInfo.length; i++) {
				if (modInfo[i].category.equals(SwordOrb.BIBLES)) {
					SWModule module = mgr.getModuleByName(modInfo[i].name);
		%>
				<li><a href="powersearch.jsp?mod=<%= URLEncoder.encode(modInfo[i].name) %>" title="Add <%= module.getDescription().replaceAll("&", "&amp;") %>"><%= module.getDescription().replaceAll("&", "&amp;") %></a></li>
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
				<li><a href="powersearch.jsp?mod=<%= URLEncoder.encode(module.getName()) %>" title="Add <%= module.getDescription().replaceAll("&", "&amp;") %>"><%= module.getDescription().replaceAll("&", "&amp;") %></a></li>
		<%
			}
		%>
		<hr/>
		<%
			for (int i = 0; i < modInfo.length; i++) {
				if (modInfo[i].category.equals(SwordOrb.COMMENTARIES)) {
					SWModule module = mgr.getModuleByName(modInfo[i].name);
		%>
				<li><a href="powersearch.jsp?mod=<%= URLEncoder.encode(modInfo[i].name) %>" title="Add <%= module.getDescription().replaceAll("&", "&amp;") %>"><%= module.getDescription().replaceAll("&", "&amp;") %></a></li>
		<%
				}
			}
		%>
		</ul>
		</div>
	</tiles:put>

	<tiles:put name="content" type="string">
		<h2>Power Search</h2>
		Module to search:
		<p class="textname">&raquo; <%= activeModule.getDescription().replaceAll("&", "&amp;") + " (" + activeModule.getName() + ")" %></p>
		<form action="wordsearchresults.jsp">
			<fieldset>
				<b>Search Term:</b><br/>
				<input type="text" name="searchTerm" class="textinput" value="" /><br/><br/>

				<b>Search Type:</b><br/>
				<input type="radio" name="stype" value="M" checked="true" />All Words or Word Fragments<br/>
				<input type="radio" name="stype" value="P" />Exact Phrase<br/>
				<input type="radio" name="stype" value="R" />Advanced- Regular Expression<br/><br/>
				<input type="checkbox" name="icase" value="1" checked="true"/>Ignore Case (UPPER/lower isn't strictly matched)<br/><br/>
				<b>Limit Search to Range:</b><br/>
				<input type="text" name="range" class="textinput" value="" /><br/>(most syntax works, e.g.  mat-jn;rom;rev 1-5)<br/><br/>

				<input type="submit" class="searchbutton" value=" Search " />
			</fieldset>
		</form>

	</tiles:put>
</tiles:insert>
