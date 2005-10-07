package org.crosswire.swordweb;

import java.util.Vector;
import java.util.Enumeration;
import java.net.URLEncoder;

import org.crosswire.sword.orb.SWModule;
import org.crosswire.sword.orb.SWMgr;

public class HorizontallyParallelTextRendering implements ModuleTextRendering {
	private Vector _modules;
	private String _range;
	
	public String render( Vector modules, Vector entryList, ModuleEntryRenderer renderer ) {
		StringBuffer ret = new StringBuffer();
		ret.append("<table>");
		
		ret.append("<colgroup>");//setup col attributes
		for (int i = 0; i < modules.size(); i++) {
			ret.append("<col width=\"").append(100/modules.size()).append("%\" />");
		}
		ret.append("</colgroup>");
		
		ret.append("<thead><tr>");
		
		Enumeration moduleEnum = modules.elements();
		while (moduleEnum.hasMoreElements()) {
			SWModule mod = (SWModule)moduleEnum.nextElement();
			ret.append("<th><a href=\"fulllibrary.jsp?show=").append(URLEncoder.encode(mod.getName())).append("\">");
			ret.append( mod.getDescription().replaceAll("&", "&amp;")).append(" (").append(mod.getName()).append(")");
			ret.append("</a></th>");

		}
		ret.append("</tr></thead>");
		
		ret.append("<tbody>");
		
		Vector swordMods = new Vector();
		moduleEnum = modules.elements();
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
			ret.append( renderer.render(swordMods, (String)entryEnum.nextElement()) );
		}
		
		ret.append("</tbody>").append("</table>");
		
		return ret.toString();
	}
}
