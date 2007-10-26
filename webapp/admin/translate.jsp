<%@ page
    language="java"
    contentType="text/html;charset=utf-8"
%>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.FileOutputStream" %>
<%@ page import="org.crosswire.web.i18n.*" %>
<%@ page import="org.crosswire.utils.*" %>

<html>
<body>
<%
	Vector pageTags = (Vector)session.getAttribute("pageTags");
	if (pageTags != null) {

		
		String lang = request.getParameter("lang");
		if (lang != null) {
			session.setAttribute("lang", lang);
		}
		else {
			lang = (String)session.getAttribute("lang");
		}

		if (request.getParameter("t0") != null) {
			Properties locale = TranslateTag.getSessionLocale(pageContext);
			for (int i = 0; i < pageTags.size(); i++) {
				String key = (String)pageTags.get(i);
				String value = (String)request.getParameter("t"+Integer.toString(i));
				if ((key != null) && (value != null)) {
					value = new String(value.getBytes("iso8859-1"), "UTF-8");
					locale.setProperty(""+key.hashCode(), value);
				}
			}

			String localeName = (String)session.getAttribute("lang");
			File propName = new File(pageContext.getServletContext().getRealPath("/WEB-INF/classes/trans_"+localeName+".properties"));
			FileOutputStream propFile = new FileOutputStream(propName);
			locale.store(propFile, null);
			propFile.close();
		}

		String requestURL = (String)session.getAttribute("requestURL");
	
%>
<p><a href="<%=requestURL%>">Return to website</a></p>
	<form action="translate.jsp">
		<fieldset>
			<legend>Language (use proper country codes (es, en, fr, etc.): </legend>
			<input type="text" name="lang" size="10" value="<%=lang%>"/>
			<input type="submit" value="switch" title="switch language" />
		</fieldset>
	</form>
	<form action="translate.jsp" method="POST">
		<fieldset>
			<legend>Strings which are marked for translation:</legend>
<%
		for (int i = 0; i < pageTags.size(); i++) {
			String key   = (String)pageTags.get(i);
			String value = TranslateTag.getTranslation(pageContext, key, false);
%>
	<p>
			<%= HTTPUtils.canonize(key) %><br/>
			<input type="text" name="t<%=i%>" size="120" value="<%= HTTPUtils.canonize(value)%>"/>
	</p>
<%
		}
%>
			<input type="submit" value="save" title="Save translation strings" />
		</fieldset>
	</form>
<%
	}
	else {
%>

<p>No strings which are marked for translation.</p>
<p><a href="<%= session.getAttribute("requestURL") %>">Return to website</a></p>
<%
	}
%>
</body>
</html>
