<%@ include file="init.jsp" %>

<%@ page import="java.util.Enumeration,java.util.Vector" %>
<%@ page import="gnu.regexp.RE" %>
<%@ page import="org.crosswire.swordweb.*" %>


<%
	Vector catTreeOpen = (Vector)session.getAttribute("catTreeOpen");

	String action = (String)request.getParameter("action");
	String show = (String)request.getParameter("show");
	if (show != null)
		session.setAttribute("catShow", show);
	show = (String)session.getAttribute("catShow");
	if ((action != null) && (action.equalsIgnoreCase("closeAll"))) {
		catTreeOpen = null;
	}

	if (catTreeOpen == null) {
		catTreeOpen = new Vector();
		session.setAttribute("catTreeOpen", catTreeOpen);
	}

	for (int i = 0; i < 2; i++) {
		String []nodes = request.getParameterValues((i>0)?"close":"open");
		if (nodes != null) {
			for (int j = 0; j < nodes.length; j++) {
				String node = nodes[j];
				if (node != null) {
					if (i>0)
						catTreeOpen.remove(node);
					else {
						if (!catTreeOpen.contains(node)) {
							catTreeOpen.add(node);
						}
					}
				}
			}
		}
	}

%>
<tiles:insert beanName="basic" flush="true" >
	<%-- override lookup URL, so this script is used to display the keys --%>
	<tiles:put name="lookup_url" value="fulllibrary.jsp" />
	<tiles:put name="title" value="Full Library Catalog" />
	<tiles:put name="pintro" type="string" ><div></div></tiles:put>
	<tiles:put name="sidebar_right" type="string" ><div></div></tiles:put>
	<tiles:put name="sidebar_left" type="string">

	<div id="library">
		<h2><t:t>OSIS Library</t:t></h2>
		<ul>		
<%
			SidebarModuleView sidebarView = new SimpleModuleView(mgr);
			SidebarItemRenderer modRenderer = new SidebarItemRenderer() { //an anonymous class which renders a list of modules with links to read each of them
				public String renderModuleItem(SWModule module) {
					StringBuffer ret = new StringBuffer();
					ret.append("<li><a href=\"fulllibrary.jsp?show=")
						.append(URLEncoder.encode(module.getName()))
						.append("#cv\" title=\"Information about this module\">")
						.append(module.getDescription().replaceAll("&", "&amp;"))
						.append("</a></li>");
		
					return ret.toString();
				}
			};
		
			Vector leaves = new Vector();
			Vector modules = new Vector();
			for (int i = 0; i < modInfo.length; i++) {
				if (!leaves.contains(modInfo[i].category)) {
					leaves.add(modInfo[i].category);
					boolean open = catTreeOpen.contains(modInfo[i].category);
%>

					<li class="<%= open ? "open" : "closed" %>">
						<a href="fulllibrary.jsp?<%= (open)?"close":"open" %>=<%= URLEncoder.encode(modInfo[i].category) %>">
						<%= modInfo[i].category %>
						</a>
					</li>
<%
					if (open) {
						for (int j = 0; j < modInfo.length; j++) {
							if (modInfo[i].category.equals(modInfo[j].category)) {
								modules.add(modInfo[j].name);
							}
						}

						out.print( sidebarView.renderView( modules, modRenderer ) ); //insert the sub list of the modules in the current category
					}

				}
			}
%>
		</ul>
	</div> <!-- End of library-id div -->
	</tiles:put>

	<tiles:put name="content" type="string">
<%
		if (show != null) {
			SWModule module = mgr.getModuleByName(show);
			if (module != null) {
%>
			<div id="genbook">
<%
				String about = module.getConfigEntry("About");
// out.write("<!-- ***" + about + "*** ->");
				if (about != null) {
					RE pardRegex = new RE("\\\\pard");
					about = pardRegex.substituteAll(about, "");

					RE parRegex = new RE("\\\\par");
					about = parRegex.substituteAll(about, "<br />");

					RE rtfRegex = new RE("\\\\\\w+");
					about = rtfRegex.substituteAll(about, "");
				}
				String type = module.getCategory();
				String targetURL = "";
				if ((SwordOrb.BIBLES.equals(type)) || ("Cults / Unorthodox / Questionable Material".equals(type)) || (SwordOrb.COMMENTARIES.equals(type))) {
					targetURL = "passagestudy.jsp?mod="+URLEncoder.encode(module.getName())+"#cv";
				}
				else if (SwordOrb.DAILYDEVOS.equals(type)) {
					targetURL = "dailydevotion.jsp?mod="+URLEncoder.encode(module.getName());
				}
				else if ((SwordOrb.GENBOOKS.equals(type)) ||
						("Essays".equals(type))) {
					targetURL = "bookdisplay.jsp?mod="+URLEncoder.encode(module.getName());
				}

				String promoLine = module.getConfigEntry("ShortPromo");
				if (promoLine.equalsIgnoreCase("<swnull>"))
					promoLine = "";
%>
	<h2><a href="<%= targetURL %>"><%= module.getDescription() %></a></h2>
	<p><%= about %></p>
	<div id="aboutPromo"><%= promoLine %></div>
			</div>
<%

			}
		}
%>
	</tiles:put>
</tiles:insert>
