<%@ include file="defines/tiles.jsp" %>

<tiles:insert beanName="basic" flush="true" >
	<tiles:put name="title" value="About" />

	<tiles:put name="sidebar_left" type="string">
	</tiles:put>

	<tiles:put name="sidebar_right" type="string">
	</tiles:put>

	<tiles:put name="content" type="string">

<h2>Help</h2>
This is the help page!

	</tiles:put>
</tiles:insert>
