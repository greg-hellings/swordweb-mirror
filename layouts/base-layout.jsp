<%@ taglib uri="/WEB-INF/lib/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/lib/struts-html.tld" prefix="html" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
	"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>OSIS Web:<tiles:getAsString name="title"/></title>

		<link href="wash.css" title="Washed Out" rel="stylesheet" type="text/css" />
		<link href="blue.css" title="Old Blue" rel="alternate stylesheet" type="text/css" />
		<link href="blank.css" title="Blank" rel="alternate stylesheet" type="text/css" />

		<!--For printing stuff -->
		<link rel="stylesheet" type="text/css" media="print" href="print.css" />
</head>

	<body>
	<%-- include footer --%>
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
        <form action="passagestudy.jsp">
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
		This page is printer friendly.
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
