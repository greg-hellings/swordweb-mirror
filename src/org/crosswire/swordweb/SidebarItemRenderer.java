package org.crosswire.swordweb;

import org.crosswire.sword.orb.SWModule;

/**
 * Renders a single module into something useful, e.g. a HTML link.
 * 
 */
public interface SidebarItemRenderer {
    /**
     * Does the actual rendering.
     * 
     * @param module
     *            The module to use for the rendering.
     * @return A HTML text string for this module.
     */
    public String renderModuleItem(SWModule module);
}
