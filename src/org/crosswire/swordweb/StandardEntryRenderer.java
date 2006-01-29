package org.crosswire.swordweb;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.Enumeration;
import java.util.Vector;
import org.crosswire.sword.orb.SWModule;
import org.crosswire.sword.orb.SWMgr;

public class StandardEntryRenderer implements ModuleEntryRenderer {
    protected String scriptName;

    protected String highlightKey;

    protected SWMgr mgr;

    protected Vector filterOptions = new Vector();

    protected boolean insertVerseLinks = true;

    public StandardEntryRenderer(String scriptName, String highlightKey,
            SWMgr mgr) {
        this.scriptName = scriptName;
        this.highlightKey = highlightKey;
        this.mgr = mgr;
    }

    public void enableFilterOption(String name) {
        filterOptions.add(name);
    }

    public String render(Vector modules, String key) {
        StringBuffer ret = new StringBuffer();
        SWModule mod = null;
        Enumeration modEnum = null;

        StringBuffer header = null;
        modEnum = modules.elements();
        while (modEnum.hasMoreElements()) {
            mod = (SWModule) modEnum.nextElement();
            final boolean rtol = ("RtoL".equalsIgnoreCase(mod
                    .getConfigEntry("Direction")));

            String[] heads = mod.getEntryAttribute("Heading", "Preverse", "0", true);
            if (heads.length > 0) {
                if (header == null) {
                    header = new StringBuffer();
                }

                if (rtol) {
                    header.append("<td dir=\"rtl\"><div dir=\"rtl\">");
                } else {
                    header.append("<td><div>");
                }

                header.append("<h3>");
                try {
                    header.append(new String(heads[0].getBytes("iso8859-1"),
                            "UTF-8"));
                } catch (Exception e) {
                }
                header.append("</h3></div></td>");
            } else if (header != null) { // don't leave out a column if we
                // started a new row
                header.append("<td></td>");
            }
        }

        if (header != null) { // we got headings
            ret.append("<tr>").append(header).append("</tr>");
        }

        ret.append("<tr>");

        modEnum = modules.elements();
        while (modEnum.hasMoreElements()) {
            mod = (SWModule) modEnum.nextElement();
            final boolean rtol = ("RtoL".equalsIgnoreCase(mod
                    .getConfigEntry("Direction")));

            if (rtol) {
                ret.append("<td dir=\"rtl\">");
            } else {
                ret.append("<td>");
            }

            ret.append(this.render(mod, key));
            ret.append("</td>");
        }

        ret.append("</tr>\n");
        return ret.toString();
    }

    public String render(SWModule module, String key) {
        StringBuffer ret = new StringBuffer();

        final int verse = Integer.parseInt(key.substring(key.indexOf(":") + 1));
        final int highlightVerse = Integer.parseInt(highlightKey.substring(key
                .indexOf(":") + 1));
        final boolean enableFilterOptions = (verse >= highlightVerse - 1)
                && (verse <= highlightVerse + 1);

        Enumeration filterEnum = filterOptions.elements();
        while (filterEnum.hasMoreElements()) {
            mgr.setGlobalOption((String) filterEnum.nextElement(),
                    enableFilterOptions ? "on" : "off");
        }

        String hrefURL = null;
        try {
            hrefURL = URLEncoder.encode(key, "UTF-8");
        } catch (UnsupportedEncodingException e1) {
            // TODO Auto-generated catch block
//            e1.printStackTrace();
        }

        StringBuffer verseLink;
        if (key.equals(highlightKey)) { // highlight this key, insert the #cv
            // marker in the link
            ret.append("<div class=\"currentverse\">");
            verseLink = new StringBuffer("<a id=\"cv\" href=\"" + scriptName
                    + "?key=" + hrefURL + "#cv\">");
        } else { // just a normal verse, no currentverse class and no cv
            // marker
            ret.append("<div class=\"verse\">");
            verseLink = new StringBuffer("<a href=\"" + scriptName + "?key="
                    + hrefURL + "#cv\">");
        }
        verseLink.append(verse).append("</a>"); // link end is the same for both
        // (highlighted and plain link)

        if (insertVerseLinks) {
            ret.append("<span class=\"versenum\">").append(verseLink).append(
                    "</span> ");
        }

        try {
            module.setKeyText(key);
            ret.append(new String(module.getRenderText().getBytes("iso8859-1"),
                    "UTF-8"));
        } catch (Exception e) {
        }

        ret.append("</div>");
        return ret.toString();
    }
}
