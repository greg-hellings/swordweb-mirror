<%@ include file="defines/tiles.jsp" %>

<tiles:insert beanName="basic" flush="true" >
	<tiles:put name="title" value="XpressBible" />

	<tiles:put name="sidebar_left" type="string">
<h2>Tools And Things</h2>
<ul>
<li>SBL Online Resources</li>
<li>ABS Online Resources</li>
<li>Interative Maps</li>
<li>Virtual Bible Library</li>
</ul>
	</tiles:put>

	<tiles:put name="sidebar_right" type="string">
	</tiles:put>

	<tiles:put name="content" type="string">
Welcome to the XpressBible; a free, open source tool for exploring the Bible and related public domain texts online.  We provide power searching capabilities and cutting edge tools to help you engage the Bible at a deeper level.  Our entire library is available here.<br/><br/>
Also, be sure to check out these other sites for free Bible resources:  The SWORD Project, Unbound Bible, Bible Gateway, Crosswalk, and Blue Letter Bible.
	</tiles:put>
</tiles:insert>
