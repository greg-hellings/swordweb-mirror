<%@ page
    language="java"
    contentType="text/html;charset=utf-8"
%>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.FileOutputStream" %>
<%@ page import="org.crosswire.web.i18n.*" %>
<%@ page import="org.crosswire.utils.*" %>

<html>
<body>
<%
	Set pageTags = (Set)session.getAttribute("pageTags");
	if (pageTags != null) {

		
		String lang = request.getParameter("lang");
		if (lang != null) {
			session.setAttribute("lang", lang);
		}
		else {
			lang = (String)session.getAttribute("lang");
		}

		if (lang == null) lang = "en_US";

		if (request.getParameter("t0") != null) {
			Properties locale = TranslateTag.getSessionLocale(pageContext);
			int i = 0;
			for (Object k : pageTags) {
				String key = (String)k;
				String value = (String)request.getParameter("t"+Integer.toString(i));
				if ((key != null) && (value != null)) {
					value = new String(value.getBytes("iso8859-1"), "UTF-8");
					locale.setProperty(""+key.hashCode(), value);
				}
				++i;
			}

			File propName = new File(pageContext.getServletContext().getRealPath("/WEB-INF/classes/trans_"+lang+".properties"));
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
		int i = 0;
		for (Object k : pageTags) {
			String key   = (String)k;
			String value = TranslateTag.getTranslation(pageContext, key, false);
%>
	<p>
			<%= HTTPUtils.canonize(key) %><br/>
			<input type="text" name="t<%=i%>" size="120" value="<%= HTTPUtils.canonize(value)%>"/>
	</p>
<%
			++i;
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
