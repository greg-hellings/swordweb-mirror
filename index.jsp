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

<div id="style">
<h2>Style:</h2>
		<ul>
			<li><a title="Washed Out" href="preferences.jsp?setStyle=Washed+Out">Washed Out</a></li>
			<li><a title="Sandy Creek" href="preferences.jsp?setStyle=Sandy+Creek">Sandy Creek</a></li>
			<li><a title="Parchment" href="preferences.jsp?setStyle=Parchment">Parchment</a></li>
		</ul>
</div>


   <div id="externallinks">
	<h2>External Links:</h2>
        <ul>
	<li><a href="http://www.bibleresourcecenter.org" title="ABS Bible Research Center">Bible Research Center</a></li>
	<li><a href="http://www.bibleresourcecenter.org/Research/multimedia/maps/" title="Interactive Maps">Interactive Maps</a></li>
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

<h2>ABOUT THE BIBLE TOOL
</h2>
<p>Welcome to The Bible Tool-- a free, evolving open source tool for exploring the Bible and related texts online. Created by Crosswire Bible Society, the Society of Biblical Literature and the American Bible Society as the first in a number of coming Bible engagement tools using an XML standard called <acronym title="Open Scripture Information Standard">OSIS</acronym>, we provide power searching capabilities and cutting edge tools to help you engage the Bible at a deeper level. <a href="#aboutthetool">Learn More...</a>
</p>

<h2>OTHER BIBLE TOOLS
</h2>
<p> Be sure to check out these other sites for free Bible resources:  <a href="http://www.crosswire.org/sword">The SWORD Project</a>, <a href="http://www.unboundbible.com/">Unbound Bible</a>, <a href="http://www.biblegateway.com">Bible Gateway</a>, <a href="http://bible.crosswalk.com/">Crosswalk</a>, and <a href="http://www.blueletterbible.org">Blue Letter Bible</a>.
</p>

<h2>DOWNLOADS
</h2>
<p>We offer a number of free Bible software downloads for Windows, Mac, Linux and Palm produced by Crosswire Bible Society. <a href="#downloads">Learn More...</a>
</p>

<h2>UPLOAD TEXTS
</h2>
<p>An <acronym title="Open Scripture Information Standard">OSIS</acronym> editing tool plug-in for Microsoft Word 2003 is under construction. The tool will be completed in the spring, 2004, and will let you encode texts in <acronym title="Open Scripture Information Standard">OSIS</acronym>  for use in the tools available on this site.
</p>

<h2>JUST FOR FUN
</h2>
<p>Are you the sort of person who creates a Klingon translation of the Bible? Would it cross your mind to build a Hyper-Concordance for the New Testament in your spare time? People are using an XML standard called <acronym title="Open Scripture Information Standard">OSIS</acronym> to do a number of interesting things. <a href="#fun">Learn More...</a>
</p>

<hr />

<h2 id="aboutthetool">ABOUT THE BIBLE TOOL
</h2>

<p>Welcome to The Bible Tool-- a free, evolving open source tool for exploring the Bible and related texts online. Created by Crosswire Bible Society, the Society of Biblical Literature and the American Bible Society as the first in a number of coming Bible engagement tools using an XML standard called <acronym title="Open Scripture Information Standard">OSIS</acronym> , we provide power searching capabilities to help you engage the Bible at a deeper level.
</p>
<p>The Bible Tool began as part of an effort by the <acronym title="Society of Biblical Literature">SBL</acronym> and <acronym title="American Bible Society">ABS</acronym> to bridge the gap between academia and the church. We want both scholars and laypeople to engage the Bible, gaining contextual understanding through:
</p>

<ul>
 <li>the use of technology to dig deeper into the text;</li>
 <li>accessing scholarly articles, to understand the implications of what academic discoveries might have in understanding the context of society in Bible times</li>
</ul>

<p>We plan to further this effort by:
</p>
<ul>
<li>making free, open source Bible tools available which people can customize for themselves and others, built by the hundreds of technical experts who volunteer their time to the Crosswire Bible Society;</li>
    
<li>providing an OSIS editor using MS Word 2003, so you can encode your texts and make them available for others</li>
    
<li>leveraging our existing distribution channels: making the tool available soon to the 20,000 churches who have Web sites using <acronym title="American Bible Society">ABS</acronym>'s ForMinistry.com, and the thousands of <acronym title="Society of Biblical Literature">SBL</acronym> members who engage the Bible from numerous academic perspectives</li>
</ul>

<p>To learn more about how to use the Bible Tool, visit our FAQ section.
</p>

<p>To learn more about the OSIS initiative, visit the Bible Technologies Group.
</p>

<h2 id="downloads">DOWNLOADS
</h2>
<p>Download a number of free Bible software downloads for Windows, Mac, Linux and Palm produced by Crosswire Bible Society.
</p>

<h3>Sword for Windows
</h3>
<p>Bible software developed for the Windows operating environment. Features include:
</p>

<ul>

<li>Parallel Bible display</li>
<li>Popup footnotes</li>
<li>Speed optimizations</li>
<li>Section headings</li>
 <li>Smarter verse parsing</li>
 <li><a href="ftp://ftp.crosswire.org/pub/sword/utils/win32/">OSIS import and export tools</a></li>
<li>Image Support</li>
<li>New language locales</li>
<li>Unicode 4.0 (including Plane 1) support</li>
</ul>

<h3>MacSword
</h3>
<p>Bible software developed specifically for Macintosh computers running Mac OS X.
</p>

<h3>Bible+ for Palm OS
</h3>
<p>Bible software developed for Palm.
</p>

<p>To view all the software available from Crosswire, go to the Crosswire Bible Society.
</p>



<h2 id="fun">JUST FOR FUN
</h2>
<p>Are you the sort of person who creates a Klingon translation of the Bible? Would it cross your mind to build a Hyper-Concordance for the New Testament in your spare time? People are using an XML standard called <acronym title="Open Scripture Information Standard">OSIS</acronym> to do a number of interesting things.
</p>

<h3>The Klingon Bible
</h3>

<blockquote><p>Hegh tI, 'ej ngab tI naH, 'ach reH taHtaH joH'a'ma' mu' The grass withers, the flower fades; but the word of our God stands forever. Isaiah 40:8</p>
</blockquote>

<p><a href="http://www.mrklingon.org/">A project of the Universal Translator Assistant Project</a>
</p>
<p>The Klingon Language Version is an experimental relexification of the WEB. It is not properly a translation, but a demonstration of what a tlhIngan Hol (Klingon Language) Bible would look like.
</p>

<p>Joel Anderson, who created the project, encoded his Klingon Bible in OSIS, so that it could be used in the Bible Tool. While some might consider this a bit eccentric (or if you are a Star Trek fan a breakthrough), our hope is that you will be able to use OSIS and OSIS-powered tools in your Bible Engagement efforts.
</p>


<h3>The Semantic Bible
</h3>
<p><a href="http://www.semanticbible.com/hyperconc.shtml">The Hyper-Concordance</a> is an experiment in word-based navigation through the New Testament. Each content word is hyperlinked to a page displaying all the verses for that word, preserving context and tightly connecting the content. Sean Boisen decided to do the project in his spare time, using OSIS. We'll be adding the functionality of his hyper-concordance to The Bible Tool.</p>

</div>
	</tiles:put>
</tiles:insert>
