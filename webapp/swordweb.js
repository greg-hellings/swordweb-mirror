/*
Special thanks to Matej from Biblija.net for much of the
inspiration, ideas, and direct plagerism below.
*/

var isIE4 = false;
var isNS4 = false;

if (document!=null)
	isIE4 = (document.all ? true : false);
if (!isIE4)
	isNS4 = document.layers ? true : false;

var winW;
var winH;


var refwindow;
var stevec = 0;

var lastword = "";

var xmlhttp=false;
/*@cc_on @*/
/*@if (@_jscript_version >= 5)
// JScript gives us Conditional compilation, we can cope with old IE versions.
// and security blocked creation of the objects.
 try {
  xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
 } catch (e) {
  try {
   xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
  } catch (E) {
   xmlhttp = false;
  }
 }
@end @*/
if (!xmlhttp && typeof XMLHttpRequest!='undefined') {
  xmlhttp = new XMLHttpRequest();
}

// Detect if the browser is IE or not.
// If it is not IE, we assume that the browser is NS.

// If NS -- that is, !IE -- then set up for mouse capture
if (isNS4)
	document.captureEvents(Event.MOUSEMOVE)

// Set-up to use getMouseXY function onMouseMove
// if (isIE4)
document.onmousemove = getMouseXY;

// Temporary variables to hold mouse x-y pos.s
var mouseDocX = 0
var mouseDocY = 0
var mouseClientX = 0
var mouseClientY = 0

function getMouseXY(e) {
  if (isIE4) { // grab the x-y pos.s if browser is IE
    mouseDocX = event.clientX + document.body.scrollLeft
    mouseDocY = event.clientY + document.body.scrollTop
    mouseClientX = event.clientX;
    mouseClientY = event.clientY;
  } else {  // grab the x-y pos.s if browser is NS
    mouseDocX = e.pageX
    mouseDocY = e.pageY
    mouseClientX = e.clientX;
    mouseClientY = e.clientY;
  }  
  // catch possible negative values in NS4
  if (mouseDocX < 0){mouseDocX = 0}
  if (mouseDocY < 0){mouseDocY = 0}  
  return true
}

function changeCSS(myclass,element,value) {
	var CSSRules
	if (document.all)		  CSSRules = 'rules'
	else if (document.getElementById) CSSRules = 'cssRules'
	else return
	for (var i = 0; i < document.styleSheets.length; i++) {
		for (var j = 0; j < document.styleSheets[i][CSSRules].length; j++) {
			if (document.styleSheets[i][CSSRules][j].selectorText == myclass) {
		    	document.styleSheets[i][CSSRules][j].style[element] = value
			}
		}
	}
}


function pi(mod, key, wordnum, extratext) {
	changeCSS('.'+lastword, 'color', '');
	p(mod, key, wordnum, extratext);
	changeCSS('.'+wordnum, 'color', 'red');
}

// get lemma morph and wnum for a word
var wd_strong = '';
var wd_morph = '';
var wd_wnum = '';
function wd(mod, key, wordnum, extratext) {
	wd_strong = '';
	wd_morph = '';
	wd_wnum = '';

	if ((mod == 'G') || (mod == 'StrongsGreek')) {
		wd_strong = key;
		wd_morph = extratext;
		wd_wnum = wordnum;
	}

}

var curspans = new Array();


function pe(extratext) {
	b=document.getElementById("onlywlayer");
	if (b!=null) {
		c=document.getElementById("dm");
		if (c!=null) {
			xmlhttp.open("GET", "fetchdata.jsp?mod=Packard&key="+encodeURIComponent(extratext),true);
			xmlhttp.onreadystatechange=function() {
				if (xmlhttp.readyState==4) {
					c.innerHTML="<div class=\"verse\"><br/>"+extratext+"<br/>"+xmlhttp.responseText+"</div>";
				}
			}
			xmlhttp.send(null);
		}
	}
}

function pd(extratext) {
	b=document.getElementById("onlywlayer");
	if (b!=null) {
		c=document.getElementById("dm");
		if (c!=null) {
			xmlhttp.open("GET", "fetchdata.jsp?mod=Robinson&key="+encodeURIComponent(extratext),true);
			xmlhttp.onreadystatechange=function() {
				if (xmlhttp.readyState==4) {
					c.innerHTML="<div class=\"verse\"><br/>"+extratext+"<br/>"+xmlhttp.responseText+"</div>";
				}
			}
			xmlhttp.send(null);
		}
	}
}


