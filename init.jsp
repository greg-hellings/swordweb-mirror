<%@ page import="org.crosswire.util.Base64" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.io.ByteArrayOutputStream" %>
<%@ page import="java.io.StringBufferInputStream" %>
<%@ page import="java.io.ObjectOutputStream" %>
<%@ page import="java.io.ObjectInputStream" %>
<%@ page import="org.crosswire.sword.orb.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page
    language="java"
    contentType="text/html;charset=utf-8"
%>
<%
	SWMgr mgr = SwordOrb.getSWMgrInstance(session);
	// let's cache the modInfo in the session cuz this is alot to grab each time we need it from the orb
	ModInfo[] modInfo = (ModInfo[])session.getAttribute("ModInfo");
	if (modInfo == null) {
		// we don't have it cached yet, so get it from the orb and save it in the session
		modInfo = mgr.getModInfoList();
		session.setAttribute("ModInfo", modInfo);
	}

	Vector prefBibles = (Vector)session.getAttribute("PrefBibles");
	Vector prefCommentaries = (Vector)session.getAttribute("PrefCommentaries");
	Vector parDispModules = (Vector)session.getAttribute("ParDispModules");

	Cookie[] cookies = request.getCookies();
	if ((prefBibles == null) && (cookies != null)) {
		for (int i = 0; i < cookies.length; i++) {
			int start, end;
			String field;
			String line;
			if (cookies[i].getName().equals("PrefBibles")) {
				prefBibles = new Vector();
				start = 0;
				end = 1;
				line = cookies[i].getValue();
				while (end > 0) {
					end = line.indexOf("+",start);
					field = (end > 0) ? line.substring(start, end) : line.substring(start);
					if (start > 3) 		// skip the first one cuz it's not a real module
						prefBibles.add(field);
					start = end + 1;
				}
			}
			else if (cookies[i].getName().equals("PrefCommentaries")) {
				prefCommentaries = new Vector();
				start = 0;
				end = 1;
				line = cookies[i].getValue();
				while (end > 0) {
					end = line.indexOf("+",start);
					field = (end > 0) ? line.substring(start, end) : line.substring(start);
					if (start > 3)  		// skip the first one cuz it's not a real module
						prefCommentaries.add(field);
					start = end + 1;
				}
			}
		}
	}

	if (prefBibles == null)
		prefBibles = new Vector();
	if (prefCommentaries == null)
		prefCommentaries = new Vector();
	if (parDispModules == null)
		parDispModules = new Vector();

	session.setAttribute("PrefBibles", prefBibles);
	session.setAttribute("PrefCommentaries", prefCommentaries);
	session.setAttribute("ParDispModules", parDispModules);
/*
	// kept around in case we ever need it again
				// de-serialize from cookie
				Base64.InputStream bis = new Base64.InputStream(new StringBufferInputStream(cookies[i].getValue()));
				ObjectInputStream ois = new ObjectInputStream(bis);
				prefBibles = (Vector)ois.readObject();
				prefCommentaries = (Vector)ois.readObject();
*/
%>
