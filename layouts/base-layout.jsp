<%@ taglib uri="/WEB-INF/lib/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/lib/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/lib/crosswire-i18n.tld" prefix="t" %>

<%@ page import="java.util.Vector" %>

<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-US" lang="en-US">

<head profile="http://www.w3.org/2000/08/w3c-synd/#">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title><t:t>OSIS Web: </t:t><tiles:getAsString name="title"/></title>

<%
	String prefStyle = (String)session.getAttribute("PrefStyle");
	Vector styleNames = (Vector)session.getAttribute("styleNames");
	Vector styleFiles = (Vector)session.getAttribute("styleFiles");
	int style = styleNames.indexOf(prefStyle);
	String styleName = (String)styleNames.get(style);
	String styleFile = (String)styleFiles.get(style);
%>

<link rel="stylesheet" type="text/css" media="all" title="<%= styleName %>" href="<%= styleFile %>"  />

<% for (int i = 0; i < styleNames.size(); i++) { %>
<link rel="alternate stylesheet" type="text/css" media="all" title="<%= (String)styleNames.get(i) %>" href="<%= (String)styleFiles.get(i) %>" />
<% } %>

	<!--For printing stuff -->
	<link rel="stylesheet" type="text/css" media="print" href="print.css" />
	<script type="text/javascript" src="swordweb.js"></script>
</head>

	<body>
	<%-- include header --%>
	<tiles:insert attribute="header" />
	<tiles:insert attribute="pintro" />

<div id="content-wrap">
   <div id="content-sub-1">
      <div id="quicksearch">
        <h2><t:t>Search:</t:t></h2>
        <form action="wordsearchresults.jsp">
          <fieldset>
            <legend><t:t>by keyword or phrase:</t:t></legend> <input type="text" name="searchTerm" size="10" /> <input type="submit" value="go" title="Search by keyword or phrase" />
          </fieldset>
        </form>
	<form action="<tiles:getAsString name="lookup_url"/>">
          <fieldset>
            <legend><t:t>by verse or passage:</t:t></legend> <input type="text" name="key" size="10" /> <input type="submit" value="go" title="Search by verse or passage" />
          </fieldset>
        </form>
      </div>
     <%-- include left sidebar --%>
     <tiles:insert attribute="sidebar_left" />
   </div>

	<div id="content-sub-2">
		<div id="printer">
		<p>
		<img src="images/printer.gif" width="17" height="16" alt="This is a printer friendly version" />
		<a href="about.jsp#faq_11" title="What does &quot;Printer Friendly&quot; mean?"><t:t>This page is printer friendly</t:t></a>.
		</p>
		</div>

		<%-- include right sidebar --%>
		<tiles:insert attribute="sidebar_right" />
	</div>

	<div id="content-main">
		<%-- include main content --%>
		<tiles:insert attribute="content" />
	</div>
</div>

<%-- include footer --%>
<tiles:insert attribute="footer" />
<%
	String translator = (String)session.getAttribute("translator");
	if (translator != null) {
%>
	<center><i><a href="admin/translate.jsp">Translate this page</a></i></center>
<%
	}
%>

</body>
</html>
