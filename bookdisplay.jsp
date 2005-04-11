<%@ include file="init.jsp" %>

<%@ page import="java.util.Enumeration,java.util.Vector" %>
<%@ page import="gnu.regexp.RE" %>

<%
	Vector bookTreeOpen = (Vector)session.getAttribute("bookTreeOpen");


	session.setAttribute("lastModType", "GBS");
	String gbsBook = (String)request.getParameter("mod");
	if (gbsBook != null) {
		session.setAttribute("gbsBook", gbsBook);
	}
	gbsBook = (String)session.getAttribute("gbsBook");
	SWModule module = (gbsBook == null) ? null : mgr.getModuleByName(gbsBook);

	String gbsEntry = (String)request.getParameter("gbsEntry");
	if (gbsEntry != null)
		session.setAttribute("gbsEntry", gbsEntry);
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

	for (int i = 0; i < 2; i++) {
		String []nodes = request.getParameterValues((i>0)?"close":"open");
		if (nodes != null) {
			for (int j = 0; j < nodes.length; j++) {
				String node = nodes[j];
				if (node != null) {
					if (i>0)
						bookTreeOpen.remove(node);
					else {
						if (!bookTreeOpen.contains(node)) {
							bookTreeOpen.add(node);
						}
					}
				}
			}
		}
	}

%>
<tiles:insert beanName="basic" flush="true" >
	<%-- override lookup URL, so this script is used to display the keys --%>
	<tiles:put name="lookup_url" value="bookdisplay.jsp" />
	<tiles:put name="title" value="General Book Display" />
	<tiles:put name="pintro" type="string" ><div></div></tiles:put>
	<tiles:put name="sidebar_right" type="string" ><div></div></tiles:put>
	<tiles:put name="sidebar_left" type="string">


	<div id="genbooknav">
	<%
		if (module != null) {
			printTree(bookTreeOpen, out, module, "/", gbsEntry);
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
			module.setKeyText(gbsEntry);
	%>
			<div id="genbook">
				<h2><%= gbsEntry %></h2>
				<%= new String(module.getRenderText().getBytes("iso8859-1"), "UTF-8") %>
			</div>
	<%
		}
	%>
	</tiles:put>
</tiles:insert>


<%!
private synchronized static void printTree(Vector bookTreeOpen, JspWriter out, SWModule module, String rootTreeKey, String target) {

	try {
		int offset = rootTreeKey.lastIndexOf("/");
		module.setKeyText(rootTreeKey);
		String[] children = module.getKeyChildren();
		boolean open = bookTreeOpen.contains(rootTreeKey);

		if (offset > 0) {
			String localName = rootTreeKey.substring(offset+1);
			if (target.equals(rootTreeKey))
				out.print("<li id=\"current\">"); //the current entry in the navigation tree
			else
				out.print("<li>");

			if (children.length > 0) {
				out.print("<a class=\"" + ((open)?"closed":"open") + "\" href=\"bookdisplay.jsp?" + ((open)?"close":"open") + "=" + URLEncoder.encode(rootTreeKey) + "\"><img src=\"images/" + ((open)?"minus":"plus") + ".png\" alt=\"action\"/></a>");
			}

			out.print(" <a href=\"bookdisplay.jsp?gbsEntry=" + URLEncoder.encode(rootTreeKey) + "\">" + localName + "</a>");

			out.print("</li>");
		}

		if ((open) || (offset < 1)) {
			if (children.length > 0)
				out.print("<ul>");

			for (int i = 0; i < children.length; i++) {
				printTree(bookTreeOpen, out, module, rootTreeKey+"/"+children[i], target);
			}

			if (children.length > 0)
				out.print("</ul>");
		}
	}
	catch (Exception e) {e.printStackTrace();}
}

	%>
