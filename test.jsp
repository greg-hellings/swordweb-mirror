<%@ include file="init.jsp" %>

<tiles:insert beanName="basic" flush="true" >
	<tiles:put name="title" value="Test" />
	<tiles:put name="pintro" type="string" ><div></div></tiles:put>

	<tiles:put name="sidebar_left" type="string">
		test content for the left column
	</tiles:put>

	<tiles:put name="sidebar_right" type="string">
		test content for the left column
	</tiles:put>

	<tiles:put name="content" type="string">
		test content for the main part of the page. Headers and footers are defined in defines.jsp, but can be overwritten as all other tags.
	</tiles:put>
</tiles:insert>
