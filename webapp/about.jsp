<%@ include file="init.jsp" %>

<tiles:insert beanName="basic" flush="true" >
	<tiles:put name="title" value="About" />
	<tiles:put name="pintro" type="string" ><div></div></tiles:put>

	<tiles:put name="sidebar_left" type="string">
	</tiles:put>

	<tiles:put name="sidebar_right" type="string">
	</tiles:put>

	<tiles:put name="content" type="string">
<div id="about">

<h2><t:t>Contact</t:t></h2>
<p></p>


</div>

	</tiles:put>
</tiles:insert>
