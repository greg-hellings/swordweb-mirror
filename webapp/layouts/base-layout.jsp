<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/crosswire-i18n.tld" prefix="t" %>

<%@ page import="java.util.Vector" %>
<%
	String lang = (String)session.getAttribute("lang");
	if (lang == null) lang = "en-US";
	Vector rtolLangs = (Vector)session.getAttribute("rtolLangs");
	String dir = rtolLangs.contains(lang) ? "rtol" : "ltor";
	String prefStyle = (String)session.getAttribute("PrefStyle");
	Vector styleNames = (Vector)session.getAttribute("styleNames");
	Vector styleFiles = (Vector)session.getAttribute("styleFiles");
	int style = styleNames.indexOf(prefStyle);
	String styleName = (String)styleNames.get(style);
	String styleFile = (String)styleFiles.get(style);
	String searchTerm = request.getParameter("searchTerm");
	if (searchTerm != null) {
		searchTerm = new String(searchTerm.getBytes("iso8859-1"), "UTF-8");
	}
	else searchTerm = "";
	String metaContent = (String)session.getAttribute("meta");
%>

<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:og="http://ogp.me/ns#" xmlns:fb="https://www.facebook.com/2008/fbml" xml:lang="<%= lang %>" lang="<%= lang %>">

<head profile="http://www.w3.org/2000/08/w3c-synd/#">
<meta name="keywords" content="<%= metaContent %>" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title><t:t>OSIS Web: </t:t><tiles:getAsString name="title"/></title>

	<tiles:getAsString name="extraMeta" />

<link rel="stylesheet" type="text/css" media="all" href="common.css"  />
<link rel="stylesheet" type="text/css" media="all" title="<%= styleName %>" href="<%= styleFile %>"  />

<link rel="stylesheet" type="text/css" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/themes/base/jquery-ui.css"/>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.8/jquery.min.js"></script>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/jquery-ui.min.js"></script>


<% for (int i = 0; i < styleNames.size(); i++) { %>
<link rel="alternate stylesheet" type="text/css" media="all" title="<%= (String)styleNames.get(i) %>" href="<%= (String)styleFiles.get(i) %>" />
<% } %>

	<!--For printing stuff -->
	<link rel="stylesheet" type="text/css" media="print" href="print.css" />
	<script type="text/javascript" src="swordweb.js"></script>
</head>

	<body onload="onPageLoad();" class="<%= dir %>">
<div id="fb-root"></div>
<script>
(function(d, s, id) {
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) return;
  js = d.createElement(s); js.id = id;
  js.src = "//connect.facebook.net/en_US/all.js#xfbml=1";
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));
</script>

	<%-- include header --%>
	<tiles:insert attribute="header" />
	<tiles:insert attribute="pintro" />

<div id="content-wrap">
	<div id="printer">
		<p>
		<img src="images/printer.gif" onclick="javascript:void(window.print())" width="17" height="16" title="<t:t>This is a printer friendly version</t:t>" alt="<t:t>This is a printer friendly version</t:t>" />
		</p>
	</div>
   <div id="content-sub-1">
      <div id="quicksearch">
        <h2><t:t>Search:</t:t></h2>
        <form action="wordsearchresults.jsp">
          <fieldset>
            <legend><t:t>by keyword or phrase:</t:t></legend>
<input name="searchTerm" type="text" size="10" value="<%=org.crosswire.utils.HTTPUtils.canonize(searchTerm)%>" /> <button value="go"><t:t>go</t:t></button>
          </fieldset>
        </form>
        <h2><t:t>Go to:</t:t></h2>
	<form action="<tiles:getAsString name="lookup_url"/>">
          <fieldset>
            <legend><t:t>Bible reference:</t:t></legend>
<input name="key" type="text" size="10" /> <button value="go"><t:t>go</t:t></button>
          </fieldset>
        </form>
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
<%
	String translator = (String)session.getAttribute("translator");
	if (translator != null) {
%>
	<center><i><a href="admin/translate/">Translate this page</a></i></center>
<%
	}
%>

</body>
</html>
