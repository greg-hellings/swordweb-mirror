package org.crosswire.swordweb;

import java.util.Vector;
import java.util.Enumeration;
import java.net.URLEncoder;

import org.crosswire.sword.orb.SWModule;
import org.crosswire.sword.orb.SWMgr;

public class VerticallyParallelTextRendering implements ModuleTextRendering {
	private Vector _modules;
	private String _range;
	
	public String render( Vector modules, Vector entryList, ModuleEntryRenderer renderer ) {
		StringBuffer ret = new StringBuffer();
		ret.append("<table>");
		ret.append("<tbody>");
		
		Vector swordMods = new Vector();
		Enumeration moduleEnum = modules.elements();
		while ( moduleEnum.hasMoreElements() ) {
			try {
				SWModule mod = (SWModule)moduleEnum.nextElement();
				swordMods.add(mod);
			}
			catch (Exception e){
				break;
			}
		}	

		Enumeration entryEnum = entryList.elements();
		while ( entryEnum.hasMoreElements() ) {
			String currentEntry = (String)entryEnum.nextElement();
			boolean insertedVerse = false;

			ret.append( renderer.render(swordMods, currentEntry) );
			ret.append("<tr><td><div style=\"height:10px;\"/><td></tr>"); //an empty line between verses
		}
		
		ret.append("</tbody>").append("</table>");
		
		return ret.toString();
	}
}
