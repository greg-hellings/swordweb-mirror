<%@ include file="defines/tiles.jsp" %>

<tiles:insert beanName="basic" flush="true" >
	<tiles:put name="title" value="OSIS Bible Tool" />

	<tiles:put name="sidebar_left" type="string">
<div class="bluepanel">
<br/>
<h3>Tools And Things</h3>
<br/>
<ul>
<li>SBL Online Resources<br/><br/></li>
<li>ABS Online Resources<br/><br/></li>
<li>Interative Maps<br/><br/></li>
<li>Virtual Bible Library<br/><br/></li>
</ul>
</div>
	</tiles:put>

	<tiles:put name="sidebar_right" type="string">
<div class="bluepanel">
<center><h4>Library Upload Tool</h4></center><br/>
<form><input type="submit" class="searchbutton" value="ADD YOUR TEXT HERE" /></form><br/>
<i>Have you produced serious academic scholarship related to Biblical text?  Using our Scholar OSIS Tool, you can upload it for students or fellow scholars to review, or submit it to SBL for inclusion on OSIS Bible Tool.<br/><br>
Only works reviewed and approved by SBL will be added for viewing by the public at large.</i>
</div>
<div class="bluepanel">

</div>
	</tiles:put>

	<tiles:put name="content" type="string">
Welcome to the OSIS Bible Tool; a free, open source tool for exploring the Bible and related public domain texts online.  We provide power searching capabilities and cutting edge tools to help you engage the Bible at a deeper level.  Our entire library is available here.<br/><br/>
Also, be sure to check out these other sites for free Bible resources:  The SWORD Project, Unbound Bible, Bible Gateway, Crosswalk, and Blue Letter Bible.
	</tiles:put>
</tiles:insert>
