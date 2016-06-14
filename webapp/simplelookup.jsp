<%@ page
    language="java"
    contentType="text/html;charset=utf-8"
%>
<%@ page import="org.crosswire.xml.*" %>
<%@ page import="org.crosswire.sword.orb.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.net.URL" %>
<%

	String requestURI = request.getRequestURI();
	int pe = requestURI.lastIndexOf('/', requestURI.length()-2);
	requestURI = (pe > 0) ? requestURI.substring(0, pe) : "";
	URL baseURL = new URL(request.getScheme(), request.getServerName(), request.getServerPort(), requestURI);
	URL appBaseURL = new URL(request.getScheme(), request.getServerName(), request.getServerPort(), "/study/");

	SWMgr mgr = SwordOrb.getSWMgrInstance(request);
	mgr.setJavascript(true);

	String activeModuleName = request.getParameter("mod");
	if (activeModuleName == null) activeModuleName = "WHNU";
	SWModule activeModule = mgr.getModuleByName(activeModuleName);
	SWModule eusVs = mgr.getModuleByName("Eusebian_vs");
	SWModule eusNum = mgr.getModuleByName("Eusebian_num");

	String promoLine = activeModule.getConfigEntry("ShortPromo");
	if (promoLine.equalsIgnoreCase("<swnull>")) {
		promoLine = "";
	}

	String activeKey = request.getParameter("key");
	if (activeKey == null) {
		activeKey = "jas 1:19";
	}

	String buf = request.getParameter("strongs");
	boolean strongs = "on".equalsIgnoreCase(buf);

	buf = request.getParameter("morph");
	boolean morph =  "on".equalsIgnoreCase(buf);

	activeModule.setKeyText("="+activeKey);
	activeKey = activeModule.getKeyText(); 	// be sure it is formatted nicely
	String book = activeModule.getKeyChildren()[6];
	int chapter = Integer.parseInt(activeModule.getKeyChildren()[2]);
	int verse = Integer.parseInt(activeModule.getKeyChildren()[3]);
	String specialFont = activeModule.getConfigEntry("Font");
	if (specialFont.equalsIgnoreCase("<swnull>")) {
		specialFont = null;
	}
	String lang = activeModule.getConfigEntry("Lang");
	boolean rtol = ("RtoL".equalsIgnoreCase(activeModule.getConfigEntry("Direction")));
