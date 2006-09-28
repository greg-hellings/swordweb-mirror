<%@ page import="java.io.*" %>
<%@ page import="java.util.Hashtable" %>
<%

String util = "/usr/bin/vs2osisref";
String vs = request.getParameter("vs");



%>


<h1>Adhoc verse reference to OSIS reference</h1>

<form name="vsForm" action="">
   Adhoc text: <input type="text" name="vs" size="80" value="<%=(vs != null)?vs:""%>" /> <br/>
	<input type="submit" value="go" title="Search by keyword or phrase" />
</form>

Result:<br/><br/>

<%
if (vs != null) {
	int result = runCommand(new String[] {util, vs}, out, true, true);
}
%>

<%!

static Object writeSemephore = new Object();
static Hashtable ltoks = new Hashtable();

int runCommand(String command[], Writer result, boolean html, boolean canonize) {
	int retVal = -1;
	try {
//result.write("running command:");
//for (int i = 0; i < command.length; i++)
//	result.write("["+command[i]+"]");
//result.flush();
//return 0;
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

