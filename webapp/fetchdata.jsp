<%@ page
    language="java"
    contentType="text/html;charset=utf-8"
%>
<%@ page import="org.crosswire.sword.orb.*" %>
<%@ page import="java.net.URLEncoder" %>
<%

	SWMgr mgr = SwordOrb.getSWMgrInstance(request);
	SWModule book = null;
	String key = request.getParameter("key");
	String modName = request.getParameter("mod");
	String fn = request.getParameter("fn");
	mgr.setGlobalOption("Footnotes", "Off");
	mgr.setGlobalOption("Cross-references", "Off");

	// hack until LXXM morph is cleaned up -----
	if ("Packard".equals(modName)) {
		while (key.indexOf("  ") > -1) key = key.replaceAll("  ", " ");
	}
	// end of LXXM Packard hack ----------------

	// normal SWORD mod lookup
	if (!"betacode".equals(modName)) {
		if (modName != null) {
			book = mgr.getModuleByName(modName);
		}
		if ((key != null) && (book != null)) {
			book.setKeyText(key);
			if (fn != null) {
				try {
					String[] type = book.getEntryAttribute("Footnote", fn, "type", false);
					if ((type.length > 0) && type[0].equalsIgnoreCase("crossReference")) {
						String[] attr = book.getEntryAttribute("Footnote", fn, "refList", false);
						if (attr.length > 0) {
							String[] keys = book.parseKeyList(attr[0]);
							if (keys.length > 0) {
								out.print("<dl>");
								for (int i = 0; i < keys.length; i++) {
									book.setKeyText(keys[i]);
									out.print("<dt><a href=\"passagestudy.jsp?key=" + URLEncoder.encode(new String(book.getKeyText().getBytes("iso8859-1"), "UTF-8"))+"#cv\">" + new String(book.getKeyText().getBytes("iso8859-1"), "UTF-8") + "</a></dt><dd>" + new String(book.getRenderText().getBytes("iso8859-1"), "UTF-8")+"</dd>\n");
								}
								out.print("</dl>");
							}
						}
					}
					else {
						String[] attr = book.getEntryAttribute("Footnote", fn, "body", true);
						if (attr.length > 0) {
							out.print(attr[0]);
						}
					}
				}
				catch (Exception e) { e.printStackTrace(); }
			}
			else {
%>
			<%= new String(book.getRenderText().getBytes("iso8859-1"), "UTF-8") %>
<%
			}
		}
	}
	// betacode lookup from perseus
	else {
		key = new String(key.getBytes("iso8859-1"), "UTF-8");
		String ls = org.crosswire.swordweb.PerseusUtils.getLiddellScottDef(key);
		if (ls.length() > 0) {
%>
		<%= ls %>
<div class="copyLine">from Liddell and Scott, <i>An Intermediate Greek-English Lexicon</i><br/>
Courtesy of <a href="http://www.perseus.tufts.edu">Perseus Digital Library</a></div>
<%
		}
		else {
%>
		<h2><span class="verse"><%= key %></span></h2>
<%
		}
	}
%>
