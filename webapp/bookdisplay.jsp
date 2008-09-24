<%@ include file="init.jsp" %>

<%@ page import="java.util.Enumeration,java.util.Vector" %>
<%@ page import="gnu.regexp.RE" %>

<%
	Vector bookTreeOpen = (Vector)session.getAttribute("bookTreeOpen");
	String currentJumpNode = null;
	boolean forceOpen = false;

	boolean strongs = "on".equals((String) session.getAttribute("strongs"));
	String buf = request.getParameter("strongs");
	strongs = (buf != null) ? "on".equalsIgnoreCase(buf) : strongs;
	session.setAttribute("strongs", (strongs)?"on":"off");

	boolean morph = "on".equals((String) session.getAttribute("morph"));
	buf = request.getParameter("morph");
	morph = (buf != null) ? "on".equalsIgnoreCase(buf) : morph;
	session.setAttribute("morph", (morph)?"on":"off");

	String showStrong = request.getParameter("showStrong");
	String showMorph = request.getParameter("showMorph");


	session.setAttribute("lastModType", "GBS");
	String gbsBook = (String)request.getParameter("mod");
	if (gbsBook != null) {
		session.setAttribute("gbsBook", gbsBook);
		session.setAttribute("gbsEntry", null);
	}
	gbsBook = (String)session.getAttribute("gbsBook");
	SWModule module = (gbsBook == null) ? null : mgr.getModuleByName(gbsBook);

	String gbsEntry = (String)request.getParameter("gbsEntry");
	if (gbsEntry != null) {
		session.setAttribute("gbsEntry", gbsEntry);
		bookTreeOpen = null;
		forceOpen = true;
	}
	gbsEntry = (String)session.getAttribute("gbsEntry");
	if (gbsEntry == null)
		gbsEntry = "/";

	String action = (String)request.getParameter("action");
	if ((action != null) && (action.equalsIgnoreCase("closeAll"))) {
		bookTreeOpen = null;
	}

	if (bookTreeOpen == null) {
		bookTreeOpen = new Vector();
		session.setAttribute("bookTreeOpen", bookTreeOpen);
	}

	// open our current entry in tree
	if ((module != null) && (forceOpen)) {
		module.setKeyText(gbsEntry);
		String tmp = module.getKeyText();
		while (tmp.length() > 0) {
			bookTreeOpen.add(tmp);
			tmp = module.getKeyParent();
		}
	}


	for (int i = 0; i < 2; i++) {
		String []nodes = request.getParameterValues((i>0)?"close":"open");
		if (nodes != null) {
			for (int j = 0; j < nodes.length; j++) {
				String node = new String(nodes[j].getBytes("iso8859-1"), "UTF-8");
				if (node != null) {
					if (i>0) {
						bookTreeOpen.remove(node);
					}
					else {
						if (!bookTreeOpen.contains(node)) {
							bookTreeOpen.add(node);
						}
					}
				}
			}
			if (nodes.length > 0)
				currentJumpNode = nodes[0];
		}
	}

%>
<tiles:insert beanName="basic" flush="true" >
	<%-- override lookup URL, so this script is used to display the keys --%>
	<tiles:put name="lookup_url" value="bookdisplay.jsp" />
	<tiles:put name="title"><%=module.getDescription()%></tiles:put>
	<tiles:put name="pintro" type="string" ><div></div></tiles:put>
	<tiles:put name="sidebar_right" type="string" ><div></div></tiles:put>
	<tiles:put name="sidebar_left" type="string">


	<div id="genbooknav">
