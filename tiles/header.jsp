<%
	String u = request.getRequestURI();
	String homeID = u.endsWith("index.jsp") ? "id=\"current\"" : "";
	String passageID = u.endsWith("passagestudy.jsp") ? "id=\"current\"" : "";
	String parallelID = u.endsWith("parallelstudy.jsp") ? "id=\"current\"" : "";
	String searchID = u.endsWith("powersearch.jsp") || u.endsWith("wordsearchresults.jsp")  ? "id=\"current\"" : "";
	String devotionalID = u.endsWith("dailydevotional.jsp") ? "id=\"current\"" : "";
	String libraryID = u.endsWith("fulllibrary.jsp") ? "id=\"current\"" : "";
	String preferencesID = u.endsWith("preferences.jsp") ? "id=\"current\"" : "";
	String aboutID = u.endsWith("about.jsp") ? "id=\"current\"" : "";
	String helpID = u.endsWith("help.jsp") ? "id=\"current\"" : "";
%>


  <div id="header">
    <h1><acronym title="Open Scripture Information Standard">OSIS</acronym> Bible Tool</h1>
    <div id="navlist">
      <ul>
        <li><a href="index.jsp" title="Home" <%= homeID %>>Home</a></li>
        <li><a href="passagestudy.jsp" title="Passage Study" <%= passageID %>>Passage Study</a></li>
        <li><a href="parallelstudy.jsp" title="Parallel Translations" <%= parallelID %>>Parallel</a></li>
        <li><a href="powersearch.jsp" title="Power Search" <%= searchID %>>Search</a></li>
        <li><a href="dailydevotion.jsp" title="Daily Devotionals" <%= devotionalID %>>Devotionals</a></li>
        <li><a href="fulllibrary.jsp" title="Full Library" <%= libraryID %>>Library</a></li>
        <li><a href="preferences.jsp" title="Preferences" <%= preferencesID %>>Preferences</a></li>
        <li><a href="about.jsp" title="About" <%= aboutID %>>About</a></li>
        <li><a href="help.jsp" title="Help" <%= helpID %>>Help</a></li>
      </ul>
    </div>
  </div>
