<%@ page
    language="java"
    contentType="text/html;charset=utf-8"
%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="org.crosswire.sword.orb.*" %>

<%
	SWMgr mgr = SwordOrb.getSWMgrInstance(request);

String util = "/usr/bin/vs2osisref";
String util2 = "/usr/bin/parsekey";
String vs = request.getParameter("vs");
String locale = request.getParameter("lo");
String context = request.getParameter("co");
if (vs == null) vs = "";
if (locale == null) locale = "en";
if (context == null) context = "gen.1.1";

vs = new String(vs.getBytes("iso8859-1"), "UTF-8");
context = new String(context.getBytes("iso8859-1"), "UTF-8");

%>


<h1>Adhoc verse reference to OSIS reference</h1>

<form name="vsForm" action="">
<table>
   <tr><td>Adhoc text:</td><td><input type="text" name="vs" size="80" value="<%=vs%>" /></td></tr>
   <tr><td>Context:</td><td><input type="text" name="co" size="80" value="<%=context%>" /></td></tr>
   <tr><td>Locale: first</td><td>
  <select name="lo">
<%
        String[] locales = mgr.getAvailableLocales();
        for (int i = 0; i < locales.length; i++) {
%>
            <option value="<%= locales[i]%>" <%= locales[i].equals(locale) ? "selected=\"selected\"":"" %>><%=locales[i]%></option>
<%
        }
 %>
   </select> (then fallback to "en")</td></tr>
</table>
	<input type="submit" value="go" title="Search by keyword or phrase" />
</form>

<%
if (vs != null && vs.length() > 0) {
	int result = 0;
%>
<br/><h3>Verse List:</h3><br/>
<%
	result = runCommand(new String[] {util2, vs, locale, "KJV", context}, out, true, true);
%>
<br/><h3>OSIS Reference:</h3><br/>
<%
	result = runCommand(new String[] {util, vs, context, locale}, out, true, true);
}
%>

<%!

static Object writeSemephore = new Object();
static Hashtable ltoks = new Hashtable();

int runCommand(String command[], Writer result, boolean html, boolean canonize) {
	int retVal = -1;
	try {
		java.lang.Process p = Runtime.getRuntime().exec(command);

		InputStream is = p.getInputStream();
		InputStreamReader isr = new InputStreamReader(is);
		BufferedReader input = new BufferedReader(isr);

		String line;
		while ((line = input.readLine()) != null) {
            		if (canonize) {
				line = org.crosswire.utils.HTTPUtils.canonize(line);
			}
			result.write(line + ((!html) ? "\n ":"<br>"));
		}
		retVal = p.waitFor();
	}
	catch (Exception e) {e.printStackTrace();}
	return retVal;
}


%>

