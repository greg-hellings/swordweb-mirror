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

var lastword = "";

function p(mod, key, wordnum, extratext) {

	/* check for aliases */
	if (mod == "G") mod = "StrongsGreek";
	if (mod == "H") mod = "StrongsHebrew";

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
			if ((wordnum == lastword) && (b.style.visibility == "visible")) {
				showhide("onlywlayer", "hidden");
			}
			else {
				showhide("onlywlayer", "visible");
			}
			lastword = wordnum;
		}
	}
	xmlhttp.send(null)
}


function openref(url) {
		stevec++;
		var ime = "okno" + stevec;
		var   opcije = "width=600,height=400,toolbar=0,location=0,directories=0,status=0,menuBar=0,scrollBars=1,resizable=1,dependent=true,alwaysRaised=true,titlebar=false,z-lock=true";
//		alert ("Odprl bom okno" + ime);
		if(document.layers || document.all || navigator.userAgent.indexOf("Mozilla/5")!=-1)
				window.open(url + "&nobar=1&t=1",ime, opcije);
}

function getObject(field) {
	var ret  = false;
	eval ("ret = window.document.biblija." + field + ";");
	return ret;
}


function setValue(field, content){
	var ret  = getObject (field);
	if (ret)
		ret.value = content;
	else
		alert ("Your browser is old and has no so called 'Document Object Model' required by BIBLIJA.net.\nPlease upgrade it to some newer version to use it with BIBLIJA.net!");
	return ret;
}


function mygoto (field, content){
	var ret  = setValue (field, content);
	if (ret)
		document.biblija.submit();
}


function validate()
{
  var result = 1;
  window.document.biblija.qids.value = "";
  for (var i = 0; i<window.document.ids.elements.length;i++){
	var e = window.document.ids.elements[i];
	if (e.value >= 256 ){
		if (result>=128){
			window.document.biblija.qids.value = window.document.biblija.qids.value + result.toString(16);
			result=1;
		}
		result *=2;
		result += e.checked ? 1 : 0;
	};
  }
  if (result!=2)
	window.document.biblija.qids.value = window.document.biblija.qids.value + result.toString(16);
  window.document.biblija.qall.value = window.document.ids.qall.checked ? 1 : 0;
  return (true);
}


  function izberi(id, level)
  {
	var myref;
	var mycnt = 0;
	for (var i = 0; i<window.document.ids.elements.length;i++)
		if (window.document.ids.elements[i].value % 256 == id){
			myref=window.document.ids.elements[i];
			mycnt = i;
		}
		 var  koncaj = false;
	for (var i=mycnt+1;!koncaj;)
    {
		var e = window.document.ids.elements[i];
		if (e.value / 256 > level + 1 )
			e.checked = myref.checked;
		else
			koncaj=1;
		i++;
    if (i==window.document.ids.elements.length)
		koncaj=true;
    }
  }

  function izberi2(id, level)
  {
	var myref;
	var mycnt = 0;
	var total = window.document.ids.length;
	for (var i = 0; i<total;i++){
			// value: zgornji byte le level, spodnji id
			if (window.document.ids.elements[i].value % 256  == id){
				myref=window.document.ids.elements[i];
				mycnt = i;
			}
	}
	var	koncaj = false;
	if (myref.checked)
		  myref.checked = false;
	 else
		 myref.checked = true;
	 izberi(id,level);

  }

  function revert(id)
  {
    myref=window.document.ids.elements[id];
   if (myref.checked)
	myref.checked = false;
   else
	myref.checked = true;
  }


  function izberivse(change)
 {
	if (change )
		if (window.document.ids.qall.checked)
			window.document.ids.qall.checked = false;
		else
			window.document.ids.qall.checked = true;

	for (var i=0;i<window.document.ids.elements.length;i++)
		window.document.ids.elements[i].checked = window.document.ids.qall.checked;
}



////////// funkcije za Layerje - opombe
////////// naredi jih še za Netscape



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


function note (layer,image){
  var graphic1 = 'opomba.gif';
  var graphic2 = 'opomba2.gif';

  showhide(layer);
}


function wordInfo (layer,image){
  var graphic1 = 'ref.gif';
  var graphic2 = 'ref2.gif';

  showhide(layer);
}


function showhide (layer, vis) {
//	if(document.layers || document.all || navigator.userAgent.indexOf("Mozilla/5")!=-1)
//	alert ("stanje od " + num + ": " + document.all[num].style.visibility + ", kaj= " + kaj);

	// to ne sme biti na zaèetku, ker mora biti body že naložen, kar na zaèetku še ni
	winW = isNS4 ? window.innerWidth-16 : document.body.offsetWidth-20;
	winH = isNS4 ? window.innerHeight : document.body.offsetHeight;
//	if (!document.all)
//		return;
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


function wapme(){
	if(document.layers || document.all || navigator.userAgent.indexOf("Mozilla/5")!=-1)
		wapwindow = window.open('http://gelon.net/cgi-bin/wapalizenokia6210.cgi?url=http://wap.biblija.net','nokia6210','width=200,height=430,toolbar=0,location=0,directories=0,status=0,menuBar=0,scrollBars=0,resizable=0');
	else
		alert('Žal!\nNepoznan brkljalnik...\n.');
}

function popup(lang){
	var url = '/translations.' + lang + '.html';
	if(document.layers || document.all || navigator.userAgent.indexOf("Mozilla/5")!=-1)
		infowindow = window.open(url,'infowindow','width=500,height=550,toolbar=0,location=0,directories=0,status=0,menuBar=0,scrollBars=1,resizable=1');
	else
		alert('Žal!\nNepoznan brkljalnik...\n.');
}


