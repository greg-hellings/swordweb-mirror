<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-US" lang="en-US">
<%@ page
    language="java"
    contentType="text/html;charset=utf-8"
%>

<%@ taglib uri="/WEB-INF/lib/crosswire-i18n.tld" prefix="t" %>
<%
	String lang = request.getParameter("lang");
	if (lang != null)
		session.setAttribute("lang", lang);
%>
<html>
<body>
<t:pagestart/>
below is translated text<br/>
<t:t>Translate this text</t:t><br/>
<t:t>Translate text 2</t:t>

<br/><br/>
<a href="../admin/translate.jsp">Translate this page</a>
</body>
</html>
