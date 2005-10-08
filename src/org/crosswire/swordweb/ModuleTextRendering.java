package org.crosswire.swordweb;

import java.util.Vector;

public interface ModuleTextRendering {

    public String render(Vector modules, Vector entryList,
            ModuleEntryRenderer renderer);
}
