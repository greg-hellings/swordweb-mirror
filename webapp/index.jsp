<%@ include file="init.jsp" %>

<%@ page import="java.util.Vector" %>

<tiles:insert beanName="basic" flush="true" >
	<tiles:put name="title" value="OSIS Bible Tool" />

	<tiles:put name="sidebar_left" type="string">
	<tiles:put name="pintro" type="string">
	<div id="introflash"></div>
	</tiles:put>

   <div id="library">
	<h2><t:t>OSIS Library</t:t></h2>
		<ul class="plain">
<%
			Vector leaves = new Vector();
			for (int i = 0; i < modInfo.length; i++) {
				if (!leaves.contains(modInfo[i].category)) {
					leaves.add(modInfo[i].category);
%>
		<li class="closed">
			<a href="fulllibrary.jsp?action=closeAll&amp;open=<%= URLEncoder.encode(modInfo[i].category) %>">
 <t:t><%= modInfo[i].category %></t:t>
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
<h2><t:t>Style:</t:t></h2>
		<ul>
<% for (int i = 0; i < styleNames.size(); i++) { %>
			<li><a href="index.jsp?setStyle=<%= URLEncoder.encode((String)styleNames.get(i)) %>" title="<%= (String) styleNames.get(i) %>"><t:t><%= (String) styleNames.get(i) %></t:t></a></li>
<% } %>
		</ul>
</div>
<div id="language">
<h2><t:t>Languages:</t:t></h2>
		<ul>
<% for (int i = 0; i < offeredLanguages.size(); i++) { %>
			<li><a href="index.jsp?lang=<%= URLEncoder.encode((String)offeredLanguages.get(i)) %>" title="<%= (String) offeredLanguages.get(i) %>"><t:t><%= (String) offeredLanguages.get(i) %></t:t></a></li>
<% } %>
		</ul>
</div>


   <div id="externallinks">
	<h2><t:t>External Links:</t:t></h2>
        <ul>
	<li><a href="http://www.bibleresourcecenter.org" title="ABS Bible Research Center"><t:t>Bible Research Center</t:t></a></li>
	<li><a href="http://www.bibleresourcecenter.org/Research/multimedia/maps/" title="Interactive Maps"><t:t>Interactive Maps</t:t></a></li>
	<li><a href="http://crosswire.org/" title="CrossWire Bible Society"><t:t>CrossWire Bible Society</t:t></a></li>
	<li><a href="http://www.americanbible.org/" title="American Bible Society"><t:t>American Bible Society</t:t></a></li>
	<li><a href="http://sbl-site.org/" title="Society of Biblical Literature"><t:t>Society of Biblical Literature</t:t></a></li>
	<li><a href="http://crosswire.org/sword/" title="The SWORD Project"><t:t>The SWORD Project</t:t></a></li>
	<li><a href="http://www.bibletechnologies.net/" title="Open Scripture Information Standard">OSIS</a></li>
</ul>



   </div>


	</tiles:put>

	<tiles:put name="content" type="string">
<div id="welcome">

<% if (request.getParameter("section") == null) { %>

	<h2><t:t>ABOUT THE BIBLE TOOL</t:t></h2>
	<p><t:t>Welcome to The Bible Tool-- a free, evolving open source tool for exploring the Bible and related texts online. Created by CrossWire Bible Society, the Society of Biblical Literature and the American Bible Society as the first in a number of coming Bible engagement tools using an XML standard called </t:t><acronym title="Open Scripture Information Standard">OSIS</acronym>, <t:t>we provide power searching capabilities and cutting edge tools to help you engage the Bible at a deeper level. </t:t><a href="index.jsp?section=aboutthetool"><t:t>Learn More...</t:t></a>
	</p>

	<h2><t:t>OTHER BIBLE TOOLS</t:t></h2>
	<p><t:t>Be sure to check out these other sites for free Bible resources:  </t:t><a href="http://www.crosswire.org/sword"><t:t>The SWORD Project,</t:t></a> <a href="http://www.unboundbible.com/"><t:t>Unbound Bible,</t:t></a> <a href="http://www.biblegateway.com"><t:t>Bible Gateway,</t:t></a> <a href="http://bible.crosswalk.com/"><t:t>Crosswalk,</t:t></a> <a href="http://www.blueletterbible.org"><t:t>and Blue Letter Bible</t:t></a>.
	</p>

	<h2><t:t>DOWNLOADS</t:t></h2>
	<p><t:t>We offer a number of free Bible software downloads for Windows, Mac, Linux, and PDAs, produced by CrossWire Bible Society. </t:t><a href="index.jsp?section=downloads"><t:t>Learn More...</t:t></a>
	</p>

	<h2><t:t>UPLOAD TEXTS</t:t></h2>
	<p><t:t>An <acronym title="Open Scripture Information Standard">OSIS</acronym> editing tool plug-in for Microsoft Word 2003 is under construction. The tool will be completed in the spring, 2004, and will let you encode texts in <acronym title="Open Scripture Information Standard">OSIS</acronym>  for use in the tools available on this site.</t:t>
	</p>

	<h2><t:t>JUST FOR FUN</t:t></h2>
	<p><t:t>Are you the sort of person who creates a Klingon translation of the Bible? Would it cross your mind to build a Hyper-Concordance for the New Testament in your spare time? People are using an XML standard called <acronym title="Open Scripture Information Standard">OSIS</acronym> to do a number of interesting things.</t:t> <a href="index.jsp?section=fun"><t:t>Learn More...</t:t></a>
	</p>

<% } %>

<% if ("aboutthetool".equals((String)request.getParameter("section"))) { %>
	<h2 id="aboutthetool"><t:t>ABOUT THE BIBLE TOOL</t:t></h2>

	<p><t:t>Welcome to The Bible Tool-- a free, evolving open source tool for exploring the Bible and related texts online. Created by CrossWire Bible Society, the Society of Biblical Literature and the American Bible Society as the first in a number of coming Bible engagement tools using an XML standard called <acronym title="Open Scripture Information Standard">OSIS</acronym> , we provide power searching capabilities to help you engage the Bible at a deeper level.</t:t>
	</p>
	<p><t:t>The Bible Tool began as part of an effort by the <acronym title="Society of Biblical Literature">SBL</acronym> and <acronym title="American Bible Society">ABS</acronym> to bridge the gap between academia and the church. We want both scholars and laypeople to engage the Bible, gaining contextual understanding through:</t:t>
	</p>

	<ul>
	<li><t:t>the use of technology to dig deeper into the text;</t:t></li>
	<li><t:t>accessing scholarly articles, to understand the implications of what academic discoveries might have in understanding the context of society in Bible times</t:t></li>
	</ul>

	<p><t:t>We plan to further this effort by:</t:t></p>
	<ul>
	<li><t:t>making free, open source Bible tools available which people can customize for themselves and others, built by the hundreds of technical experts who volunteer their time to the CrossWire Bible Society;</t:t></li>

	<li><t:t>providing an OSIS editor using MS Word 2003, so you can encode your texts and make them available for others</t:t></li>

	<li><t:t>leveraging our existing distribution channels: making the tool available soon to the 20,000 churches who have Web sites using <acronym title="American Bible Society">ABS</acronym>'s ForMinistry.com, and the thousands of <acronym title="Society of Biblical Literature">SBL</acronym> members who engage the Bible from numerous academic perspectives</t:t></li>
	</ul>

	<p>To learn more about how to use the Bible Tool, visit our FAQ section.
	</p>

	<p><t:t>To learn more about the OSIS initiative, visit the Bible Technologies Group.</t:t></p>

<% } %>

<% if ("downloads".equals((String)request.getParameter("section"))) { %>
	<h2 id="downloads"><t:t>DOWNLOADS</t:t></h2>
	<p><t:t>Download a number of free Bible software downloads for Windows, Mac, Linux and Palm produced by CrossWire Bible Society.</t:t></p>

	<h3><a href="http://crosswire.org/sword/" title="SWORD for Windows"><t:t>SWORD for Windows</t:t></a></h3>
	<p><t:t>Bible software developed for the Windows operating environment. Features include:</t:t></p>

	<ul>
		<li><t:t>Parallel Bible display</t:t></li>
		<li><t:t>Popup footnotes</t:t></li>
		<li><t:t>Speed optimizations</t:t></li>
		<li><t:t>Section headings</t:t></li>
		<li><t:t>Smarter verse parsing</t:t></li>
		<li><a href="ftp://ftp.crosswire.org/pub/sword/utils/win32/"><t:t>OSIS import and export tools</t:t></a></li>
		<li><t:t>Image Support</t:t></li>
		<li><t:t>New language locales</t:t></li>
		<li><t:t>Unicode 4.0 (including Plane 1) support</t:t></li>
	</ul>

	<h3><a href="http://www.macsword.com/" title="More about MacSWORD"><t:t>MacSWORD</t:t></a></h3>
	<p><t:t>Bible software developed specifically for Macintosh computers running Mac OS X.</t:t></p>

	<h3><a href="http://gnomesword.sf.net/" title="More about GnomeSword"><t:t>GnomeSword</t:t></a></h3>
	<p><t:t>GnomeSword is a Bible Study application based on Gnome / Linux.</t:t></p>

	<h3><a href="http://www.bibletime.info/" title="More about BibleTime"><t:t>BibleTime</t:t></a></h3>
	<p><t:t>BibleTime is a Bible study application for Linux. It is based on the K Desktop Environment.</t:t></p>


	<h3><a href="http://palmbibleplus.sourceforge.net/" title="Bible+ for Palm OS"><t:t>Bible+ for Palm OS</t:t></a></h3>
	<p><t:t>Bible software developed for Palm.</t:t></p>

	<p><t:t>To view all the software available from CrossWire, go to the </t:t><a href="http://www.crosswire.org/"><t:t>CrossWire Bible Society</t:t></a>.</p>

<% } %>

<% if ("fun".equals((String)request.getParameter("section"))) { %>
	<h2 id="fun"><t:t>JUST FOR FUN</t:t></h2>
	<p><t:t>Are you the sort of person who creates a Klingon translation of the Bible? Would it cross your mind to build a Hyper-Concordance for the New Testament in your spare time? People are using an XML standard called <acronym title="Open Scripture Information Standard">OSIS</acronym> to do a number of interesting things.</t:t></p>

	<h3><t:t>The Klingon Bible</t:t></h3>

	<blockquote><p>Hegh tI, 'ej ngab tI naH, 'ach reH taHtaH joH'a'ma' mu' <t:t>The grass withers, the flower fades; but the word of our God stands forever. Isaiah 40:8</t:t></p>
	</blockquote>

	<p><a href="http://www.mrklingon.org/"><t:t>A project of the Universal Translator Assistant Project</t:t></a>
	</p>
	<p><t:t>The Klingon Language Version is an experimental relexification of the WEB. It is not properly a translation, but a demonstration of what a tlhIngan Hol (Klingon Language) Bible would look like.</t:t></p>

	<p><t:t>Joel Anderson, who created the project, encoded his Klingon Bible in OSIS, so that it could be used in the Bible Tool. While some might consider this a bit eccentric (or if you are a Star Trek fan a breakthrough), our hope is that you will be able to use OSIS and OSIS-powered tools in your Bible Engagement efforts.</t:t></p>


<h3><t:t>Why a Klingon Bible?</t:t></h3>
<p>
<t:t>Once anyone hears of a project to make a Klingon Bible, the question that comes up is "why?"  Certainly there is no need for such a version, as there is a need for a Bible in English, Spanish, German, or any other "real" language.  There is no person who would only be able to access the scriptures in Klingon.</t:t></p>
<p>
<t:t>But in the study of artificial languages, translating standard works of literature like the Bible is often done, and for two reasons.  First, it is a way to exercise and develop the language, and second, it helps to develop a body of literature in that language.  This literature can then be used and referred to by people learning and using the language.</t:t></p>
<p>
<t:t>For some, there can be other benefits.  Though this kind of translation might seem frivolous, the work of producing such a translation can have devotional value even if the translation is never used.  The effort of reading the scriptures and considering their meaning for a translation cannot fail to benefit the translator by helping him or her develop a deeper understanding of the text.</t:t></p>
<p>
<t:t>The Klingon language community has produced at least three efforts in this direction.  </t:t><a href="http://www.kli.org"><t:t>The Klingon Language Institute</t:t></a>  <t:t>organized a long-term project to translate the Bible.  Currently on hiatus, this project has yielded only a few books, for example, the Gospel of Mark.  In addition, the Rev. Glen Prochel published a book, Good News for the Warrior Race, which presents the gospels and other selected scriptures in parallel with a "Star Trek" English paraphrase.</t:t></p>

<p>
<t:t>Lastly, the project presented here, the Klingon Language Version, is actually a relexification of the World English Bible and serves as a demonstration of what a complete Klingon Bible would look like.  A table of the most frequently occuring words (used more than 100 times) was translated, word by word, into Klingon.  This table was used to transform the WEB into Klingon. Though it is not a grammatical Klingon text (actually it is more of a pidgin-Klingon, mixing English vocabulary and grammar with Klingon) it does provide vocabulary which can be used in doing a proper Klingon translation.</t:t></p>


	<h3><t:t>The Semantic Bible</t:t></h3>
	<p><a href="http://www.semanticbible.com/hyperconc.shtml"><t:t>The Hyper-Concordance</t:t></a> <t:t>is an experiment in word-based navigation through the New Testament. Each content word is hyperlinked to a page displaying all the verses for that word, preserving context and tightly connecting the content. Sean Boisen decided to do the project in his spare time, using OSIS. We'll be adding the functionality of his hyper-concordance to The Bible Tool.</t:t></p>

<% } %>

</div>
	</tiles:put>
</tiles:insert>
