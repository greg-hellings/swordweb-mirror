<%@ include file="defines/tiles.jsp" %>

<tiles:insert beanName="basic" flush="true" >
	<tiles:put name="title" value="OSIS Bible Tool" />

	<tiles:put name="sidebar_left" type="string">
<div>
<br/>
<h3>Tools And Things</h3>
<br/>
<ul>
<li><a href="http://www.sbl-site.org/e-resources.html">SBL Online Resources</a><br/><br/></li>
<li><a href="http://www.bibleresourcecenter.org">ABS Online Resources</a><br/><br/></li>
<li><a href="http://www.bibleresourcecenter.org/Research/multimedia/maps/">Interative Maps</a><br/><br/></li>
<li><a href="http://www.bibleresourcecenter.org/research/virtuallibrary.dsp">Virtual Bible Library</a><br/><br/></li>
</ul>
</div>
<div>
<h3>OSIS Library</h3><br/>
		<ul>
<%
			Vector leaves = new Vector();
			for (int i = 0; i < modInfo.length; i++) {
				if (!leaves.contains(modInfo[i].category)) {
					leaves.add(modInfo[i].category);
%>
		
<li><a href="fulllibrary.jsp?action=closeAll&open=<%= URLEncoder.encode(modInfo[i].category) %>"><%= modInfo[i].category %></a></li><br/>
<%
				}
			}
%>
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
	</tiles:put>

	<tiles:put name="content" type="string">
Welcome to the OSIS Bible Tool-- a free, open source tool for exploring the Bible and related public domain texts online.  We provide power searching capabilities and cutting edge tools to help you engage the Bible at a deeper level.  Our entire library is available here.<br/><br/>
Also, be sure to check out these other sites for free Bible resources:  <a href="http://www.crosswire.org/sword">The SWORD Project</a>, <a href="http://www.unboundbible.com/">Unbound Bible</a>, <a href="http://www.biblegateway.com">Bible Gateway</a>, <a href="http://bible.crosswalk.com/">Crosswalk</a>, and <a href="http://www.blueletterbible.org">Blue Letter Bible</a>. <br/><br/>
	</tiles:put>
</tiles:insert>
