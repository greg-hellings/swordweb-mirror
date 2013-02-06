<%@ page
    language="java"
    contentType="text/html;charset=utf-8"
%>
<%@ include file="init.jsp" %>

<%@ page import="org.crosswire.sword.orb.*" %>
<%@ page import="org.crosswire.xml.*" %>
<%@ page import="java.util.Arrays" %>

<%
	String resetModule = request.getParameter("mod");
	if (resetModule != null) {
		session.setAttribute("ActiveModule", resetModule);
	}
	String activeModuleName = (String) session.getAttribute("ActiveModule");
	if (activeModuleName == null) activeModuleName = defaultBible;
	SWModule activeModule = mgr.getModuleByName(activeModuleName);

	String resetKey = request.getParameter("key");
	if (resetKey != null) {
		resetKey = new String(resetKey.getBytes("iso8859-1"), "UTF-8");
		activeModule.setKeyText(resetKey);
		session.setAttribute("ActiveKey", activeModule.getKeyText());
	}
	String activeKey = (String) session.getAttribute("ActiveKey");
	if (activeKey == null) {
		activeKey = "john 1:1";
		session.setAttribute("ActiveKey", activeKey);
	}

	mgr.setGlobalOption("Footnotes", "Off");
	mgr.setGlobalOption("Cross-references", "Off");
	SWModule eusVs = mgr.getModuleByName("Eusebian_vs");
	SWModule eusNum = mgr.getModuleByName("Eusebian_num");
	String promoLine = activeModule.getConfigEntry("ShortPromo");

	eusVs.setKeyText(activeKey);
	String num = eusVs.getStripText().trim();
	eusNum.setKeyText(num);
	String detailsText = eusNum.getRawEntry();
	XMLTag details = new XMLBlock(detailsText);
	String []nums = (num + " " + details.getAttribute("assocates")).split(" ");
	Arrays.sort(nums);
	String lang = activeModule.getConfigEntry("Lang");
	boolean rtol = ("RtoL".equalsIgnoreCase(activeModule.getConfigEntry("Direction")));
%>
<tiles:insert beanName="basic" flush="true" >
	<tiles:put name="lookup_url" value="eusebian.jsp" />
	<tiles:put name="title" value="Eusebian Parallel study" />
	<tiles:put name="pintro" type="string" ><div></div></tiles:put>
	<tiles:put name="sidebar_left" type="string">
		<div id="translations">
		<h2><t:t>Translations:</t:t></h2>
		<h3><t:t>Preferred Translations</t:t></h3>

	<% if (prefBibles.size() > 0) { %>
		<ul>
		<%
			for (int i = 0; i < prefBibles.size(); i++) {
				SWModule module = mgr.getModuleByName((String)prefBibles.get(i));
		%>
				<li><a href="eusebian.jsp?mod=<%= URLEncoder.encode(module.getName())+"#cv" %>" title="view in <%= new String(module.getDescription().replaceAll("&", "&amp;").getBytes("iso8859-1"), "UTF-8") %>"><%= new String(module.getDescription().replaceAll("&", "&amp;").getBytes("iso8859-1"), "UTF-8") %></a></li>
		<%
			}
		%>
		</ul>
	<% } else { %>
		<ul>
		<li><t:t>Preferred Translations can be selected from the preferences tab</t:t></li>
		</ul>
	<% } %>


