package org.crosswire.swordweb;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.Enumeration;
import java.util.Vector;
import org.crosswire.sword.orb.*;

public class HorizontallyParallelTextRendering implements ModuleTextRendering {
    public String render(Vector modules, Vector entryList,
            ModuleEntryRenderer renderer) {
        StringBuffer ret = new StringBuffer();
        ret.append("<table>");
        
        ret.append("<colgroup>");// setup col attributes
        for (int i = 0; i < modules.size(); i++) {
            ret.append("<col width=\"").append(100 / modules.size());
            ret.append("%\" />");
        }
        ret.append("</colgroup>");
        
        ret.append("<thead><tr>");

        Enumeration moduleEnum = modules.elements();
        while (moduleEnum.hasMoreElements()) {
            SWModule mod = (SWModule) moduleEnum.nextElement();
            try {
                ret.append("<th><a href=\"fulllibrary.jsp?show=");
                ret.append(URLEncoder.encode(mod.getName(), "UTF-8"));
                ret.append("\">");
                ret.append(mod.getDescription().replaceAll("&", "&amp;"));
                ret.append(" (").append(mod.getName()).append(")");
                ret.append("</a></th>");
            } catch (UnsupportedEncodingException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }

        }
        ret.append("</tr></thead>");
        ret.append("<tbody>");

        Vector swordMods = new Vector();
        moduleEnum = modules.elements();
        while (moduleEnum.hasMoreElements()) {
            try {
                SWModule mod = (SWModule) moduleEnum.nextElement();
                swordMods.add(mod);
            } catch (Exception e) {
                break;
            }
        }

        Enumeration entryEnum = entryList.elements();
        while (entryEnum.hasMoreElements()) {
            ret.append(renderer.render(swordMods, (String) entryEnum.nextElement()));
        }

        ret.append("</tbody>").append("</table>");

        return ret.toString();
    }
}
