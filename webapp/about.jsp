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


 <h2><t:t>Frequently Asked Questions</t:t></h2>
  <ul>
    <li><t:t>GENERAL QUESTIONS</t:t>
      <ul>
        <li><a href="#faq_1"><t:t>Who is behind the Bible Tool? Why are you wearing that wig?</t:t></a></li>
        <li><a href="#faq_2"><t:t>What makes the Bible Tool different from other Bible search tools?</t:t></a></li>
        <li><a href="#faq_3"><t:t>What is this OSIS you speak of?</t:t></a></li>
      </ul>
    </li>
    <li>
      <t:t>USING THE BIBLE TOOL</t:t>
      <ul>
        <li><a href="#faq_4"><t:t>What is Passage Study?</t:t></a></li>
        <li><a href="#faq_5"><t:t>What is Word Study?</t:t></a></li>
        <li><a href="#faq_6"><t:t>What are Strong&rsquo;s Numbers?</t:t></a></li>
        <li><a href="#faq_7"><t:t>What is &ldquo;Show Morphology&rdquo;?</t:t></a></li>
        <li><a href="#faq_8"><t:t>What is Parallel Study?</t:t></a></li>
        <li><a href="#faq_9"><t:t>What is Power Search?</t:t></a></li>
        <li><a href="#faq_10"><t:t>What can I do with Preferences?</t:t></a></li>
        <li><a href="#faq_11"><t:t>What does &ldquo;Printer Friendly&rdquo; mean?</t:t></a></li>
      </ul>
    </li>
    <li>
      <t:t>GETTING FREE BIBLE SOFTWARE</t:t> 
      <ul>
        <li><a href="#faq_12"><t:t>Is the Bible Tool available on CD?</t:t></a></li>
        <li><a href="#faq_13"><t:t>Can I download Bible Tool Bibles and other content?</t:t></a></li>
      </ul>
    </li>
    <li>
      <t:t>APPROPRIATE USE AND PERMISSIONS</t:t> 
      <ul>
        <li><a href="#faq_14"><t:t>Can I modify the Bible Tool to make it better fit on my own site?</t:t></a></li>
      </ul>
    </li>
    <li>
      <t:t>BIBLE VERSIONS AND TRANSLATIONS</t:t> 
      <ul>
        <li><a href="#faq_15"><t:t>Why are there so many versions of the Bible &ndash; are some better than others?</t:t></a></li>
        <li><a href="#faq_16"><t:t>How can I get a printed edition of the Bible?</t:t></a></li>
        <li><a href="#faq_17"><t:t>How do I get printed copies of the Bible in different languages?</t:t></a></li>
      </ul>
    </li>
    <li>
      <t:t>BIBLICAL QUESTIONS</t:t> 
      <ul>
        <li><a href="#faq_18"><t:t>Are verses missing?</t:t></a></li>
      </ul>
    </li>
  </ul>
  <h3><t:t>GENERAL QUESTIONS</t:t></h3>
  <p class="q" id="faq_1"><t:t>Who is behind the Bible Tool? Why are you wearing that wig?</t:t></p>
  <p class="a"><t:t>The technology was developed by </t:t><a href="http://crosswire.org/"  title="CrossWire Bible Society"><t:t>CrossWire Bible Society</t:t></a>. <t:t>The software is a combined project of the </t:t><a href="http://www.americanbible.org/" title="American Bible Society"><t:t>American Bible Society</t:t></a> <t:t>and</t:t> <a href="http://sbl-site.org/" title="Society of Biblical Literature"><t:t>Society of Biblical Literature</t:t></a>.</p>
  <p class="q" id="faq_2"><t:t>What makes the Bible Tool different from other Bible search tools?</t:t></p>
  <p><t:t>The Bible Tool is part of a larger initiative co-sponsored by ABS and the SBL to allow people to approach the Bible on their terms, in the culture, community, context, media and format of their choice. This tool will evolve in the coming months / years to help us reach that goal.</t:t></p>
  <p><t:t>This means we will strive to enable you, the user, to have the look / feel you want, the functionality you want, the texts you want (by adding popular ones and allowing you to upload your own) in the format you want (initially electronic or print). Because the tool is open source, if you have some technical skills you are free to download the tool and make changes as you see fit.</t:t></p>
  <p><t:t>OSIS is a key technical piece that will allow this to happen. Other key pieces include partnerships between organizations like SBL and ABS (to insure large distribution channels), and good content, such as making modern translations and helpful related materials available. That will be a big focus in the coming months.</t:t></p>
  <p class="q" id="faq_3"><t:t>What is this OSIS you speak of?</t:t></p>
  <p><t:t>The Open Scriptural Information Standard (OSIS) is an XML schema for encoding Bibles and related text. Once in OSIS, you can do lots of cool things, like publish the info as a printed book, or PDF, or HTML, or WML for viewing on a cell phone, etc. You can learn more by visiting the </t:t><a href="http://bibletechnologies.net/"><t:t>OSIS website</t:t></a>.</p>
  <p><t:t>What, you&rsquo;re not there yet?</t:t></p>
  <h3><t:t>USING THE BIBLE TOOL</t:t></h3>
  <p class="q" id="faq_4"><t:t>What is passage study?</t:t></p>
  <p><t:t>Passage study allows you to search by keyword (for example, Pharaoh), phrase (such as Ark of the Covenant), verse (like Genesis 1:1) or passage (John 3).</t:t></p>
  <p><t:t>Once the text you&rsquo;re looking to study appears on the screen, you have several options. You can navigate within the text by selecting previous chapter or next chapter. Keep in mind that when you&rsquo;re at the beginning of a book of the Bible, previous chapter will take you to last chapter of the previous book. The same holds true when you select next chapter on the last chapter of a book of the Bible.</t:t></p>
  <p class="q" id="faq_5"><t:t>What is Word Study?</t:t></p>
  <p><t:t>Word study allows you to focus more on the meaning of a particular word within the text. One way to do that is by using Strong&rsquo;s Numbers and reviewing the Morphology of the word.</t:t></p>
  <p class="q" id="faq_6"><t:t>What are Strong&rsquo;s Numbers?</t:t></p>
  <p><t:t>Strong's Numbers are numbers given to words in the Bible by Dr. James Strong for his Exhaustive Concordance, first published in 1890. With the advent of handheld computers, using Strong&rsquo;s numbers has never been easier. By looking up the corresponding number, you can obtain the following information about words in the Bible:</t:t></p>
  <ul>
    <li><t:t>The original Greek or Hebrew word</t:t></li>
    <li><t:t>The pronunciation of the original word</t:t></li>
    <li><t:t>The definition of the original word</t:t></li>
    <li><t:t>References to other appearances of the word in the Bible</t:t></li>
  </ul>
  <p><t:t>Using Strong's Numbers, you can easily find other appearances of a word, or the location of a phrase if you know parts of the phrase but not its exact location in the Bible.</t:t></p>
  <p class="q" id="faq_7"><t:t>What is &ldquo;Show Morphology&rdquo;?</t:t></p>
  <p><t:t>Morphology is the information about the language parsing of a word, such as the tense, voice or mood. You can click on the morph codes following the words to view the parsing of that word</t:t></p>
  <p class="q" id="faq_8"><t:t>What is parallel study?</t:t></p>
  <p><t:t>Parallel study lets you view texts side by side. You can continue view several texts at the same time, although space becomes an issue at some point depending on the texts being viewed.</t:t></p>
  <p><t:t>The texts can be printed in a printer-friendly way, without including all the other information on the page. You can produce a diglot by printing two Bible translations side by side. Additional translations would produce a polyglot. We hope to allow you to edit the formatting of your diglot or polyglot scripture portion in the future (hopefully early Spring).</t:t></p>
  <p class="q" id="faq_9"><t:t>What is power search?</t:t></p>
  <p><t:t>Power search allows you to expand on the basic passage search functionality. This includes searching by sentence fragments, or exact phrase. You can also use whatever syntax you like in limiting your search range to specific sections, such as in Revelations chapters 1-5.</t:t></p>
  <p class="q" id="faq_10"><t:t>What can I do with preferences?</t:t></p>
  <p><t:t>A number of things. You can select preferred Bible translations and other texts, so that your search or study only references your preferred selections. You can also add / remove tabs at the top, depending on texts or functionality that you like or perhaps don&rsquo;t use. You can also choose the tool&rsquo;s skin. Our goal is to give you as many preferences as possible, and we&rsquo;ll be adding more in the coming months.</t:t></p>
  <p class="q" id="faq_11"><t:t>What does &ldquo;printer friendly&rdquo; mean?</t:t></p>
  <p><t:t>This allows you to print the results of your study directly to your printer, without including the tabs on the top and tools/texts in the margins as part of your printout.</t:t></p>
  <h3><t:t>GETTING FREE BIBLE SOFTWARE</t:t></h3>
  <p class="q" id="faq_12"><t:t>Is the Bible Tool available on CD?</t:t></p>
  <p><t:t>You can get CrossWire SWORD software, on which this tool was built, by getting in touch with </t:t><a href="http://www.crosswire.org/">www.crosswire.org</a>. <t:t>However, it&rsquo;s easier to just download the software from the website.</t:t></p>
  <p class="q" id="faq_13"><t:t>Can I download Bible Tool Bibles and other content?</t:t></p>
  <p><t:t>You can download a number of Bibles freely at </t:t><a href="http://www.crosswire.org/">www.crosswire.org</a> <t:t>if you download the SWORD tool. As we add modern translations to the tool, some restrictions determined by the organizations that hold the license for the content will apply. You can copy some Biblical material from the online Bibles, as long as you follow copyright restrictions.</t:t></p>
  <h3><t:t>APPROPRIATE USE AND PERMISSIONS</t:t></h3>
  <p class="q" id="faq_14"><t:t>Can I modify the Bible Tool to make it better fit on my own site?</t:t></p>
  <p><t:t>Yes. This tool was built using open source code, so feel free to use it however you like.</t:t></p>
  <h3><t:t>BIBLE VERSIONS AND TRANSLATIONS</t:t></h3>
  <p class="q" id="faq_15"><t:t>Why are there so many versions of the Bible &ndash; are some better than others?</t:t></p>
  <p><t:t>Over the years a number of Bible scholars have translated the original manuscripts to help the people of a specific time or place to better understand the Word. While the language or diction may differ, the Bibles we offer agree on major points of theology. The best versions are of course those produced by the American Bible Society&hellip; oh ok, the others are excellent too, for the most part.</t:t></p>
  <p class="q" id="faq_16"><t:t>How can I get a printed edition of the Bible?</t:t></p>
  <p>Visit <a href="http://www.bibles.com/">www.bibles.com</a>.</p>
  <p class="q" id="faq_17"><t:t>How do I get printed copies of the Bible in different languages?</t:t></p>
  <p><t:t>Visit</t:t> <a href="http://www.bibles.com/">www.bibles.com</a>, or call 1-800-322-4253.</p>
  <h3><t:t>BIBLICAL QUESTIONS</t:t></h3>
	<p class="q" id="faq_18"><t:t>Are verses missing?</t:t></p>
  <p><t:t>Yes, we took the verses we don&rsquo;t agree with out.</t:t></p>
  <p><t:t>Of course we&rsquo;re kidding. No, verses are not missing. However, some verses appear as footnotes in certain translations, because they weren&rsquo;t present in the earliest or most reliable manuscripts. To view these verses, you need to view the entire chapter or any span of verses that includes the verse directly preceding the apparent "missing" verse.</t:t></p>


</div>

	</tiles:put>
</tiles:insert>