%>
<%= activeKey %>%%%
		<div>

		<%
			if ((activeModule.getCategory().equals("Cults / Unorthodox / Questionable Material")) || (activeModule.getCategory().equals(SwordOrb.BIBLES))) {
				int activeVerse = Integer.parseInt(activeKey.substring(activeKey.indexOf(":")+1));
				int anchorVerse = (activeVerse > 2)?activeVerse - 2: -1;
				boolean first = true;

				
				String lastEusNum = "";
				String myEusNum = "";
				for (activeModule.setKeyText("="+book+"."+chapter+"."+"0"); (activeModule.error() == (char)0); activeModule.next()) {
					if (chapter == 0) chapter = 1;
					String keyText = activeModule.getKeyText();
					String keyProps[] = activeModule.getKeyChildren();
					// book and chapter intros
					boolean intro = (keyProps[2].equals("0") || keyProps[3].equals("0"));
					if (eusVs != null) {
						myEusNum = "";
						if (!intro) {
							eusVs.setKeyText(keyText);
							myEusNum = eusVs.getStripText().trim();
							if (!lastEusNum.equals(myEusNum)) {
								lastEusNum = myEusNum;
								eusNum.setKeyText(myEusNum);
								XMLTag d = new XMLBlock(eusNum.getRawEntry());
								myEusNum = myEusNum.substring(myEusNum.indexOf(".")+1) + "<br/>" + d.getAttribute("table");
							}
							else myEusNum = "";
						}
					}
					if (first) {
			%>
				<table class="<%= lang %>">
			<%
						first = false;
					}
					int curVerse = Integer.parseInt(keyProps[3]);
					int curChapter = Integer.parseInt(keyProps[2]);
					if (!book.equals(keyProps[6]) || curChapter > chapter) {
						break;
					}
					mgr.setGlobalOption("Strong's Numbers",
							((strongs) && (curVerse >= activeVerse -1) && (curVerse <= activeVerse + 1)) ? "on" : "off");
					mgr.setGlobalOption("Morphological Tags",
							((morph) && (curVerse >= activeVerse -1) && (curVerse <= activeVerse + 1)) ? "on" : "off");
					
			%>
			<%
					String[] heads = activeModule.getEntryAttribute("Heading", "Preverse", "", true);
					for (int h = 0; h < heads.length; ++h) {
			%>
					<tr><td colspan="3"><div <%= rtol ? "dir=\"rtl\"" : "" %> class="<%= (keyText.equals(activeKey)) ? "currentverse" : "verse" %>">
				<h3>
					<%= heads[h] %>
				 </h3></div></td></tr>
			<%
					}
			%>
					<tr>

			<%
					if (!rtol) {
			%>
					<td style="padding:0;margin:0" valign="top" align="center"><div <%= rtol ? "dir=\"rtl\"" : "" %>>
<%
					if (myEusNum.length() > 0) {
%>
					<span class="eusnum">
					<a target="_blank" href="<%= baseURL %>/eusebian.jsp?mod=<%=activeModuleName%>&key=<%= URLEncoder.encode(keyText)+"#cv" %>"><%= myEusNum %></a>
					</span>
<%
					}
%>
					</div></td>
					<td valign="top" align="right"><div <%= rtol ? "dir=\"rtl\"" : "" %> class="<%= (keyText.equals(activeKey)) ? "currentverse" : "verse" %>">
			<%
					if (!intro) {
			%>
					<span class="versenum">
					<a target="_blank" <%= (curVerse == anchorVerse)?"id=\"cv\"":"" %> href="#" onclick="lookup('<%= keyText%>');return false;">
						<%= keyProps[3] %></a>
					</span>
			<%
					}
			%>
					</div></td>
			<%
					}
			%>

					<td><div <%= rtol ? "dir=\"rtl\"" : "" %> style="<%= specialFont != null ? "font-family:"+specialFont : "" %>" class="<%= (keyText.equals(activeKey)) ? "currentverse" : (intro) ? "intro" : "verse" %>">

					<%
					
//					<div xml:lang="<%= (lang.equals("")) ? "en" : lang 
					%>
					<%= activeModule.getRenderText() %>
<%
//					</div>
%>
					</div></td>
			<%
					if (rtol) {
			%>
					<td valign="top" align="right"><div <%= rtol ? "dir=\"rtl\"" : "" %> class="<%= (keyText.equals(activeKey)) ? "currentverse" : "verse" %>">
			<%
					if (!intro) {
			%>
					<span class="versenum">
						<a target="_blank" <%= (curVerse == anchorVerse)?"id=\"cv\"":"" %> href="#" onclick="lookup('<%= keyText%>');return false;">
						<%= keyProps[3] %></a>
					</span>
			<%
					}
			%>
					</div></td>
					<td style="padding:0;margin:0" valign="top" align="center"><div <%= rtol ? "dir=\"rtl\"" : "" %>>
<%
					if (myEusNum.length() > 0) {
%>
					<span class="eusnum">
					<a target="_blank" href="<%= baseURL %>/eusebian.jsp?mod=<%=activeModuleName%>&key=<%= URLEncoder.encode(keyText)+"#cv" %>"><%= myEusNum %></a>
					</span>
<%
					}
%>
					</div></td>
			<%
					}
			%>


					</tr>
		<%
				}
				if (!first) {
			%>
				</table>
			<%
				}
			}
			else {
			%>
				<div class="verse">
				<div <%= rtol ? "dir=\"rtl\"" : "" %> style="<%= specialFont != null ? "font-family:"+specialFont : "" %>" class="verse">
				<span class="versenum"><%= activeKey %></span>
					<%= activeModule.getRenderText() %>
				</div>
				</div>
			<%
			}
			String copyLine = activeModule.getConfigEntry("ShortCopyright");
			if (copyLine.equalsIgnoreCase("<swnull>")) {
				copyLine = "";
			}
			if (activeModule.getCategory().equals("Cults / Unorthodox / Questionable Material")) {
				copyLine = "<t:t>WARNING: This text is considered unorthodox by most of Christendom.</t:t> " + copyLine;
			}
		%>
		<div class="copyLine"><%= copyLine %></div>
		<div class="promoLine"><%= promoLine %></div>
		</div>
</div>
