<?xml version="1.0" encoding="UTF-8" ?>
<%@ page import="java.net.URL" %>
<%@ page import="org.crosswire.sword.orb.*" %>
<%
response.setContentType("text/xml");

String requestURI = request.getRequestURI();
int pe = requestURI.lastIndexOf('/', requestURI.length()-2);
requestURI = (pe > 0) ? requestURI.substring(0, pe) : "";
URL baseURL = new URL(request.getScheme(), request.getServerName(), request.getServerPort(), requestURI);
URL appBaseURL = new URL(request.getScheme(), request.getServerName(), request.getServerPort(), "/study/");

SWMgr mgr = SwordOrb.getSWMgrInstance(request);

%>
<Module>
  <ModulePrefs
	title="Bible Viewer"
	author_email="scribe777@gmail.com"
	author="CrossWire"
	description="Bible Viewer"
	screenshot="http://crosswire.org/images/crosswire.gif"
	thumbnail="http://crosswire.org/images/crosswire.gif"
	scrolling="true"
   >
  <Optional feature="dynamic-height"/>
  <Optional feature="pubsub-2">
  <Param name="topics">
    <![CDATA[ 
    <Topic title="Manuscript Selection" name="interedition.page.selected"
            description="Select a Manuscript" type="string" subscribe="true"/>
	
    ]]>
  </Param>
</Optional>
</ModulePrefs>
<UserPref name="swordModule" datatype="enum" display_name="Bible Text" default_value="WHNU">
<%
	ModInfo[] modInfo = mgr.getModInfoList();
	for (int i = 0; i < modInfo.length; i++) {
		if (SwordOrb.BIBLES.equals(modInfo[i].category)) {
			SWModule book = mgr.getModuleByName(modInfo[i].name);
%><EnumValue value="<%= modInfo[i].name %>" display_value="[<%= modInfo[i].name %>]"/>
<%
		}
	}
%>
</UserPref>
<Content type="html">
<![CDATA[
<head>
<!--
        <link rel="stylesheet" type="text/css" href="../../js/jquery-ui/jquery-ui-1.8.16.css">
        <script type="text/javascript" src="../../js/jquery/jquery-1.6.4.min.js"></script>
        <script type="text/javascript" src="../../js/jquery-ui/jquery-ui-1.8.16.min.js"></script>
-->
        <link rel="stylesheet" type="text/css" href="<%=baseURL%>/sandy.css">
        <link rel="stylesheet" type="text/css" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/themes/base/jquery-ui.css">
        <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.3/jquery.min.js"></script>
        <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/jquery-ui.min.js"></script>

<script type="text/javascript">
        $(document).ready(function() {

		$( "#tabs" ).tabs();

        });
</script>
</head>

<body>
<div id="tabs">
	<ul>
		<li><a href="#tabs-1">Chapter</a></li>
		<li><a href="#tabs-2">Search</a></li>
	</ul>

	<div id="tabs-1">
		<div>
			Quick Lookup: <input name="verseRef" style="width:100%" id="verseRef" onKeyPress="return lookup(this.value);"/><span id="currentVerse" style="float:right;display:inline-block;"></span>
			<div style="clear:both;"></div>
		</div>
		<div id="chapterContent">
		</div>
	</div>

	<div id="tabs-2">
		<div>
			Search Text: <input name="searchText" style="width:100%" id="searchText" onKeyPress="return search(this.value);"/><span id="searchResultsCount" style="float:right;display:inline-block;"></span>
			<div style="clear:both;"></div>
		</div>
		<div id="searchContent">
		</div>
	</div>
</div>
</body>

<script>

var swordModule = "WHNU";

function search_callback(o) {
	var results = o.text.split('%%%');
	content = document.getElementById('searchResultsCount');
	content.innerHTML = '';
	content.innerHTML = results[0];
	content = document.getElementById('searchContent');
	content.innerHTML = '';
	content.innerHTML = results[1];
}

function lookup_callback(o) {
	var results = o.text.split('%%%');
	content = document.getElementById('currentVerse');
	content.innerHTML = '';
	content.innerHTML = results[0];
	$('#verseRef').val(results[0]);
	content = document.getElementById('chapterContent');
	content.innerHTML = '';
	content.innerHTML = results[1];

	var new_position = $('#cv').offset();
	window.scrollTo(new_position.left,new_position.top);
}

function lookup(verse) {
	$('#tabs').tabs('select', 0);
	result = document.getElementById('chapterContent');
	result.innerHTML = '<center><image src="<%=baseURL%>/images/loading.gif"/></center><br/><center><h1>Loading.  Please wait...</h1></center>';

	var params = {};
	var postData = {};
	postData.mod=swordModule;
	postData.key=verse;
	params[gadgets.io.RequestParameters.METHOD] = gadgets.io.MethodType.POST;
	params[gadgets.io.RequestParameters.POST_DATA] = gadgets.io.encodeValues(postData);
	var url = "<%=baseURL%>/simplelookup.jsp";
	gadgets.io.makeRequest(url, lookup_callback, params);
};

function search(searchText) {
	$('#tabs').tabs('select', 1);
	result = document.getElementById('searchContent');
	result.innerHTML = '<center><image src="<%=baseURL%>/images/loading.gif"/></center><br/><center><h1>Loading.  Please wait...</h1></center>';

	var params = {};
	var postData = {};
	postData.mod=swordModule;
	postData.searchTerm=searchText;
	params[gadgets.io.RequestParameters.METHOD] = gadgets.io.MethodType.POST;
	params[gadgets.io.RequestParameters.POST_DATA] = gadgets.io.encodeValues(postData);
	var url = "<%=baseURL%>/simplesearch.jsp";
	gadgets.io.makeRequest(url, search_callback, params);
};

function getURLParams() {
    var vars = [], hash;
    var hashes = parent.window.location.href.slice(parent.window.location.href.indexOf('?') + 1).split('&');
    for(var i = 0; i < hashes.length; i++) {
        hash = hashes[i].split('=');
        vars.push(hash[0]);
        vars[hash[0]] = hash[1];
    }
    return vars;
}


function positionFromURLParams() {
	var mod = getURLParams()['mod'];
	if (mod != null) {
		swordModule = mod;
	}
	var key = getURLParams()['key'];
	if (key != null) {
		lookup(key);
	}
}

function page_select_callback(topic, data, subscriberData) {
	if (data.bibcont != null) {
		lookup(data.bibcont);
	}
}

function loaded() {
	var prefs = new gadgets.Prefs();
	swordModule = prefs.getString('swordModule');
	subId = gadgets.Hub.subscribe("interedition.page.selected", page_select_callback);
	gadgets.window.adjustHeight(500);
	positionFromURLParams();
}

if (gadgets.util.hasFeature('pubsub-2')) {
	gadgets.HubSettings.onConnect = function(hum, suc, err) { loaded(); };
}
else gadgets.util.registerOnLoadHandler(loaded);

</script>

]]>
</Content>
</Module>


