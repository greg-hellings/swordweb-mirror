<%
	String u = request.getRequestURI();
	String homeID = u.endsWith("index.jsp") ? "id=\"current\"" : "";
	String passageID = u.endsWith("passagestudy.jsp") ? "id=\"current\"" : "";
	String parallelID = u.endsWith("parallelstudy.jsp") ? "id=\"current\"" : "";
	String searchID = u.endsWith("powersearch.jsp") || u.endsWith("wordsearchresults.jsp")  ? "id=\"current\"" : "";
	String devotionalID = u.endsWith("dailydevotion.jsp") ? "id=\"current\"" : "";
	String libraryID = u.endsWith("fulllibrary.jsp") ? "id=\"current\"" : "";
	String preferencesID = u.endsWith("preferences.jsp") ? "id=\"current\"" : "";
	String aboutID = u.endsWith("about.jsp") ? "id=\"current\"" : "";
	String helpID = u.endsWith("help.jsp") ? "id=\"current\"" : "";
%>


  <div id="header">
    <h1><acronym title="Open Scripture Information Standard">OSIS</acronym> Bible Tool</h1>
    <div id="navlist">
      <ul>
        <li><a <%= homeID %> href="index.jsp" title="Home">Home</a></li>
        <li><a <%= passageID %> href="passagestudy.jsp" title="Passage Study">Passage Study</a></li>
        <li><a <%= parallelID %> href="parallelstudy.jsp" title="Parallel Translations">Parallel</a></li>
        <li><a <%= searchID %> href="powersearch.jsp" title="Power Search">Search</a></li>
        <li><a <%= devotionalID %> href="dailydevotion.jsp" title="Daily Devotionals">Devotionals</a></li>
        <li><a <%= libraryID %> href="fulllibrary.jsp" title="Full Library">Library</a></li>
        <li><a <%= preferencesID %> href="preferences.jsp" title="Preferences">Preferences</a></li>
        <li><a <%= aboutID %> href="about.jsp" title="About">About</a></li>
<!--  
        <li><a <%= helpID %> href="help.jsp" title="Help">Help</a></li>
-->
      </ul>
    </div>
  </div>
