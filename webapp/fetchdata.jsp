<%@ page
    language="java"
    contentType="text/html;charset=utf-8"
%>
<%@ page import="org.crosswire.sword.orb.*" %>
<%@ page import="java.net.URLEncoder" %>
<%

	SWMgr mgr = SwordOrb.getSWMgrInstance(request);
	SWModule book = null;
	String ks = request.getParameter("key");
	String modName = request.getParameter("mod");
	String fn = request.getParameter("fn");
	mgr.setGlobalOption("Footnotes", "Off");
	mgr.setGlobalOption("Cross-references", "Off");


	if (ks != null) {
		String k[] = ks.split("\\|");
		for (int i = 0; i < k.length; i++) {
			String key = k[i];
			if (i > 0) out.print("<br/>__________________<br/><br/>");
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
					if (("StrongsGreek".equals(modName)) && ("3588".equals(key))) {
						out.print("with Greek Article");
					}
					else if (fn != null) {
						try {
							String[] type = book.getEntryAttribute("Footnote", fn, "type", false);
							if ((type.length > 0) && type[0].equalsIgnoreCase("crossReference")) {
								String[] attr = book.getEntryAttribute("Footnote", fn, "refList", false);
								if (attr.length > 0) {
									String[] keys = book.parseKeyList(attr[0]);
									if (keys.length > 0) {
										out.print("<dl>");
										for (int j = 0; j < keys.length; j++) {
											book.setKeyText(keys[j]);
											out.print("<dt><a href=\"passagestudy.jsp?key=" + URLEncoder.encode(book.getKeyText())+"#cv\">" + book.getKeyText() + "</a></dt><dd>" + book.getRenderText()+"</dd>\n");
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
					<%= book.getRenderText() %>
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
		}
	}
%>
