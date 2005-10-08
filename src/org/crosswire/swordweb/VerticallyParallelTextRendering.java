package org.crosswire.swordweb;

import java.util.Enumeration;
import java.util.Vector;
import org.crosswire.sword.orb.SWModule;

public class VerticallyParallelTextRendering implements ModuleTextRendering {
    public String render(Vector modules, Vector entryList,
            ModuleEntryRenderer renderer) {
        StringBuffer ret = new StringBuffer();
        ret.append("<table><tbody>");

        Vector swordMods = new Vector();
        Enumeration moduleEnum = modules.elements();
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
            String currentEntry = (String) entryEnum.nextElement();
            ret.append(renderer.render(swordMods, currentEntry));
            ret.append("<tr><td><div style=\"height:10px;\"/><td></tr>"); // an
            // empty space between verses
        }

        ret.append("</tbody></table>");

        return ret.toString();
    }
}
