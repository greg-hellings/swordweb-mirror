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
