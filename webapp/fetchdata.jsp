<%@ page
    language="java"
    contentType="text/html;charset=utf-8"
%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ page import="org.crosswire.sword.orb.*" %>
<%@ page import="org.crosswire.utils.HTTPUtils" %>
<%@ page import="org.crosswire.xml.XMLBlock" %>
<%@ page import="java.net.URLEncoder" %>
<%

	final int VERSEKEY_TESTAMENT  = 0;
	final int VERSEKEY_BOOK       = 1;
	final int VERSEKEY_CHAPTER    = 2;
	final int VERSEKEY_VERSE      = 3;
	final int VERSEKEY_CHAPTERMAX = 4;
	final int VERSEKEY_VERSEMAX   = 5;
	final int VERSEKEY_BOOKNAME   = 6;
	final int VERSEKEY_OSISREF    = 7;

	SWMgr mgr = SwordOrb.getSWMgrInstance(request);
	SWModule book = null;
	String ks = request.getParameter("key");
	if (ks != null) ks = new String(ks.getBytes("iso8859-1"), "UTF-8");
	String modName = request.getParameter("mod");
	String fn = request.getParameter("fn");
	String format = request.getParameter("format");
	mgr.setGlobalOption("Footnotes", "Off");
	mgr.setGlobalOption("Cross-references", "Off");

	String inTestament = null;
	String inBook = null;
	String inChapter = null;
	String inVerse = null;

	if ("plain".equals(format)) {
		mgr.setGlobalOption("Strong's Numbers", "Off");
		mgr.setGlobalOption("Morphological Tags", "Off");
	}
	if ("tei".equals(format) && "LXXCATSS".equals(modName)) {
		mgr.setGlobalOption("Greek Accents", "Off");
	}

	String mods[] = new String[0];
	if (modName != null) {
		mods = modName.split("\\|");
	}

	if (ks != null) {
		String parts[] = ks.split("\\|");
		for (int i = 0; i < parts.length; i++) {

			if (i < mods.length) modName = mods[i];

			String key = parts[i];

			if ("betacode".equals(modName)) {
				key = new String(key.getBytes("iso8859-1"), "UTF-8");
			}

			if (i > 0) out.print("<br/>__________________<br/><br/>");
			// hack until LXXM morph is cleaned up -----
			if ("Packard".equals(modName)) {
				while (key.indexOf("  ") > -1) key = key.replaceAll("  ", " ");
			}
			// end of LXXM Packard hack ----------------
			if ("ls".equals(modName)) {
				SWModule greekLemma = mgr.getModuleByName("GreekStrongToLem");
				greekLemma.setKeyText(ks);
				key = greekLemma.getRawEntry();
				modName = "betacode";
			}

			// ------ betacode lookup from perseus ------------------------------------------------
			if ("betacode".equals(modName)) {
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
//System.out.println("book:" + book+ ";key="+key+"activeKey:"+activeKey);
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
//System.out.println("**** response: " + vmrResponse);
					XMLBlock manuscripts = new XMLBlock(vmrResponse.toString());
%>
					<p><b>Some Manuscript Witnesses for <%=vk[0]%></b></p>
					<div id="tableContainer" class="tableContainer" style="width:100%;">
					<table border="0" cellpadding="0" cellspacing="0" style="width:100%;" class="scrollTable">
					<thead class="fixedHeader">
						<tr style="font-size:80%;"><th>Ms</th><th>Century</th><th>Folio</th><th>Content</th><th>&nbsp;</th></tr>
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
									thumbURL = block.getAttribute("thumbURL");
									imageURL = block.getAttribute("webFriendlyURL");
								}
							}
							block = p.getBlock("transcriptions");
							if (block != null) {
								block = block.getBlock("transcription");
								if (block != null) {
									transURL = block.getAttribute("uri");
								}
							}
							String mssURL = "http://ntvmr.uni-muenster.de/manuscript-workspace?docID=" + m.getAttribute("docID")+"&pageID="+p.getAttribute("pageID");
%>
							<tr>
								<td><a href="<%=mssURL%>" target="NTVMR">
									<%=m.getAttribute("gaNum")%>
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
										<%=p.getAttribute("biblicalContent")%>
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
					
					if ("tei".equals(format) && keyList.length > 0) {
						book.setKeyText(keyList[0]);
						response.setContentType("text/xml");
%>
<TEI>
<%
					}
					for (int k = 0; k < keyList.length; ++k) {
						String k1 = keyList[k];
						// kludge for verse 0 which comes out to e.g., "Rev.2"
						if (k1.split("\\.").length == 2) {
							k1 = "=" + k1 + ".0";
							continue;	// just skip chapter headings
						}
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
/*
%>
<milestone k="<%=k%>" key="<%=k1%>" keyText="<%=book.getKeyText()%>"/>
<%
*/

								// ----- header for trier tinymce editor ------
								if ("tei".equals(format)) {
									if (inChapter != null && (!book.getKeyChildren()[VERSEKEY_CHAPTER].equals(inChapter) || !book.getKeyChildren()[VERSEKEY_BOOK].equals(inBook))) {
%>
</div>
<%
									}
									if (inBook != null && !book.getKeyChildren()[VERSEKEY_BOOK].equals(inBook)) {
%>
</div>
<%
									}
									if (!book.getKeyChildren()[VERSEKEY_BOOK].equals(inBook)) {
%>
<div type="book" n="B<%= String.format("%02d", Integer.parseInt(book.getKeyChildren()[VERSEKEY_BOOK])) %>">
<%
									}
									if (!book.getKeyChildren()[VERSEKEY_CHAPTER].equals(inChapter) || !book.getKeyChildren()[VERSEKEY_BOOK].equals(inBook)) {
%>
<div type="chapter" n="B<%= String.format("%02d", Integer.parseInt(book.getKeyChildren()[VERSEKEY_BOOK])) %>K<%= book.getKeyChildren()[VERSEKEY_CHAPTER] %>">
<%
									}
									inChapter = book.getKeyChildren()[VERSEKEY_CHAPTER];
									inBook = book.getKeyChildren()[VERSEKEY_BOOK];
%>
<ab n="B<%= String.format("%02d", Integer.parseInt(book.getKeyChildren()[VERSEKEY_BOOK])) %>K<%= book.getKeyChildren()[VERSEKEY_CHAPTER] %>V<%= book.getKeyChildren()[VERSEKEY_VERSE] %>">
<%
								}
								// --------------------------------------------
									if ("WLC".equals(modName) || "LXX".equals(modName) || "Vulgate".equals(modName)) {
%>
<%= book.getStripText() %>
<%
									}
									else if ("LXXCATSS".equals(modName) || "Aleppo".equals(modName)) {
										String raw = book.getStripText();
										raw = mgr.filterText("OSISPlain", raw);
//										raw = mgr.filterText("UTF8GreekAccents", raw);
										while (raw.indexOf("\n") > -1) raw = raw.replaceAll("\n", " ");
										while (raw.indexOf("\r") > -1) raw = raw.replaceAll("\r", " ");
										while (raw.indexOf("  ") > -1) raw = raw.replaceAll("  ", " ");
										out.print(raw);
									}
									else {
%>
<%= book.getRawEntry() %>
<%
									}
								// ----- header for trier tinymce editor ------
								if ("tei".equals(format)) {
%>
</ab>
<%
								}
								// --------------------------------------------
							}
							else {


								// ----- header for trier tinymce editor ------
								if ("basetext".equals(format)) {
%>
<span class="chapter_number" part="<%=("1".equals(book.getKeyChildren()[VERSEKEY_VERSE]))?"I":"Y"%>"> <%= book.getKeyChildren()[VERSEKEY_CHAPTER]%></span>
<%
%>
<span class="verse_number"> <%= book.getKeyChildren()[VERSEKEY_VERSE]%></span>
<%
								}
								if ("strip".equals(format)) {
%>
<%= book.getStripText() %>
<%
								}
								else if ("plain".equals(format)) {
									String raw = book.getRawEntry();
// assume our modules are OSIS for now (should change output format of mgr or have a second mgr for this one.
									raw = mgr.filterText("OSISPlain", raw);
%>
<%= raw %>
<%
								}
								else {
								// --------------------------------------------
%>
<%= book.getRenderText() %>
<%
								}
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
	else {
		response.setContentType("text/xml");
%>
<?xml version="1.0" encoding="utf-8"?>
<modules>
<%
		ModInfo[] modInfo = mgr.getModInfoList();
		for (int i = 0; i < modInfo.length; i++) {
			SWModule b = mgr.getModuleByName(modInfo[i].name);
%>
	<module id="<%=modInfo[i].name %>" category="<%= modInfo[i].category %>"><%= HTTPUtils.canonize(b.getDescription()) %></module>

<%
		}
%>
</modules>
<%
	}
%>
