package org.crosswire.swordweb;

import java.util.Enumeration;
import java.util.Vector;
import org.crosswire.sword.orb.SWModule;
import org.crosswire.sword.orb.SWMgr;

public class SimpleModuleView implements SidebarModuleView {
    private SWMgr _mgr;

    public SimpleModuleView(SWMgr mgr) {
        _mgr = mgr;
    }

    public String renderView(Vector mods, SidebarItemRenderer renderer) {
        StringBuffer ret = new StringBuffer();

        if (mods.size() > 0) {
            ret.append("<ul>");
            Enumeration e = mods.elements();
            while (e.hasMoreElements()) {
                SWModule mod = _mgr.getModuleByName((String) e.nextElement());
                if (mod != null) {
                    ret.append(renderer.renderModuleItem(mod));
                }
            }

            ret.append("</ul>");
        }

        return ret.toString();
    }
}