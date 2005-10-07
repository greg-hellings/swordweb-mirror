package org.crosswire.swordweb;

import java.util.Vector;
import java.util.Enumeration;
import java.net.URLEncoder;

import org.crosswire.sword.orb.*;

public class StandardEntryRenderer implements ModuleEntryRenderer {
	private String _scriptName;
	private String _highlightKey;
	private SWMgr _mgr;
	private Vector _filterOptions = new Vector(); 
	
	public StandardEntryRenderer( String scriptName, String highlightKey, SWMgr mgr ) {
		_scriptName = scriptName;
		_highlightKey = highlightKey;
		_mgr = mgr;
	}
	
	public void enableFilterOption(String name) {
		_filterOptions.add(name);
	}
	
	public String render( Vector modules, String key ) {
		StringBuffer ret = new StringBuffer();
		ret.append("<tr>");
		
		Enumeration modEnum = modules.elements();
		while (modEnum.hasMoreElements()) {		
			SWModule mod = (SWModule)modEnum.nextElement();			
			final boolean rtol = ("RtoL".equalsIgnoreCase(mod.getConfigEntry("Direction")));

			if (rtol) {				
				ret.append("<td dir=\"rtl\">");
			}
			else {
				ret.append("<td>");
			}
			ret.append( this.render(mod, key) );
			ret.append("</td>");
		}
		
		ret.append("</tr>");		
		return ret.toString();
	}
	
	public String render( SWModule module, String key ) {
		StringBuffer ret = new StringBuffer();

		final int verse = Integer.parseInt( key.substring(key.indexOf(":") + 1) );
		final int highlightVerse = Integer.parseInt( _highlightKey.substring(key.indexOf(":") + 1) );
		final boolean enableFilterOptions = (verse >= highlightVerse -1) && (verse <= highlightVerse + 1);
		
		Enumeration filterEnum = _filterOptions.elements();
		while (filterEnum.hasMoreElements()) {
				_mgr.setGlobalOption((String)filterEnum.nextElement(), enableFilterOptions ? "on" : "off");
		}
		
		final String hrefURL = URLEncoder.encode(key);		
		StringBuffer verseLink;		
		if (key.equals(_highlightKey)) { //highlight this key, insert the #cv marker in the link
			ret.append("<div class=\"currentverse\">");
			verseLink = new StringBuffer("<a id=\"cv\" href=\"" + _scriptName + "?key=" + hrefURL  + "#cv\">");
		}
		else { //just a normal verse, no currentverse class and no cv marker
			ret.append("<div class=\"verse\">");
			verseLink = new StringBuffer("<a href=\"" + _scriptName + "?key=" + hrefURL  + "#cv\">");
		}		
		verseLink.append(verse).append("</a>"); //link end is the same for both (highlighted and plain link)

		
		ret.append("<span class=\"versenum\">").append(verseLink).append("</span> ");		
		try {
			module.setKeyText(key);
			ret.append(new String(module.getRenderText().getBytes("iso8859-1"), "UTF-8"));  
		}
		catch (Exception e) {
		}
		
		ret.append("</div>");
		return ret.toString();
	}
} 
