<%@ include file="defines/tiles.jsp" %>

<tiles:insert beanName="basic" flush="true" >
	<tiles:put name="title" value="OSIS Bible Tool" />

	<tiles:put name="sidebar_left" type="string">


   <div id="externallinks">
	<h2>External Links:</h2>
        <ul>
          <li><a href="http://www.sbl-site.org/e-resources.html" title="Society of Biblical Literature Online Resources">SBL Online Resources</a></li>
          <li><a href="http://www.bibleresourcecenter.org" title="American Bible Society Online Resources">ABS Online Resources</a></li>
          <li><a href="http://www.bibleresourcecenter.org/Research/multimedia/maps/" title="Interative Maps">Interative Maps</a></li>
          <li><a href="http://www.bibleresourcecenter.org/research/virtuallibrary.dsp" title="Virtual Bible Library">Virtual Bible Library</a></li>
        </ul>
   </div>

   <div id="library">
	<h2>OSIS Library</h2>
	<ul class="plain">
<%
			Vector leaves = new Vector();
			for (int i = 0; i < modInfo.length; i++) {
				if (!leaves.contains(modInfo[i].category)) {
					leaves.add(modInfo[i].category);
%>
		<li class="closed">
			<a href="fulllibrary.jsp?action=closeAll&amp;open=<%= URLEncoder.encode(modInfo[i].category) %>">
				<img src="images/plus.png"/> <%= modInfo[i].category %>
			</a>
		</li>
<%
				}
			}
%>
	</ul>
   </div>

	</tiles:put>

	<tiles:put name="sidebar_right" type="string">

<div class="bluepanel">
<h2>Library Upload Tool</h2>
<p><a href="place_holder">ADD YOUR TEXT HERE</a></p>
<p>Have you produced serious academic scholarship related to Biblical text?  Using our Scholar OSIS Tool, you can upload it for students or fellow scholars to review, or submit it to SBL for inclusion on OSIS Bible Tool.</p>
<p>Only works reviewed and approved by SBL will be added for viewing by the public at large.</p>
</div>
	</tiles:put>

	<tiles:put name="content" type="string">
<p>
Welcome to the OSIS Bible Tool-- a free, open source tool for exploring the Bible and related public domain texts online.  We provide power searching capabilities and cutting edge tools to help you engage the Bible at a deeper level.  Our entire library is available here.<br/><br/>
</p>
<p>
Also, be sure to check out these other sites for free Bible resources:  <a href="http://www.crosswire.org/sword">The SWORD Project</a>, <a href="http://www.unboundbible.com/">Unbound Bible</a>, <a href="http://www.biblegateway.com">Bible Gateway</a>, <a href="http://bible.crosswalk.com/">Crosswalk</a>, and <a href="http://www.blueletterbible.org">Blue Letter Bible</a>. <br/><br/>
</p>
	</tiles:put>
</tiles:insert>
