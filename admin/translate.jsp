<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.FileOutputStream" %>
<%@ page import="org.crosswire.web.i18n.*" %>

<html>
<body>
<%
	Vector pageTags = (Vector)session.getAttribute("pageTags");
	if (pageTags != null) {

		
		if (request.getParameter("t0") != null) {
			Properties locale = TranslateTag.getSessionLocale(pageContext);
			for (int i = 0; i < pageTags.size(); i++) {
				String key = (String)pageTags.get(i);
				String value = (String)request.getParameter("t"+Integer.toString(i));
				if ((key != null) && (value != null)) {
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
<p>Strings which are marked for translation:</p>
	<form action="translate.jsp?action=save">
		<fieldset>
<%
		for (int i = 0; i < pageTags.size(); i++) {
			String key   = (String)pageTags.get(i);
			String value = TranslateTag.getTranslation(pageContext, key, false);
%>
			<legend><%= key %></legend>
			<input type="text" name="t<%=i%>" size="100" value="<%=value%>"/>
			<br/>
<%
		}
%>
			<input type="submit" value="go" title="Search by keyword or phrase" />
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
