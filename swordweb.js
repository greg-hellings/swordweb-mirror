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
var tempX = 0
var tempY = 0

function getMouseXY(e) {
  if (isIE4) { // grab the x-y pos.s if browser is IE
    tempX = event.clientX + document.body.scrollLeft
    tempY = event.clientY + document.body.scrollTop
  } else {  // grab the x-y pos.s if browser is NS
    tempX = e.pageX
    tempY = e.pageY
  }  
  // catch possible negative values in NS4
  if (tempX < 0){tempX = 0}
  if (tempY < 0){tempY = 0}  
  return true
}

function p(mod, key, wordnum, extratext) {

	/* check for aliases */
	if (mod == "G") mod = "StrongsGreek";
	if (mod == "H") mod = "StrongsHebrew";

	if ((wordnum == lastword) && (b.style.visibility == "visible")) {
		showhide("onlywlayer", "hidden");
	}
	else {
		xmlhttp.open("GET", "fetchdata.jsp?mod="+mod+"&key="+key,true);
		xmlhttp.onreadystatechange=function() {
			if (xmlhttp.readyState==4) {
				b=document.getElementById("onlywlayer");
				if (b==null) {
					b=document.createElement("div");
					b.id="onlywlayer";
					b.className="word-layer";
					document.body.appendChild(b);
					b.style.visibility = "hidden";
				}
				b.innerHTML=xmlhttp.responseText + "<br/>"+extratext;
				showhide("onlywlayer", "visible");
				lastword = wordnum;
			}
		}
		xmlhttp.send(null)
	}
}



function showhide (layer, vis) {
	// to ne sme biti na zaèetku, ker mora biti body že naložen, kar na zaèetku še ni
	winW = isNS4 ? window.innerWidth-16 : document.body.offsetWidth-20;
	winH = isNS4 ? window.innerHeight : document.body.offsetHeight;
	var l = document.getElementById(layer);
	var cx = tempX + 10;
	var cy = tempY - 10;
	if (cx + 200 > winW)
		cx = tempX - 220;
	if (cx < 5){
		cx = 5;
		cy = cy + 20;
	}

	if (vis == "visible") {
		l.style.left = "" + cx + "px";
		l.style.top = "" + cy + "px";
	}
	l.style.visibility = vis;
}

