package org.crosswire.swordweb;

import org.crosswire.sword.orb.SWModule;
import java.util.Vector;

/** Renders a sidebar module list.
 * Pages like passagestudy or parallelstudy share the same code to render the list of modules on their sidebars (left and right).
 * This class supports to reuse this code. It offers a method to render a module list in a style which is set by the displayed page.
 */
public interface SidebarModuleView {
	/** Render a sidebar module list using a provided renderer object.
	 * @param mods
	 * @param renderer This renderer object is used to insert the rendered HTML items for each module. This is necessary because each page has different needs for these items.
	 * @return The complete list of modules. It includes HTML list markers like ul and /ul around it if the renderer uses HTML ul list. No need to insert them on your own.
	 */
	public String renderView(Vector mods, SidebarItemRenderer renderer);
}
