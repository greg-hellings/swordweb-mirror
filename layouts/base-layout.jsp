<%@ taglib uri="/WEB-INF/lib/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/lib/struts-html.tld" prefix="html" %>

<%@ include file="../init.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
	"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>OSIS Web:<tiles:getAsString name="title"/></title>

<%
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
</head>

	<body>
	<%-- include header --%>
	<tiles:insert attribute="header" />

<div id="content-wrap">
   <div id="content-sub-1">
      <div id="quicksearch">
        <h2>Search:</h2>
        <form action="wordsearchresults.jsp">
          <fieldset>
            <legend>by keyword or phrase:</legend> <input type="text" name="searchTerm" size="10" /> <input type="submit" value="go" title="Search by keyword or phrase" />
          </fieldset>
        </form>
	<form action="<tiles:getAsString name="lookup_url"/>">
          <fieldset>
            <legend>by verse or passage:</legend> <input type="text" name="key" size="10" /> <input type="submit" value="go" title="Search by verse or passage" />
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
		<a href="about.jsp#faq_11" title="What does &quot;Printer Friendly&quot; mean?">This page is printer friendly</a>.
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

</body>
</html>
