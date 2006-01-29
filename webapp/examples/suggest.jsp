<%@ page
    language="java"
    contentType="text/html;charset=utf-8"
%>
<%@ page import="org.crosswire.sword.orb.*" %>
<%
        SWMgr mgr     = SwordOrb.getSWMgrInstance(session);
        String mod    = request.getParameter("mod");
        String key    = request.getParameter("key");
	if (key != null) key = new String(key.getBytes("UTF-8"), "iso8859-1");
        String action = request.getParameter("action");
        if ("keyList".equals(action)) {
                String retVal = "<ul>";
                if (mod != null && key != null)  {
                        SWModule book = mgr.getModuleByName(mod);
                        book.setKeyText(key);
                        book.getRenderText();
                        String currentKey = book.getKeyText();
                        for (int i = 0; ((i < 10) && (book.error() == 0)); i++) {
                                book.previous();
                        }
                        for (int i = 0; ((i < 20) && (book.error() == 0)); i++) {
                                key = new String(book.getKeyText().getBytes("iso8859-1"), "UTF-8");
                                retVal += (currentKey.equals(key)) ? "<li style=\"display: block; background: #C3AB7F;\">" : "<li style=\"display: block;\">";
                                retVal += "<a href=\"#\" onclick=\"suggest('"+mod+"', encodeURIComponent('"+key+"')); return false;\">"+key+"</a></li>\n";
                                
                                book.next();
                        }
                        out.print(retVal);
                }
                return;
        }
        else if ("entryBody".equals(action)) {
                if (mod != null && key != null)  {
                        SWModule book = mgr.getModuleByName(mod);
                        if (book != null) {
System.err.println("setting: ["+key+"]");
				book.setKeyText(key);
                                String body    = new String(book.getRenderText().getBytes("iso8859-1"), "UTF-8");
                                String keyText = new String(book.getKeyText().getBytes("iso8859-1"), "UTF-8");
System.err.println("getting: ["+keyText+"]");
                                out.print("<h2>"+keyText+"</h2>"+body);
                        }
                }
                return;
        }
%>

<html>
  <head>
    <script type="text/javascript">
<!--

var xmlhttp=false;
var xmlhttp2=false;
/*@cc_on @*/
/*@if (@_jscript_version >= 5)
// JScript gives us Conditional compilation, we can cope with old IE versions.
// and security blocked creation of the objects.
 try {
  xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
  xmlhttp2 = new ActiveXObject("Msxml2.XMLHTTP");
 } catch (e) {
  try {
   xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
   xmlhttp2 = new ActiveXObject("Microsoft.XMLHTTP");
  } catch (E) {
   xmlhttp = false;
   xmlhttp2 = false;
  }
 }
@end @*/
if (!xmlhttp && typeof XMLHttpRequest!='undefined') {
  xmlhttp = new XMLHttpRequest();
  xmlhttp2 = new XMLHttpRequest();
}


var lexindex;
var lexentry;

function suggest(mod, key) {

        lexindex=document.getElementById("lexindex");
        lexentry=document.getElementById("lexentry");
        lexentry.innerHTML="Please wait...";
        xmlhttp.open("GET", "suggest.jsp?mod="+mod+"&key="+encodeURIComponent(key)+"&action=keyList",true);
        xmlhttp.onreadystatechange=function() {
                if (xmlhttp.readyState==4) {
                        lexindex.innerHTML=xmlhttp.responseText;
                }
        }
        xmlhttp.send(null);
        xmlhttp2.open("GET", "suggest.jsp?mod="+mod+"&key="+encodeURIComponent(key)+"&action=entryBody",true);
        xmlhttp2.onreadystatechange=function() {
                if (xmlhttp2.readyState==4) {
                        lexentry.innerHTML=xmlhttp2.responseText;
                }
        }
        xmlhttp2.send(null);
}
-->

    </script>
  </head>
<body>

<h1>SWORDWeb suggest Example</h1>

<form name="suggestForm" action="">
  <select name="modName">
<%
        ModInfo[] modInfo = mgr.getModInfoList();
        for (int i = 0; i < modInfo.length; i++) {
            SWModule book = mgr.getModuleByName(modInfo[i].name);
%>
            <option value="<%= modInfo[i].name %>" <%= modInfo[i].name.equals(mod) ? "selected=\"selected\"":"" %>><%=modInfo[i].description + " ("+modInfo[i].name+")" %></option>
<%
        }
 %>
   </select><br />
   Lookup: <input type="text" value="<%=(key != null)?key:""%>" onkeyup="suggest(document.suggestForm.modName.value, this.value); return false;" />
</form>

<table width="100%">
<tr>
<td valign="top" width="30%">
<div id="lexindex">
</div>
</td>
<td valign="top" width="70%">
<div id="lexentry">
</div>
</td>
</tr>
</table>
<script type="text/javascript">
<% if ((mod != null) && (key != null)) { %>
<!--
suggest('<%=mod%>', '<%=key%>');
-->
</script>
<% } %>

</body>
</html>
