<%@ page
    language="java"
    contentType="text/html;charset=utf-8"
%>
<%@ include file="init.jsp" %>

<%@ page import="org.crosswire.utils.HTTPUtils" %>
<%@ page import="org.crosswire.xml.XMLBlock" %>
<%@ page import="org.crosswire.sword.keys.*" %>
<%@ page import="org.crosswire.xml.*" %>
<%@ page import="java.util.Arrays" %>

<%
%>
<tiles:insert beanName="basic" flush="true" >
	<tiles:put name="lookup_url" value="witnessgrid.jsp" />
	<tiles:put name="title" value="New Testament Witnesses" />
	<tiles:put name="pintro" type="string" ><div></div></tiles:put>
	<tiles:put name="sidebar_left" type="string">
	</tiles:put>
	<tiles:put name="sidebar_right" type="string">
		<h3>Date: <span id="contextValue">400</span>CE</h3>
		<div style="height:400px; margin:0px 8px 0px 5px;" id="contextControl"></div>
	</tiles:put>

	<tiles:put name="content" type="string">
<style>

.verseNum a:link {
	text-decoration: none;
}

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
</div>
<div id="eusebianTable">
<table style="margin:100px 10px 10px 10px; border-collapse:collapse;">
<thead>
<tr>
<th></th>
<%
for (int i = 1; i < 35; ++i) {
%>
<th><%= i %></th>
<%
}
%>
</tr>
</thead>
<tbody>
<%
VerseKey vk = new VerseKey("Matt.1.1");
while (vk.popError()==0) {
%>
<tr>
<th><%=vk.getBookName()%></th>
<%
	for (int i = 0; i < vk.getChapterMax(); ++i) {
/*
		StringBuffer vmrResponse = HTTPUtils.postURL("http://ntvmr.uni-muenster.de/community/vmr/api/metadata/liste/search/", "biblicalContent="+vk.getBookName()+"."+vk.getChapter()+"&detail=page&limit=40");
		XMLBlock manuscripts = new XMLBlock(vmrResponse.toString());
		for (XMLBlock m : manuscripts.getBlocks("manuscript")) {
		}
*/
%>
<td></td>
<%
	}
%>
</tr>
<%
	vk.setBook(vk.getBook()+1);
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
			orientation: 'vertical',
			min: 0, max: 5,
			change: function(event, ui) {
			},
			slide: function(event, ui) {
				$('#contextValue').html(ui.value);
			}
		});
	});
</script>
	</tiles:put>
</tiles:insert>