<h3><t:t>All Translations</t:t></h3>
		<%
			if (modInfo.length > 0) {
%>
		<ul>
<%
				for (int i = 0; i < modInfo.length; i++) {
					if (modInfo[i].category.equals(SwordOrb.BIBLES)) {
						SWModule module = mgr.getModuleByName(modInfo[i].name);
			%>
					<li><a href="eusebian.jsp?mod=<%= URLEncoder.encode(modInfo[i].name)+"#cv" %>" title="view Romans 8:26-39 in <%= module.getDescription().replaceAll("&", "&amp;") %>"><%= module.getDescription().replaceAll("&", "&amp;") %></a></li>
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
<h3><a href="fulllibrary.jsp?show=<%= URLEncoder.encode(activeModule.getName()) %>"><%= activeModule.getDescription().replaceAll("&", "&amp;") %></a></h3>
	<div class="promoLine"><%= promoLine %></div>
<%
			String copyLine = activeModule.getConfigEntry("ShortCopyright");
			if (copyLine.equalsIgnoreCase("<swnull>")) {
				copyLine = "";
			}
			if (activeModule.getCategory().equals("Cults / Unorthodox / Questionable Material")) {
				copyLine = "<t:t>WARNING: This text is considered unorthodox by most of Christendom.</t:t> " + copyLine;
			}
%>
		<div class="copyLine"><%= copyLine %></div>
	</tiles:put>

	<tiles:put name="content" type="string">
<style>

.verseNum {
	color:blue;
	font-size: .75em;
    line-height: 0.5em;
    vertical-align: baseline;
    position: relative;
    top: -0.4em;
}

td {
	vertical-align:top;
	border: 1px solid grey;
	padding: 5px;
}
</style>
<div id="passagestudy">
<div style="width:100%">
		<div style="margin:0px 12px 0px 0px;width:300px;float:right;">
		<h3>Extra context verses: <span id="contextValue">0</span></h3>
		<div style="margin:0px 8px 0px 5px;" id="contextControl"></div>
		</div>

		<div style="margin:0px 0px 0px 12px;float:left;">
		<h2><%= activeKey %></h2>
<h3>Eusebian Number <%=num%> (Table <%=details.getAttribute("table")%>)</h3>
		</div>
</div>
<div id="eusebianTable">
<table style="margin:100px 10px 10px 10px; border-collapse:collapse;" class="<%= lang %>">
<thead>
<tr>
<%
for (String n : nums) {
	if (n.trim().length() < 1) continue;
%>
<th><%= n %></th>
<%
}
%>
</tr>
<tr>
<%
for (String n : nums) {
	if (n.trim().length() < 1) continue;
	eusNum.setKeyText(n.trim());
	eusNum.getRenderText();
	detailsText = eusNum.getRawEntry();
	XMLTag d = new XMLBlock(detailsText);
%>
<th><%= d.getAttribute("osisRef") %></th>
<%
}
%>
</tr>
</thead>
<tbody>
<tr>
<%
for (String n : nums) {
	if (n.trim().length() < 1) continue;
	eusNum.setKeyText(n.trim());
	eusNum.getRenderText();
	detailsText = eusNum.getRawEntry();
	XMLTag d = new XMLBlock(detailsText);
	String keyList[] = activeModule.parseKeyList(d.getAttribute("osisRef"));
%>
<td <%= rtol ? "dir=\"rtl\"" : "" %>>
<%
	for (String k : keyList) {
		activeModule.setKeyText(k);
		String v = activeModule.getRenderText();
		String keyText = activeModule.getKeyText();
	if (rtol) {
%>
<bdo dir="rtl">
<%
	}
%>

<span class="<%= (keyText.equals(activeKey)) ? "currentverse" : "verse" %>">
<span class="verseNum"><bdo dir="ltr"><%= activeModule.getKeyChildren()[3]%></bdo></span><%= v %> 
<%
	if (rtol) {
%>
</bdo>
<%
	}
%>
</span>
<%
	}
%>
</td>
<%
}
%>
</tr>
</tbody>
</table>
</div>
</div>
<script type="text/javascript">

	$(document).ready(function() {

		$("#contextControl").slider({
			min: 0, max: 5,
			change: function(event, ui) {
				var postData = 'mod=<%=activeModule.getName()%>&key=<%=activeKey%>&context='+ui.value;

				$.post('eusebiantable.jsp', postData, function(data) {
					$('#eusebianTable').html(data);
				});
			},
			slide: function(event, ui) {
				$('#contextValue').html(ui.value);
			}
		});
	});
</script>
	</tiles:put>
</tiles:insert>
