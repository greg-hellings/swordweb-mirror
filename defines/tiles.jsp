<%@ taglib uri="/WEB-INF/lib/struts-tiles.tld" prefix="tiles" %>

<%@ include file="../init.jsp" %>

<tiles:definition id="basic" page="layouts/base-layout.jsp">
	<tiles:put name="lookup_url" value="passagestudy.jsp" />
	<tiles:put name="title" value="OSIS web application" />
	<tiles:put name="header" value="tiles/header.jsp" />
	<tiles:put name="footer" value="tiles/footer.jsp" />
	<tiles:put name="sidebar_right" value="" />
	<tiles:put name="pintro" value="" />
	<tiles:put name="sidebar_left" value="" />
	<tiles:put name="content" value="" />
</tiles:definition>
