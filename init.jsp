<%@ page
    language="java"
    contentType="text/html;charset=utf-8"
%>
<%@ page import="org.crosswire.util.Base64" %>
<%@ page import="java.util.Vector" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.util.Comparator" %>
<%@ page import="org.crosswire.sword.orb.*" %>
<%@ page import="java.net.URLEncoder" %>
<%
	SWMgr mgr = SwordOrb.getSWMgrInstance(session);
	// let's cache the modInfo in the session cuz this is alot to grab each time we need it from the orb
	ModInfo[] modInfo = (ModInfo[])session.getAttribute("ModInfo");
	if (modInfo == null) {
		// we don't have it cached yet, so get it from the orb and save it in the session
		modInfo = mgr.getModInfoList();
		Arrays.sort(modInfo, new Comparator() {
			public int compare(Object o1, Object o2) {
				ModInfo m1 = (ModInfo) o1;
				ModInfo m2 = (ModInfo) o2;
				StringBuffer comp1 = new StringBuffer();
				StringBuffer comp2 = new StringBuffer();
				for (int i = 0; i < 2; i++) {
					ModInfo mi = (i == 0)?m1:m2;
					StringBuffer sb = (i==0)?comp1:comp2;
					if (mi.category.equals(SwordOrb.BIBLES)) {
						sb.append("1");
					}
					else if (mi.category.equals(SwordOrb.COMMENTARIES)) {
						sb.append("2");
					}
					else if (mi.category.equals(SwordOrb.DAILYDEVOS)) {
						sb.append("3");
					}
					else if (mi.category.equals(SwordOrb.LEXDICTS)) {
						sb.append("4");
					}
					else if (mi.category.equals(SwordOrb.GENBOOKS)) {
						sb.append("5");
					}
				}
				comp1.append(m1.description);
				comp2.append(m2.description);
				return (comp1.toString().compareTo(comp2.toString()));
			}
		});
		session.setAttribute("ModInfo", modInfo);
	}

	Vector prefBibles = (Vector)session.getAttribute("PrefBibles");
	Vector prefCommentaries = (Vector)session.getAttribute("PrefCommentaries");
	Vector parDispModules = (Vector)session.getAttribute("ParDispModules");
	String prefStyle = (String)session.getAttribute("PrefStyle");
	static Vector styleNames = null;
	static Vector styleFiles = null;
	static Vector styleDescriptions = null;

	synchronized(this) {
		if (styleNames == null) {

			styleNames = new Vector();
			styleFiles = new Vector();
			styleDescriptions = new Vector();

			styleNames.add("Washed Out");
			styleFiles.add("wash.css");

			styleNames.add("Sandy Creek");
			styleFiles.add("sandy.css");
		}
	}

	Cookie[] cookies = request.getCookies();
	if ((prefBibles == null) && (cookies != null)) {

		for (int i = 0; i < cookies.length; i++) {
			int start, end;
			String field;
			String line;
			if (cookies[i].getName().equals("PrefStyle")) {
				prefStyle = cookies[i].getValue();
			}
			else if (cookies[i].getName().equals("PrefBibles")) {
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
			else if (cookies[i].getName().equals("ParDispModules")) {
				parDispModules = new Vector();
				start = 0;
				end = 1;
				line = cookies[i].getValue();
				while (end > 0) {
					end = line.indexOf("+",start);
					field = (end > 0) ? line.substring(start, end) : line.substring(start);
					if (start > 3)  		// skip the first one cuz it's not a real module
						parDispModules.add(field);
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

	if ((prefStyle == null) || (styleNames.indexOf(prefStyle) < 0))
		prefStyle = (String)styleNames.get(0);

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
