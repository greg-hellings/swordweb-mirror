<%@ include file="init.jsp" %>

<%
	String resetModule = request.getParameter("mod");
	if (resetModule != null)
		session.setAttribute("ActiveModule", resetModule);
	String activeModuleName = (String) session.getAttribute("ActiveModule");
	SWModule activeModule = mgr.getModuleByName((activeModuleName == null) ? defaultBible : activeModuleName);
%>

<tiles:insert beanName="basic" flush="true" >
	<tiles:put name="title" value="Powersearch" />
	<tiles:put name="pintro" type="string" ><div></div></tiles:put>
	<tiles:put name="sidebar_left" type="string">

	<div id="translations">

		<h2><t:t>Translations:</t:t></h2>
		<ul>
		<%
			for (int i = 0; i < prefBibles.size(); i++) {
				SWModule module = mgr.getModuleByName((String)prefBibles.get(i));
		%>
				<li><a href="powersearch.jsp?mod=<%= URLEncoder.encode(module.getName()) %>" title="Add <%= module.getDescription().replaceAll("&", "&amp;") %>"><%= module.getDescription().replaceAll("&", "&amp;") %></a></li>
		<%
			}
		%>

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

		<h2><t:t>Comentaries:</t:t></h2>
		<ul>
		<%
			for (int i = 0; i < prefCommentaries.size(); i++) {
				SWModule module = mgr.getModuleByName((String)prefCommentaries.get(i));
		%>
				<li><a href="powersearch.jsp?mod=<%= URLEncoder.encode(module.getName()) %>" title="Add <%= module.getDescription().replaceAll("&", "&amp;") %>"><%= module.getDescription().replaceAll("&", "&amp;") %></a></li>
		<%
			}
		%>

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
<div id="powersearch">
		<h2><t:t>Power Search</t:t></h2>
		<t:t>Module to search:</t:t>
		<p class="textname">&raquo; <%= activeModule.getDescription().replaceAll("&", "&amp;") + " (" + activeModule.getName() + ")" %></p>
		<form action="wordsearchresults.jsp">
			<fieldset>
				<b><t:t>Search Term:</t:t></b><br/>
				<input type="text" name="searchTerm" class="textinput" value="" /><br/><br/>

				<b><t:t>Search Type:</t:t></b><br/>
				<input type="radio" name="stype" value="M" checked="checked" /><t:t>All Words or Word Fragments</t:t><br/>
				<input type="radio" name="stype" value="P" /><t:t>Exact Phrase</t:t><br/>
				<input type="radio" name="stype" value="R" /><t:t>Advanced- Regular Expression</t:t><br/><br/>
				<input type="checkbox" name="icase" value="1" checked="checked"/><t:t>Ignore Case (UPPER/lower isn't strictly matched)</t:t><br/><br/>
				<b><t:t>Limit Search to Range:</t:t></b><br/>
				<input type="text" name="range" class="textinput" value="" /><br/><t:t>(most syntax works, e.g.  mat-jn;rom;rev 1-5)</t:t><br/><br/>

				<input type="submit" class="searchbutton" value=" Search " />
			</fieldset>
		</form>
</div>
	</tiles:put>
</tiles:insert>
