<%@ taglib uri="/WEB-INF/lib/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/lib/struts-html.tld" prefix="html" %>

<?xml version="1.0"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
	"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>
		OSIS Web: <tiles:getAsString name="title"/>
	</title>
	<link href="blues.css" title="Blue" rel="stylesheet" type="text/css" />
	<link href="blank.css" title="Blank" rel="alternate stylesheet" type="text/css" />
</head>
<body>
	<%-- include footer --%>
	<tiles:insert attribute="header" />

	<div id="content-wrap">
		<div id="content-sub-1">
			<div class="quicksearch">
				<h2>Search:</h2>
				<p>by keyword or phrase:</p>
				<form action="wordsearchresults.jsp">
					<fieldset>
						<input type="text" name="searchTerm" class="textinput" value="" />
					<input type="submit" class="searchbutton" value="go" />
					</fieldset>
				</form>
				<p>by verse or passage:</p>
				<form action="<tiles:getAsString name="lookup_url"/>">
					<fieldset>
						<input type="text" name="key" class="textinput" value="" />
						<input type="submit" class="searchbutton" value="go" />
					</fieldset>
				</form>
				<p><a href="powersearch.jsp" title="View more options for a more powerful search.">Power Search</a></p>
				<p><a href="preferences.jsp" title="Set your personal preferences.">Preferences</a></p>
			</div>

			<%-- include left sidebar --%>
			<tiles:insert attribute="sidebar_left" />
		</div>

		<div id="content-sub-2">
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
