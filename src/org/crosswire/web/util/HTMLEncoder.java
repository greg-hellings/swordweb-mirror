package org.crosswire.web.util;

public class HTMLEncoder {
public static String encode(String in) {
	String out = in.replaceAll("&", "&amp;");
	out = out.replaceAll("<", "&lt;");
	out = out.replaceAll(">", "&gt;");
	out = out.replaceAll("\"", "&quot;");
	out = out.replaceAll("\'", "&#039;");
	out = out.replaceAll("\\\\", "&#092;");

	return out;
}
}
