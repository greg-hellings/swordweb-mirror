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
		String parts[] = ks.split("\\|");
		for (int i = 0; i < parts.length; i++) {
			String key = parts[i];
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
					StringBuffer vmrResponse = HTTPUtils.postURL("http://ntvmr.uni-muenster.de/community/vmr/api/metadata/liste/search/", "biblicalContent="+activeKey+"&detail=page&limit=40");
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
					for (XMLBlock m : manuscripts.getBlocks("manuscript")) {
						for (XMLBlock p : m.getBlock("pages").getBlocks("page")) {
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
							String mssURL = "http://ntvmr.uni-muenster.de/manuscript-workspace?docid=" + m.getAttribute("docid")+"&pageid="+p.getAttribute("pageid");
%>
							<tr>
								<td><a href="<%=mssURL%>" target="NTVMR">
									<%=m.getAttribute("ganum")%>
								</a></td>
								<td><%=m.getValue("originYear")%></td>
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
								</td><td>
<%
							if (imageURL != null) {
%>
									<a href="<%=mssURL%>" target="NTVMR">
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
					String keyList[] = SwordOrb.BIBLES.equals(book.getCategory())?book.parseKeyList(key) : new String[] { key };
					boolean startBookTag = false;
					boolean startChapterTag = false;
					
					if ("tei".equals(format) && keyList.length > 0) {
						book.setKeyText(keyList[0]);
%>
<TEI>
<div type="book" n="B<%= String.format("%02d", Integer.parseInt(book.getKeyChildren()[1])) %>" part="<%= ("1".equals(book.getKeyChildren()[2]))&&("1".equals(book.getKeyChildren()[3]))?"I":"Y"%>">
<div type="chapter" n="B<%= String.format("%02d", Integer.parseInt(book.getKeyChildren()[1])) %>K<%= book.getKeyChildren()[2] %>" part="<%= ("1".equals(book.getKeyChildren()[3]))?"I":"Y"%>" >
<%
					}
					for (int k = 0; k < keyList.length; ++k) {
						String k1 = keyList[k];
						book.setKeyText(k1);
						if (("StrongsGreek".equals(modName)) && ("3588".equals(k1))) {
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
							if ("raw".equals(format) || "tei".equals(format)) {

								// ----- header for trier tinymce editor ------
								if ("tei".equals(format)) {
									if (k > 0 && "1".equals(book.getKeyChildren()[3])) {
										if ("1".equals(book.getKeyChildren()[2])) {
%>
<div type="book" n="B<%= String.format("%02d", Integer.parseInt(book.getKeyChildren()[1])) %>">
<%
											startBookTag = true;
										}
%>
<div type="chapter" n="B<%= String.format("%02d", Integer.parseInt(book.getKeyChildren()[1])) %>K<%= book.getKeyChildren()[2] %>">
<%
											startChapterTag = true;
									}
%>
<ab n="B<%= String.format("%02d", Integer.parseInt(book.getKeyChildren()[1])) %>K<%= book.getKeyChildren()[2] %>V<%= book.getKeyChildren()[3] %>">
<%
								}
								// --------------------------------------------
%>
<%= book.getRawEntry() %>
<%
								// ----- header for trier tinymce editor ------
								if ("tei".equals(format)) {
%>
</ab>
<%
									// if last verse of chapter
									if (k < keyList.length-1 && book.getKeyChildren()[5].equals(book.getKeyChildren()[3])) {
%>
</div>
<%
										startChapterTag = false;
										// if last chapter of book
										if (k < keyList.length-1 && book.getKeyChildren()[4].equals(book.getKeyChildren()[2]) && startBookTag) {
%>
</div>
<%
											startBookTag = false;
										}
									}
								}
								// --------------------------------------------
							}
							else {


								// ----- header for trier tinymce editor ------
								if ("basetext".equals(format)) {
%>
<span class="chapter_number" part="<%=("1".equals(book.getKeyChildren()[3]))?"I":"Y"%>"> <%= book.getKeyChildren()[2]%></span>
<%
%>
<span class="verse_number"> <%= book.getKeyChildren()[3]%></span>
<%
								}
								// --------------------------------------------
%>
<%= book.getRenderText() %>
<%
							}
						}
					}
					if ("tei".equals(format)) {
%>
</div>
</div>
</TEI>
<%
					}
				}
			}
		}
	}
%>
