<%@ include file="defines/tiles.jsp" %>

<tiles:insert beanName="basic" flush="true" >
	<tiles:put name="title" value="About" />

	<tiles:put name="sidebar_left" type="string">
	</tiles:put>

	<tiles:put name="sidebar_right" type="string">
	</tiles:put>

	<tiles:put name="content" type="string">

<h2>About the OSIS web interface</h2>
This is the place where the about information should be put. More information will be made available later on.

	</tiles:put>
</tiles:insert>
