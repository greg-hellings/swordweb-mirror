<%@ include file="defines/tiles.jsp" %>
<%@ page import="java.util.Enumeration,java.util.Vector" %>
<%@ page import="gnu.regexp.RE" %>

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
	<tiles:put name="sidebar_left" type="string">
		<ul>
<%
			Vector leaves = new Vector();
			for (int i = 0; i < modInfo.length; i++) {
				if (!leaves.contains(modInfo[i].category)) {
					leaves.add(modInfo[i].category);
					boolean open = catTreeOpen.contains(modInfo[i].category);
%>
		
					<li><b><a href="fulllibrary.jsp?<%= (open)?"close":"open" %>=<%= URLEncoder.encode(modInfo[i].category) %>"><%= ((open)?"[-]":"[+]") %></a>  <%= modInfo[i].category %></b></li>
<%
					if (open) {
%>
						<ul>
<%
						for (int j = 0; j < modInfo.length; j++) {
							if (modInfo[i].category.equals(modInfo[j].category)) {
								SWModule module = mgr.getModuleByName(modInfo[j].name);
								if (module != null) {
%>
									<li><a href="fulllibrary.jsp?show=<%= URLEncoder.encode(modInfo[j].name) %>"><%= modInfo[j].name %></a>  <%= module.getDescription() %></li>
<%
								}
							}
						}
%>
						</ul>
<%
					}
					
				}
			}
%>
		</ul>
	</tiles:put>
	<tiles:put name="content" type="string">
<%
		if (show != null) {
			SWModule module = mgr.getModuleByName(show);
			if (module != null) {
				String about = module.getConfigEntry("About");
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
				if ((SwordOrb.BIBLES.equals(type)) || (SwordOrb.COMMENTARIES.equals(type))) {
					targetURL = "passagestudy.jsp?mod="+URLEncoder.encode(module.getName());
				}
				else if (SwordOrb.DAILYDEVOS.equals(type)) {
					targetURL = "dailydevotion.jsp?mod="+URLEncoder.encode(module.getName());
				}
				else if (SwordOrb.GENBOOKS.equals(type)) {
					targetURL = "bookdisplay.jsp?mod="+URLEncoder.encode(module.getName());
				}
%>
	<h2><a href="<%= targetURL %>"><%= module.getDescription() %></a></h2>
	<%= about %>
<%

			}
		}
%>
	</tiles:put>
</tiles:insert>
