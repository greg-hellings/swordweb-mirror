<%@ include file="defines/tiles.jsp" %>

<tiles:insert beanName="basic" flush="true" >
	<tiles:put name="title" value="About" />

	<tiles:put name="sidebar_left" type="string">
	</tiles:put>

	<tiles:put name="sidebar_right" type="string">
	</tiles:put>

	<tiles:put name="content" type="string">

<h2>About the OSIS web interface</h2><br/><br/>
The OSIS Bible Tool is brought to you by the Society of Biblical Literature
and the American Bible Society.  The tool is intended to provide a free
resource for scholars to engage the Bible and related texts from a scholarly
perspective.  We include a tool for you to add your own texts, so you can
add texts to the library for yourself, your students or your peers.  If you
would like to add content to the tool, either your own or something in the
public domain, please send the text to SBL for review and we will put it on
the site.<br/><br/>

The OSIS Bible Tool was built by the Crosswire Bible Society, and
organization which provides free open source software.  You can visit
Crosswire at <a href="www.crosswire.org">www.crosswire.org</a>.<br/><br/>

To learn more about the OSIS initiative, visit <a href="www.bibletechnology.org">www.bibletechnologies.org</a>.


	</tiles:put>
</tiles:insert>
