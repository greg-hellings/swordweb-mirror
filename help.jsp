<%@ include file="defines/tiles.jsp" %>

<tiles:insert beanName="basic" flush="true" >
	<tiles:put name="title" value="About" />

	<tiles:put name="sidebar_left" type="string">
	</tiles:put>

	<tiles:put name="sidebar_right" type="string">
	</tiles:put>

	<tiles:put name="content" type="string">
<div id="help">
<h2>Help</h2>
<p>This is the help page!</p>

<p>
Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
</p>

</div>
	</tiles:put>
</tiles:insert>
