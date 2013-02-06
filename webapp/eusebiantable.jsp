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
	int contextVerses = 0; try { contextVerses = Integer.parseInt(request.getParameter("context")); } catch (Exception e) {}
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
// Pre context -----------------------------------------------------------------------------
if (contextVerses > 0) {
for (String n : nums) {
	if (n.trim().length() < 1) continue;
	eusNum.setKeyText(n.trim());
	eusNum.getRenderText();
	detailsText = eusNum.getRawEntry();
	XMLTag d = new XMLBlock(detailsText);
	String keyList[] = activeModule.parseKeyList(d.getAttribute("osisRef"));
	activeModule.setKeyText(keyList[0]);
	activeModule.getRenderText();
	String book = activeModule.getKeyChildren()[1];
	String keyText = activeModule.getKeyText();

	for (int c = 0; c < contextVerses; ++c) activeModule.previous();

	// be sure we have an upper limit on the book
	while (!book.equals(activeModule.getKeyChildren()[1])) activeModule.next();
	
%>
<td <%= rtol ? "dir=\"rtl\"" : "" %>>
<%
	while (!keyText.equals(activeModule.getKeyText()) && activeModule.error() == 0) {
		String v = activeModule.getRenderText();
		String currentKeyText = activeModule.getKeyText();
		if (rtol) {
%>
<bdo dir="rtl">
<%
		}
%>

<span class="<%= (currentKeyText.equals(activeKey)) ? "currentverse" : "verse" %>">
<span class="verseNum"><bdo dir="ltr"><a href="passagestudy.jsp?key=<%=activeModule.getKeyText()%>#cv"><%= activeModule.getKeyChildren()[3]%></a></bdo></span><%= v %> 
<%
		if (rtol) {
%>
</bdo>
<%
		}
%>
</span>
<%
		activeModule.next();
	}
%>
</td>
<%
}
%>
</tr>
<%
}
// Eusebian Row(s) Verse Ranges ----------------------------------------------------------
%>
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
		String currentKeyText = activeModule.getKeyText();
	if (rtol) {
%>
<bdo dir="rtl">
<%
	}
%>

<span class="<%= (currentKeyText.equals(activeKey)) ? "currentverse" : "verse" %>">
<span class="verseNum"><bdo dir="ltr"><a href="passagestudy.jsp?key=<%=activeModule.getKeyText()%>#cv"><%= activeModule.getKeyChildren()[3]%></a></bdo></span><%= v %> 
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
<%
// Post context ----------------------------------------------------------------------------------------------
if (contextVerses > 0) {
%>
<tr>
<%
for (String n : nums) {
	if (n.trim().length() < 1) continue;
	eusNum.setKeyText(n.trim());
	eusNum.getRenderText();
	detailsText = eusNum.getRawEntry();
	XMLTag d = new XMLBlock(detailsText);
	String keyList[] = activeModule.parseKeyList(d.getAttribute("osisRef"));
	activeModule.setKeyText(keyList[keyList.length-1]);
	activeModule.getRenderText();
	String book = activeModule.getKeyChildren()[1];
	
%>
<td <%= rtol ? "dir=\"rtl\"" : "" %>>
<%
	activeModule.next();
	for (int i = 0; i < contextVerses && activeModule.error() == 0 && book.equals(activeModule.getKeyChildren()[1]); ++i) {
		String v = activeModule.getRenderText();
		String currentKeyText = activeModule.getKeyText();
		if (rtol) {
%>
<bdo dir="rtl">
<%
		}
%>

<span class="<%= (currentKeyText.equals(activeKey)) ? "currentverse" : "verse" %>">
<span class="verseNum"><bdo dir="ltr"><a href="passagestudy.jsp?key=<%=activeModule.getKeyText()%>#cv"><%= activeModule.getKeyChildren()[3]%></a></bdo></span><%= v %> 
<%
		if (rtol) {
%>
</bdo>
<%
		}
%>
</span>
<%
		activeModule.next();
	}
%>
</td>
<%
}
%>
</tr>
<%
} // end Post context -------------------------------------------------------------------------------------------------------
%>
</tbody>
</table>
