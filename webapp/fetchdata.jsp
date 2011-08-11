<%@ page
    language="java"
    contentType="text/html;charset=utf-8"
%>
<%@ page import="org.crosswire.sword.orb.*" %>
<%@ page import="org.crosswire.utils.HTTPUtils" %>
<%@ page import="org.crosswire.xml.XMLBlock" %>
<%@ page import="java.net.URLEncoder" %>
<%

	SWMgr mgr = SwordOrb.getSWMgrInstance(request);
	SWModule book = null;
	String ks = request.getParameter("key");
	String modName = request.getParameter("mod");
	String fn = request.getParameter("fn");
	String format = request.getParameter("format");
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

			// ------ betacode lookup from perseus ------------------------------------------------
			if ("betacode".equals(modName)) {
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

			// ------ Textual Evidence Lookup from INTF ---------------------------------------------

			else if ("TC".equals(modName)) {
				String srcMod = request.getParameter("srcMod");
				String activeKey = (String)session.getAttribute("ActiveKey");
				if (srcMod != null) {
					book = mgr.getModuleByName(srcMod);
				}
				if ((key != null) && (book != null) && activeKey != null) {
					try {
						Integer.parseInt(key);	// assert we have only an int and need to get our book and chapter from session
						String activeChapter = activeKey.substring(0, activeKey.indexOf(":"));
						activeKey = activeChapter+"."+key;
					}
					catch (Exception e) { activeKey = key; } // not an error, just hopefully have entire versekey already
					String vk[] = book.parseKeyList(activeKey);
					activeKey=vk[0];
					StringBuffer vmrResponse = HTTPUtils.postURL("http://vmr-dev.uni-muenster.de/community/vmr/api/metadata/liste/search/", "biblicalcontent="+activeKey+"&detail=page&limit=20");
					XMLBlock manuscripts = new XMLBlock(vmrResponse.toString());
%>
					<p><b>Some Manuscript Witnesses for <%=vk[0]%></b></p>
					<div id="tableContainer" class="tableContainer">
					<table border="0" cellpadding="0" cellspacing="0" width="100%" class="scrollTable">
					<thead class="fixedHeader">
						<tr><th>Manuscript</th><th>Century</th><th>Folio</th><th>Content</th><th>Image</th></tr>
					</thead>
					<tbody class="scrollContent">
<%
					int formCount = 0;
					for (XMLBlock m : manuscripts.getBlocks("manuscript")) {
						for (XMLBlock p : m.getBlock("pages").getBlocks("page")) {
							++formCount;
							String thumbURL = null;
							String imageURL = null;
							String transURL = null;
							XMLBlock block = p.getBlock("images");
							if (block != null) {
								block = block.getBlock("image");
								if (block != null) {
									thumbURL = block.getAttribute("thumburi");
									imageURL = block.getAttribute("uri");
								}
							}
							block = p.getBlock("transcriptions");
							if (block != null) {
								block = block.getBlock("transcription");
								if (block != null) {
									transURL = block.getAttribute("uri");
								}
							}
							String mssURL = "http://intf.uni-muenster.de/vmr/NTVMR/ListeHandschriften.php?ObjID=" + m.getAttribute("docid");
%>
							<tr>
								<td><a href="#" onclick="window.open('<%=mssURL%>','ViewManuscript','width=800,height=600,resizable=1,scrollbars=1');return false;">
									<%=m.getAttribute("ganum")%>
								</a></td>
								<td><%=m.getValue("originyeardescription")%></td>
								<td><%=p.getAttribute("folio")%></td>
								<td>
<%
							if (transURL != null) {
%>
									<a href="#" onclick="window.open('<%=transURL%>','ViewTranscription','width=500,height=600,resizable=1,scrollbars=1');return false;">
<%
							}
%>
										<%=p.getAttribute("biblicalcontent")%>
<%
							if (transURL != null) {
%>
									</a>
<%
							}
%>
								<td>
<%
							if (imageURL != null) {
								String siteURL = imageURL.substring(0,imageURL.lastIndexOf("/")+1);
								String pageImage = imageURL.substring(imageURL.lastIndexOf("/")+1);
								imageURL = "http://community.crosswire.org/modules/papyri/?site="+siteURL+"&image="+pageImage;
%>
<!--
									<a href="#" onclick="window.open('<%=imageURL%>','ViewImage','width=800,height=600');return false;">
-->
									<form name="form<%=formCount%>" target="_blank" action="http://intf.uni-muenster.de/vmr/NTVMR/viewer/viewerWolkenkratzer01.php" method="post">
										<input name="msNr" value="<%=m.getAttribute("docid")%>" type="hidden"/>
										<input name="folio" value="<%=m.getAttribute("folio")%>" type="hidden"/>
										<input name="load_ms" value="go" type="hidden"/>
										<input name="load_folio" value="go" type="hidden"/>
										<a href="#" onclick="javascript:document.form<%=formCount%>.submit();">
<%
							}
							if (thumbURL != null) {
%>
										<img width="50px" src="<%=thumbURL%>"/>
<%
							}
							if (imageURL != null) {
%>
										</a>
									</form>
<!--
									</a>
-->
<%
							}
%>
								</td></tr>
<%
						}
					}
%>
						</tbody>
						</table>
						</div>
						<div class="copyLine"><br/>This dataset is by no means exhaustive and is growing rapidly. Check back soon for more results.<br/><br/>Courtesy of <a href="http://egora.uni-muenster.de/intf/index_en.shtml">Institut für Neutestamentliche Textforschung</a></div>
<%
				}
			}

			// normal SWORD mod lookup
			else {
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
						if ("raw".equals(format)) {
%>
							<%= book.getRawEntry() %>
<%
						}
						else {
%>
							<%= book.getRenderText() %>
<%
						}
					}
				}
			}
		}
	}
%>
