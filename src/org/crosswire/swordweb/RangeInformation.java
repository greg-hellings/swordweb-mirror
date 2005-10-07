package org.crosswire.swordweb;

import java.util.Vector;
import java.net.URLEncoder;

import org.crosswire.sword.orb.SWModule;

public final class RangeInformation {
	public static Vector getChapterEntryList(String keyInChapter, SWModule module) {
		Vector ret = new Vector();
		
		if (keyInChapter.contains(":")) {			
			String chapterPrefix = keyInChapter.substring(0, keyInChapter.indexOf(":"));
			int i = 0;
			for (module.setKeyText(chapterPrefix + ":1"); (module.error() == (char)0); module.next()) {
				if (!module.getKeyText().startsWith(chapterPrefix)) { //don't continue if we're int he next chapter
					break;
				}
				if (i > 50)
					break;
				i++;
				ret.addElement( module.getKeyText() );						
			}
		}
		
		return ret;		
	}

	public static String getPreviousChapter(String keyInChapter, SWModule module) {
		StringBuffer ret = new StringBuffer();
		
		final String bookname = keyInChapter.substring(0, keyInChapter.lastIndexOf(" "));
		final int chapter = Integer.parseInt( keyInChapter.substring(keyInChapter.lastIndexOf(" ")+1, keyInChapter.indexOf(":")) );

		ret.append(bookname).append(" ").append(String.valueOf(chapter-1)).append(":1");

		module.setKeyText(ret.toString());
		ret = new StringBuffer( module.getKeyText() );
		return ret.substring(0, ret.indexOf(":"));
	}
	
	public static String getNextChapter(String keyInChapter, SWModule module) {
		StringBuffer ret = new StringBuffer();
		
		final String bookname = keyInChapter.substring(0, keyInChapter.lastIndexOf(" "));
		final int chapter = Integer.parseInt( keyInChapter.substring(keyInChapter.lastIndexOf(" ")+1, keyInChapter.indexOf(":")) );

		ret.append(bookname).append(" ").append(String.valueOf(chapter+1)).append(":1");
		
		module.setKeyText(ret.toString());
		
		ret = new StringBuffer( module.getKeyText() );
		return ret.substring(0, ret.indexOf(":"));
	}

}