<%
		if (module != null) {
%>
		<ul>
<%
			printTree(bookTreeOpen, out, module, "/", gbsEntry, currentJumpNode);
%>
		</ul>
<%
		}
		else {
%>
<b><t:t>no book selected</t:t></b>
<%
		}
	%>
	</div>
	</tiles:put>

	<tiles:put name="content" type="string">
	<%
		if (module != null) {
	%>
			<div id="genbook">
				<h2><%= new String(gbsEntry.getBytes("iso8859-1"), "UTF-8") %></h2>
				<h3><a href="fulllibrary.jsp?show=<%= URLEncoder.encode(module.getName()) %>"><%= module.getDescription().replaceAll("&", "&amp;") + " (" + module.getName() + ")" %></a></h3>
	<%
			module.setKeyText(gbsEntry);
			gbsEntry = module.getKeyText();
			boolean printed = false;
			boolean rtol = ("RtoL".equalsIgnoreCase(module.getConfigEntry("Direction")));
			if ("2".equals(module.getConfigEntry("DisplayLevel"))) {
				// be sure we're at the bottom leaf before we enforce display level
				if (!module.hasKeyChildren()) {
					module.setKeyText(gbsEntry);
					String parent = module.getKeyParent();
					String heading = null;
					if (parent != null) {
						module.setKeyText(parent);
						heading = module.getRenderText();
						String[] children = module.getKeyChildren();
						// we better have children.  We should have been one of them
						if ((children != null) && (children.length > 0)) {
	%>
					<div <%= rtol ? "dir=\"rtl\"" : "" %> class="verse"><%= heading %> </div>
					<table>
	<%
							for (int i = 0; i < children.length; i++) {
								String k = parent + "/" + children[i];
								module.setKeyText(k);
								k = module.getKeyText();
								boolean curVerse = (k.equals(new String(gbsEntry.getBytes("iso8859-1"), "UTF-8")));
								String[] heads = module.getEntryAttribute("Heading", "Preverse", "0", true);
								if (heads.length > 0) {
			%>
					<tr><td colspan="2"><div <%= rtol ? "dir=\"rtl\"" : "" %> class="<%= curVerse ? "currentverse" : "verse" %>">
						<h3><span class="verse"><%= heads[0] %></span></h3></div></td></tr>
			<%
								}
			%>
					<tr>

			<%
								if (!rtol) {
			%>
					<td valign="top" align="right"><div <%= rtol ? "dir=\"rtl\"" : "" %> class="<%= curVerse ? "currentverse" : "verse" %>">
					<span class="versenum"><a <%= (k.equals(gbsEntry))?"id=\"cv\"":"" %> href="bookdisplay.jsp?gbsEntry=<%= URLEncoder.encode(k)+"#cv" %>">
						<%= children[i] %></a>
					</span></div></td>
			<%
								}
			%>

					<td><div <%= rtol ? "dir=\"rtl\"" : "" %> class="<%= curVerse ? "currentverse" : "verse" %>">

<%
								String lang = module.getConfigEntry("Lang");
//					<div xml:lang="<%= (lang.equals("")) ? "en" : lang 
				  mgr.setGlobalOption("Strong's Numbers", (strongs)?"On":"Off");
				  mgr.setGlobalOption("Morphological Tags", (morph)?"On":"Off");
%>
					<%= module.getRenderText() %>
<%
//					</div>
%>
					</div></td>
			<%
								if (rtol) {
			%>
					<td valign="top" align="right"><div <%= rtol ? "dir=\"rtl\"" : "" %> class="<%= curVerse ? "currentverse" : "verse" %>">
					<span class="versenum"><a <%= (k.equals(gbsEntry))?"id=\"cv\"":"" %> href="bookdisplay.jsp?key=<%= URLEncoder.encode(k)+"#cv" %>">
						<%= children[i] %></a>
					</span></div></td>
			<%
								}
			%>


					</tr>
	<%
							}
	%>
					</table>
	<%
							printed = true;
						}
					}
				}
			}
			if (!printed) {
	%>
				<div <%= rtol ? "dir=\"rtl\"" : "" %> class="verse">
				<%= module.getRenderText() %>
				</div>
	<%
			}
			String copyLine = module.getConfigEntry("ShortCopyright");
			if (copyLine.equalsIgnoreCase("<swnull>"))
				copyLine = "";
			if (module.getCategory().equals("Cults / Unorthodox / Questionable Material")) {
				copyLine = "<t:t>WARNING: This text is considered unorthodox by most of Christendom.</t:t> " + copyLine;
			}
%>
		<div class="copyLine"><%= copyLine %></div>
		</div>
<%
		}
%>
	</tiles:put>
</tiles:insert>


<%!
private synchronized static void printTree(Vector bookTreeOpen, JspWriter out, SWModule module, String rootTreeKey, String target, String currentJumpNode) {
	if ((module == null) || ("<SWNULL>".equals(module.getName()))) return;
	try {
		int max = 400;
		module.setKeyText(rootTreeKey);
		rootTreeKey = module.getKeyText();

		int offset = rootTreeKey.lastIndexOf("/");
		String[] children = module.getKeyChildren();
		boolean open = bookTreeOpen.contains(rootTreeKey);
		boolean dig = (children.length > 0);
		if (dig) {
			if ("2".equals(module.getConfigEntry("DisplayLevel"))) {
				dig = false;
				for (int i = 0; ((i < children.length) && (i < max)); i++) {
					module.setKeyText(rootTreeKey+"/"+children[i]);
					if (module.hasKeyChildren()) {
						dig = true;
						break;
					}
				}
			}
		}

		if (rootTreeKey.length()>0) {
			String localName = rootTreeKey.substring(offset+1);
			String linkRef = rootTreeKey;
			if (target.equals(rootTreeKey))
				out.print("<li id=\"current\">"); //the current entry in the navigation tree
			else
				out.print("<li>");

			if (dig) {
				out.print("<a " + (rootTreeKey.equals(currentJumpNode)? "id=\"cur\"":"") + " class=\"" + ((open)?"closed":"open") + "\" href=\"bookdisplay.jsp?" + ((open)?"close":"open") + "=" + URLEncoder.encode(rootTreeKey) + "#cur\"><img src=\"images/" + ((open)?"minus":"plus") + ".png\" alt=\"action\"/></a>");
			}
			else if (children.length > 0) {
				linkRef = rootTreeKey + "/" + children[0];
			}

			out.print(" <a href=\"bookdisplay.jsp?gbsEntry=" + URLEncoder.encode(linkRef) + "#cv\">" + localName + "</a>");

			out.print("</li>\n");
		}
		else open = true;
		

		if (open) {
			if (dig) {
				out.print("<li><ul>");

				for (int i = 0; ((i < children.length) && (i < max)); i++) {
					printTree(bookTreeOpen, out, module, rootTreeKey+"/"+children[i], target, currentJumpNode);
				}
				out.print("</ul></li>\n");
			}
		}
	}
	catch (Exception e) {e.printStackTrace();}
}

	%>
