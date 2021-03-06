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
	scrolling="false"
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
<UserPref name="height" datatype="enum" display_name="Gadget Height" default_value="600">
     <EnumValue value="220" display_value="Short"/>
     <EnumValue value="300" display_value="Medium"/>
     <EnumValue value="400" display_value="Tall"/>
     <EnumValue value="600" display_value="Very Tall"/>
     <EnumValue value="-1" display_value="Dynamic"/>
</UserPref>

<UserPref name="swordModule" datatype="enum" display_name="Bible Text" default_value="WHNU">
<%
	ModInfo[] modInfo = mgr.getModInfoList();
	for (int i = 0; i < modInfo.length; i++) {
		if (SwordOrb.BIBLES.equals(modInfo[i].category)) {
			SWModule book = mgr.getModuleByName(modInfo[i].name);
%><EnumValue value="<%= modInfo[i].name %>" display_value="<%= modInfo[i].name %>"/>
<%
		}
	}
%>
</UserPref>
<UserPref name="autoSelectMod" datatype="bool" display_name="Auto Select Bible from Last Manuscript Language" default_value="false" />
<Content type="html">
<![CDATA[
<head>
        <link rel="stylesheet" type="text/css" href="<%=baseURL%>/sandy.css">
        <link rel="stylesheet" type="text/css" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/themes/base/jquery-ui.css">
        <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.3/jquery.min.js"></script>
        <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/jquery-ui.min.js"></script>
	

<script type="text/javascript">
var tabLabel = '';
var specialModules = {
     bo  : "SahidicBible",
     sa  : "SahidicBible",
     fa  : "SahidicBible",
     mae : "SahidicBible",
     ly  : "SahidicBible",
     cw  : "SahidicBible"
};

        $(document).ready(function() {

		$( "#tabs" ).tabs();

        });
</script>
<style>

@font-face {
    font-family: 'AntinoouWeb';
    src: url('fonts/antinoou-webfont.eot');
    src: url('fonts/antinoou-webfont.eot?#iefix') format('embedded-opentype'),
         url('fonts/antinoou-webfont.woff') format('woff'),
         url('fonts/antinoou-webfont.ttf') format('truetype');
    font-weight: normal;
    font-style: normal;
}


.currentWord {
	color : red;
	cursor : pointer;
}


.currentSelectedWord {
	color : blue;
	cursor : pointer;
}

.ui-tabs .ui-tabs-nav li a {
	padding: .1em .2em !important;
}


</style>
</head>

<body>
<div id="tabs">
	<ul>
		<li><a href="#tabs-1">Chapter</a></li>
		<li><a href="#tabs-2">Search</a></li>
	</ul>

	<div id="tabs-1" style="padding:.2em .3em;">
		<div style="width:100%;">
			<div style="float:left;margin-top:.2em;">Quick Lookup: &nbsp; </div>
			<div style="overflow:hidden;"><input name="verseRef" style="width:100%;" id="verseRef" placeholder="Type a verse; e.g., jn.3.3" onKeyPress="return keyPress('verseRef', event);"/></div>
			<span id="currentVerse" style="float:right;display:inline-block;"></span>
			<div style="clear:both;"></div>
		</div>
		<div style="overflow:auto; border: none 0px; width:100%;" class="fillPage" id="chapterContent">
		</div>
	</div>

	<div id="tabs-2" style="padding:.2em .3em;">
		<div>
			Search Text: <input name="searchText" style="width:100%" id="searchText" onKeyPress="return keyPress('searchText', event);"/><span id="searchResultsCount" style="float:right;display:inline-block;"></span>
			<div style="clear:both;"></div>
		</div>
		<div style="overflow:auto; border: none 0px; width:100%;" class="fillPage" id="searchContent">
		</div>
	</div>
</div>
</body>

<script>

var swordModule = "WHNU";
var chosenModule = swordModule;
var autoSelectMod = false;
var MARGIN = 8;
var preferredHeight = -1;

function keyPress(field, event) {
	var i = document.getElementById(field);
	var keycode;
	if (window.event) keycode = window.event.keyCode;
	else if (event) keycode = event.which;
	else return true;

	if (keycode == 13) {
		if (field == 'verseRef') lookup(i.value);
	   	else search(i.value);
		return false;
	}
	else return true;
}


function search_callback(o) {
	var results = o.text.split('%%%');
	clearExpandFillPageClients();
	$('#searchResultsCount').html(results[0]);
	$('#searchContent').html(results[1]);
	if (gadgets.util.hasFeature('dynamic-height') && preferredHeight == -1) gadgets.window.adjustHeight();
	setTimeout(function() {
		if (gadgets.util.hasFeature('dynamic-height') && preferredHeight == -1) gadgets.window.adjustHeight();
		expandFillPageClients();
	}, 100);

}


function addSpansIfNecessary() {
	if ($('.currentverse').find('span').length < 2) {
		var text = $('.currentverse:last').html();
		var words = text.split(' ');
		text = '';
		for (var i = 0; i < words.length; ++i) {
			text += '<span>'+words[i]+'</span> ';
		}
		$('.currentverse:last').html(text);
		$('.currentverse > span').css('font-family','AntinoouWeb');
	}
}


function lookup_callback(o) {
	var results = o.text.split('%%%');
	clearExpandFillPageClients();
	$('#currentVerse').html(results[0]);
	$('#verseRef').val(results[0]);
	$('#chapterContent').html(results[1]);
	if (tabLabel == 'SahidicBible') {
		$('#chapterContent').css('font-family','AntinoouWeb');
	}

	addSpansIfNecessary();

	if (gadgets.util.hasFeature('dynamic-height') && preferredHeight == -1) gadgets.window.adjustHeight();
	setTimeout(function() {
		if (gadgets.util.hasFeature('dynamic-height') && preferredHeight == -1) gadgets.window.adjustHeight();
		expandFillPageClients();
		var new_position = $('#cv').offset();

		if (new_position) {
			// for some reason, offset() and position() don't take into account that we have a div above for quick lookup
			$('#chapterContent').scrollTop(new_position.top-$('#chapterContent').offset().top + $($('#chapterContent').parent().children()[0]).height());
		}
		var data = { 
			module  : swordModule,
			key     : results[0]
		};
		if (gadgets.util.hasFeature('pubsub-2')) gadgets.Hub.publish("interedition.biblicalcontent.selected", results[0]);
		if (gadgets.util.hasFeature('pubsub-2')) gadgets.Hub.publish("interedition.biblicalcontent.selectedEx", data);
	}, 100);

}

function lookup(verse) {
	$('#tabs').tabs('select', 0);
	result = document.getElementById('chapterContent');
	result.innerHTML = '<center><image src="<%=baseURL%>/images/loading.gif"/></center><center><h3>Loading.  Please wait...</h3></center>';

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
	result.innerHTML = '<center><image src="<%=baseURL%>/images/loading.gif"/></center><center><h3>Loading.  Please wait...</h3></center>';

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
		chosenModule = mod;
	}
	var key = getURLParams()['key'];
	if (!key) key = getURLParams()['biblicalContent'];
	if (!key) key = getURLParams()['indexContent'];
	if (!key) key = getURLParams()['verse'];
	if (key != null) {
		lookup(key);
	}
}

function page_select_callback(topic, data, subscriberData) {
	if (autoSelectMod) {
		if (data.lang in specialModules)
			swordModule = specialModules[data.lang];
		else swordModule = chosenModule;
	}
	if (data.indexContent != null && data.indexContent.length > 0) {
		lookup(data.indexContent);
	}
}


function word_hover_callback(topic, data, subscriberData) {
	$('.currentverse').find('span').removeClass('currentWord');
	for (var i = 0; i < data.wordNum.length; ++i) {
		var spanNum = data.wordNum[i] + 1; // for versenum span
		if (data.wordNum[i] > -1 && $('.currentverse').find('span').length > spanNum) {
			$($('.currentverse').find('span')[spanNum]).addClass('currentWord');
		}
	};
}


function findWordSpan(wordID) {
	var found = false;
	$('span').each(function() {
		var p = this.getAttribute('onclick');
		if (p && p.indexOf('p(') == 0) {
			if (p.indexOf("'"+wordID+"'") > -1) {
				found = $(this);
				return false;
			}
		}
	});
	return found;
}


var lastWordData = {};
function p(mod, key, word, morph, noop, thisMod) {
	var data = {
		strongNum : key,
		wordID : word,
		morph : morph,
		fromMod : swordModule
	};
	lastWordData = data;
	$('span').removeClass('currentSelectedWord');
	$(findWordSpan(word)).addClass('currentSelectedWord');
	if (gadgets.util.hasFeature('pubsub-2')) gadgets.Hub.publish("interedition.word.selected", data);
}


function word_selected_callback(topic, data, subscriberData) {

	// assert we're not hearing an echo
	if (data.fromMod && data.fromMod == swordModule && data.wordID == lastWordData.wordID) return;

	for (var i = 0; i < data.wordNum.length; ++i) {
		var spanNum = data.wordNum[i] + 1; // for versenum span
		if (data.wordNum[i] > -1 && $('.currentverse').find('span').length > spanNum) {
			$($('.currentverse').find('span')[spanNum]).trigger('click');
			break;
		}
	};
}


function loaded() {
	var prefs = new gadgets.Prefs();
	swordModule = prefs.getString('swordModule');
	autoSelectMod = prefs.getBool('autoSelectMod');
	chosenModule = swordModule;
     preferredHeight = parseInt(prefs.getString('height'));
     if (gadgets.util.hasFeature('dynamic-height')) gadgets.window.adjustHeight(preferredHeight == -1 ? 500 : preferredHeight);
     $('#searchContent').css('overflow', (gadgets.util.hasFeature('dynamic-height') && preferredHeight == -1) ? 'visible' : 'auto');
     $('#chapterContent').css('overflow', (gadgets.util.hasFeature('dynamic-height') && preferredHeight == -1) ? 'visible' : 'auto');

	positionFromURLParams();
	$(window).resize(function() {
		clearExpandFillPageClients();
		expandFillPageClients();
	});

	tabLabel = (swordModule == 'WHNU') ? 'NA28' : swordModule;
	var tab = $("#tabs").find(".ui-tabs-nav li:eq(0)").children('a').text(tabLabel);
	if (tabLabel == 'SahidicBible') {
		$('#searchText').css('font-family','AntinoouWeb');
	}
}

if (gadgets.util.hasFeature('pubsub-2')) {
	gadgets.HubSettings.onConnect = function(hum, suc, err) {
		subId = gadgets.Hub.subscribe("interedition.page.selected", page_select_callback);
		subId = gadgets.Hub.subscribe("interedition.word.hover", word_hover_callback);
		subId = gadgets.Hub.subscribe("interedition.word.selected", word_selected_callback);
		loaded();
	};
}
else gadgets.util.registerOnLoadHandler(loaded);

function clearExpandFillPageClients() {
     $('.fillPage').each(function () {
          $(this).css('height', '');
     });
}
function expandFillPageClients() {
     $('.fillPage').each(function () {
          $(this).height(gadgets.window.getViewportDimensions().height - $(this).offset().top - MARGIN);
     });
}


</script>

]]>
</Content>
</Module>


