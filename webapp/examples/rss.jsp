<?xml version="1.0" ?>
<%@ page
    language="java"
    contentType="text/xml;charset=utf-8"
%>
<%@ page import="org.crosswire.sword.orb.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%
	final String modName = "losung_de_2009";
	response.setContentType("text/xml");
	SWMgr mgr = SwordOrb.getSWMgrInstance(request);
	SWModule book = mgr.getModuleByName(modName);
	SimpleDateFormat formatter = new SimpleDateFormat("MM.dd");
	SimpleDateFormat formatNice = new SimpleDateFormat("EEEE, MMM dd");
	book.setKeyText(formatter.format(new Date()));
%>
<rss version="2.0"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:sy="http://purl.org/rss/1.0/modules/syndication/"
	xmlns:admin="http://webns.net/mvcb/"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:content="http://purl.org/rss/1.0/modules/content/">
<channel>
    <title>CrossWire's Daily Devotion</title>
    <description> Daily devotional from <%=book.getDescription()%>. </description>
    <link> http://crosswire.org </link>
    <dc:date> <%= new Date() %> </dc:date>
    <dc:language>en-us</dc:language>
    <dc:creator>crosswire.org</dc:creator>
    <dc:rights> Copyright 2007, CrossWire Bible Society.</dc:rights>
    <ttl>1</ttl>
    <webMaster> webmaster@crosswire.org </webMaster>
    <managingEditor> webmaster@crosswire.org </managingEditor>
    <category> Christian Devotional </category>
    <item>
        <title>Today's Devotion (<%= formatNice.format(new Date()) %>)</title>
        <description>Devotion of The Day</description>
        <link> http://crosswire.org/study/dailydevotion.jsp?mod=<%=modName%></link>
        <content:encoded>
<![CDATA[ 

<img src="http://crosswire.org/images/crosssquare.png"/>
<%= book.getRenderText() %>

]]>
        </content:encoded>	
        <dc:rights>Powered by CrossWire.org</dc:rights>
        <dc:date> <%= new Date() %> </dc:date>
    </item>
</channel>
</rss>




