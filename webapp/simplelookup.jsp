<%@ page
    language="java"
    contentType="text/html;charset=utf-8"
%>
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

	String activeModuleName = request.getParameter("mod");
	if (activeModuleName == null) activeModuleName = "WHNU";
	SWModule activeModule = mgr.getModuleByName(activeModuleName);

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

	activeModule.setKeyText(activeKey);
	activeKey = activeModule.getKeyText(); 	// be sure it is formatted nicely
%>
<%= activeKey %>%%%
		<div>

		<%
			if ((activeModule.getCategory().equals("Cults / Unorthodox / Questionable Material")) || (activeModule.getCategory().equals(SwordOrb.BIBLES))) {
				String chapterPrefix = activeKey.substring(0, activeKey.indexOf(":"));
				int activeVerse = Integer.parseInt(activeKey.substring(activeKey.indexOf(":")+1));
				int anchorVerse = (activeVerse > 2)?activeVerse - 2: -1;
				boolean first = true;
				String lang = activeModule.getConfigEntry("Lang");
				boolean rtol = ("RtoL".equalsIgnoreCase(activeModule.getConfigEntry("Direction")));
				
				for (activeModule.setKeyText("="+chapterPrefix + ":0"); (activeModule.error() == (char)0); activeModule.next()) {
					String keyText = activeModule.getKeyText();
					String keyProps[] = activeModule.getKeyChildren();
					// book and chapter intros
					// TODO: change 'chapterPrefix' to use keyProps so we can support book intros (e.g. Jn.0.0)
					boolean intro = (keyProps[2].equals("0") || keyProps[3].equals("0"));
					if (first) {
			%>
				<table class="<%= lang %>">
			<%
						first = false;
					}
					int curVerse = Integer.parseInt(keyText.substring(keyText.indexOf(":")+1));
					if (!chapterPrefix.equals(keyText.substring(0, keyText.indexOf(":")))) {
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
					<tr><td colspan="2"><div <%= rtol ? "dir=\"rtl\"" : "" %> class="<%= (keyText.equals(activeKey)) ? "currentverse" : "verse" %>">
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
					<td valign="top" align="right"><div <%= rtol ? "dir=\"rtl\"" : "" %> class="<%= (keyText.equals(activeKey)) ? "currentverse" : "verse" %>">
			<%
					if (!intro) {
			%>
					<span class="versenum">
					<a target="_blank" <%= (curVerse == anchorVerse)?"id=\"cv\"":"" %> href="<%= baseURL %>/passagestudy.jsp?key=<%= URLEncoder.encode(keyText)+"#cv" %>">
						<%= keyText.substring(keyText.indexOf(":")+1) %></a>
					</span>
			<%
					}
			%>
					</div></td>
			<%
					}
			%>

					<td><div <%= rtol ? "dir=\"rtl\"" : "" %> class="<%= (keyText.equals(activeKey)) ? "currentverse" : (intro) ? "intro" : "verse" %>">

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
					<span class="versenum"><a <%= (curVerse == anchorVerse)?"id=\"cv\"":"" %> href="passagestudy.jsp?key=<%= URLEncoder.encode(keyText)+"#cv" %>">
						<%= keyText.substring(keyText.indexOf(":")+1) %></a>
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
				<span class="versenum"><%= activeKey %></span>
					<%= activeModule.getRenderText() %>
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
