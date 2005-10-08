package org.crosswire.swordweb;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.Enumeration;
import java.util.Vector;
import org.crosswire.sword.orb.SWModule;
import org.crosswire.sword.orb.SWMgr;

public class SimpleEntryRenderer extends StandardEntryRenderer {
    public SimpleEntryRenderer(String scriptName, String highlightKey, SWMgr mgr) {
        super(scriptName, highlightKey, mgr);
        insertVerseLinks = false;
    }

    public String render(Vector modules, String key) {
        StringBuffer ret = new StringBuffer();
        ret.append("<tr>");

        final int verse = RangeInformation.getVerseNumber(key);

        boolean insertedVerseLink = false;
        SWModule mod = null;
        Enumeration modEnum = modules.elements();
        while (modEnum.hasMoreElements()) {
            mod = (SWModule) modEnum.nextElement();

            ret.append("<tr>");
            if (!insertedVerseLink) {
                StringBuffer verseLink;
                String hrefURL = null;
                try {
                    hrefURL = URLEncoder.encode(key, "UTF-8");
                } catch (UnsupportedEncodingException e) {
                }

                if (key.equals(highlightKey)) { // highlight this key,
                    // insert the #cv marker in
                    // the link
                    verseLink = new StringBuffer("<a id=\"cv\" href=\""
                            + scriptName + "?key=" + hrefURL + "#cv\">");
                } else { // just a normal verse, no currentverse class and no
                    // cv marker
                    verseLink = new StringBuffer("<a href=\"" + scriptName
                            + "?key=" + hrefURL + "#cv\">");
                }
                verseLink.append(verse).append("</a>"); // link end is the same
                // for both (highlighted
                // and plain link)

                ret.append("<td><span class=\"versenum\">").append(verseLink)
                        .append("</span></td>");
                insertedVerseLink = true;
            } else {
                ret.append("<td></td>");
            }
            ret.append("<td>").append(mod.getName()).append("</td>");

            final boolean rtol = ("RtoL".equalsIgnoreCase(mod
                    .getConfigEntry("Direction")));
            if (rtol) {
                ret.append("<td dir=\"rtl\">");
            } else {
                ret.append("<td>");
            }
            ret.append(this.render(mod, key)).append("</td>");
            ret.append("</tr>");
        }

        ret.append("</tr>\n");
        return ret.toString();
    }
}
