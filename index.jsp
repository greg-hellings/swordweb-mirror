<%@ include file="defines/tiles.jsp" %>

<%@ page import="java.util.Vector" %>

<tiles:insert beanName="basic" flush="true" >
	<tiles:put name="title" value="OSIS Bible Tool" />

	<tiles:put name="sidebar_left" type="string">




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
 <%= modInfo[i].category %>
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
<!-- 
I commented this section out until it can be made functional.
<div id="uploadtool">
<h2>Library Upload Tool</h2>
<p><a href="place_holder">ADD YOUR TEXT HERE</a></p>
<p>Have you produced serious academic scholarship related to Biblical text?  Using our Scholar OSIS Tool, you can upload it for students or fellow scholars to review, or submit it to SBL for inclusion on OSIS Bible Tool.</p>
<p>Only works reviewed and approved by SBL will be added for viewing by the public at large.</p>
</div>
 -->

   <div id="externallinks">
	<h2>External Links:</h2>
        <ul>
          <li><a href="http://www.sbl-site.org/Resources/" title="Society of Biblical Literature Online Resources">SBL Online Resources</a></li>
          <li><a href="http://www.bibleresourcecenter.org" title="American Bible Society Online Resources">ABS Online Resources</a></li>
          <li><a href="http://www.bibleresourcecenter.org/Research/multimedia/maps/" title="Interative Maps">Interative Maps</a></li>
          <li><a href="http://www.bibleresourcecenter.org/research/virtuallibrary.dsp" title="Virtual Bible Library">Virtual Bible Library</a></li>
        </ul>

<ul>

<li><a href="http://crosswire.org/" title="CrossWire Bible Society">CrossWire Bible Society</a></li>
<li><a href="http://www.americanbible.org/" title="American Bible Society">American Bible Society</a></li>
<li><a href="http://sbl-site.org/" title="Society of Biblical Literature">Society of Biblical Literature</a></li>
<li><a href="http://crosswire.org/sword/" title="The Sword Project">The Sword Project</a></li>
<li><a href="http://www.bibletechnologies.net/" title="Open Scripture Information Standard">OSIS</a></li>


</ul>



   </div>


	</tiles:put>

	<tiles:put name="content" type="string">
<div id="welcome">

<h2>ABOUT THE BIBLE TOOL</h2>
<p>
    Welcome to the OSIS Bible Tool-- a free, open source tool for exploring the Bible and related public domain texts online. We provide power searching capabilities and cutting edge tools to help you engage the Bible at a deeper level. Our entire library is available here.
</p>

<p>
Also, be sure to check out these other sites for free Bible resources:  <a href="http://www.crosswire.org/sword">The SWORD Project</a>, <a href="http://www.unboundbible.com/">Unbound Bible</a>, <a href="http://www.biblegateway.com">Bible Gateway</a>, <a href="http://bible.crosswalk.com/">Crosswalk</a>, and <a href="http://www.blueletterbible.org">Blue Letter Bible</a>. 
</p>
</div>
	</tiles:put>
</tiles:insert>