function p(mod, key, wordnum, extratext, fnnum) {

	/* check for aliases */
	if (mod == "G") mod = "StrongsGreek";
	if (mod == "H") mod = "StrongsHebrew";

	b=document.getElementById("onlywlayer");
	if (b==null) {
		b=document.createElement("div");
		b.id="onlywlayer";
		b.className="word-layer";
		document.body.appendChild(b);
		b.style.visibility = "hidden";
	}

	if ((wordnum == lastword) && (b.style.visibility == "visible")) {
		showhide("onlywlayer", "hidden");
	}
	else {
		b.innerHTML="Please wait...";
		showhide("onlywlayer", "visible");
		url = "fetchdata.jsp?mod="+mod+"&key="+encodeURIComponent(key);
		if (fnnum != null)
			url += "&fn="+encodeURIComponent(fnnum);
		xmlhttp.open("GET", url, true);
		xmlhttp.onreadystatechange=function() {
			if (xmlhttp.readyState==4) {
				if (mod != "betacode") {
					resultBody="<div class=\"verse\">"+xmlhttp.responseText + "<br/>"+"<div id=\"dm\">";
					if ((extratext != null) && (extratext.length > 0)) {
						resultBody += "<a href=\"#\" onclick=\"pd('"+extratext+"');return false;\">"+extratext+"</a></div></div>";
					}
					b.innerHTML=resultBody;
				}
				else {
					resultBody ="<div class=\"verse\">"+xmlhttp.responseText + "<br/>"+"<div id=\"dm\">";
					if ((extratext != null) && (extratext.length > 0)) {
						resultBody += "<a href=\"#\" onclick=\"pe('"+extratext+"');return false;\">"+extratext+"</a></div></div>";
					}
					b.innerHTML=resultBody;
				}
				lastword = wordnum;
			}
		}
		xmlhttp.send(null);
		if (mod.substring(0,12) == 'StrongsGreek') {
			spans = document.getElementsByTagName('span');
			for (i = 0; i < curspans.length; i++) {
				curspans[i].className='';
			}
			curspans.length = 0;
			for (i = 0; i < spans.length; i++) {
				ocf = spans[i].getAttribute('onclick');
				if (ocf) {
					oc = ocf.toString();
					fb = oc.indexOf('p(');
					if (fb >= 0) {
						fe = oc.indexOf(')', fb);
						wdf = 'wd'+oc.substring(fb+1, fe+1);
						wdata = eval(wdf);
						if (wd_wnum == wordnum) {
							curspans[curspans.length] = spans[i];
							spans[i].className='curWord';
						}
						else if (wd_strong == key) {
							if (wd_morph == extratext) {
								curspans[curspans.length] = spans[i];
								spans[i].className='sameLemmaMorph';
							}
							else { curspans[curspans.length] = spans[i];
								spans[i].className='sameLemma';
							}
						}
					}
				}
			}
		}
	}
}

function f(mod, key, fnnum, extratext) {
	p(mod, key, 'fn'+key+fnnum, extratext, fnnum);
}

function showhide (layer, vis) {

	var l = document.getElementById(layer);
	if (vis == "visible") {
		winW = isNS4 ? window.innerWidth-16 : document.body.offsetWidth-20;
		winH = (window.innerHeight) ? window.innerHeight : document.body.offsetHeight;
		var cx = mouseDocX + 10;
		var cy = mouseDocY - 10;
		if (cx + 200 > winW)
			cx = mouseDocX - 220;
		if (cx < 5){
			cx = 5;
			cy = cy + 20;
		}

//		alert('winH:'+winH+'mouseClientY:'+mouseClientY);
		// adjust for above or below verse
		if (mouseClientY < (winH/2))
			cy = cy + 50;
		else cy = cy - (l.clientHeight + 50);

		l.style.left = "" + cx + "px";
		l.style.top = "" + cy + "px";
	}
	
	l.style.visibility = vis;
}

