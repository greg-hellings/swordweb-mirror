package org.crosswire.swordweb;

import java.util.Vector;
import org.crosswire.sword.orb.*;

public interface ModuleEntryRenderer {
		public String render( SWModule module, String key );
		public String render( Vector modules, String key );
		public void enableFilterOption(String name);
}
