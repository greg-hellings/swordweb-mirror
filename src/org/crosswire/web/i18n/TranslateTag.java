package org.crosswire.web.i18n;

import javax.servlet.jsp.tagext.BodyTagSupport;
import javax.servlet.jsp.tagext.BodyContent;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspTagException;
import javax.servlet.http.HttpSession;
import javax.servlet.jsp.PageContext;
import java.util.Vector;
import java.util.Properties;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;


public class TranslateTag extends BodyTagSupport {


	private String bodyText = "";

	public static Properties getSessionLocale(PageContext pageContext) {
		HttpSession session = pageContext.getSession();
		Properties locale = null;
		try {
			String localeName = (String)session.getAttribute("lang");
			if (localeName == null) localeName = "en_US";
			locale = (Properties)session.getAttribute("locale_"+localeName);
			if (locale == null) {
				locale = new Properties();
				File propName = new File(pageContext.getServletContext().getRealPath("/WEB-INF/classes/trans_"+localeName+".properties"));
				if (propName.exists()) {
					FileInputStream propFile = new FileInputStream(propName);
					locale.load(propFile);
					propFile.close();
				}
				session.setAttribute("locale_"+localeName, locale);
			}
		}
		catch (Exception e) { e.printStackTrace(); }

		return locale;
	}


	public static String getTranslation(PageContext pageContext, String english, boolean addPageTag) throws JspTagException {
		String hashkey = "" + english.hashCode();
		String result = english;
		try {
			HttpSession session = pageContext.getSession();
			Vector pageTags = (Vector)session.getAttribute("pageTags");
			if (addPageTag) {
				if (pageTags == null) {
					pageTags = new Vector();
					session.setAttribute("pageTags", pageTags);
				}
				pageTags.add(english);
			}
			Properties locale = getSessionLocale(pageContext);
			result = locale.getProperty(hashkey);
			if (result == null) {
				// do we need to do this?
				String localeName = (String)session.getAttribute("lang");
				locale.setProperty(hashkey, ("en_US".equals(localeName))?english:"");
				File propName = new File(pageContext.getServletContext().getRealPath("/WEB-INF/classes/trans_"+localeName+".properties"));
				FileOutputStream propFile = new FileOutputStream(propName);
				locale.store(propFile, null);
				propFile.close();
				// ---------------------
				result = english;
			}
			if (result.length() < 1) {
				result = english;
			}
		}
		catch (Exception e) { e.printStackTrace(); }
		return result;
	}

	public int doAfterBody() throws JspTagException {
		BodyContent bc = getBodyContent();
		bodyText = bc.getString();
		return 0;
	}

	public int doEndTag() throws JspException {
		try {
			pageContext.getOut().write(getTranslation(pageContext, bodyText, true));
		}
		catch(Exception e) {
			throw new JspTagException("IO Error: " + e.getMessage());
		}
		return EVAL_PAGE;
	}
}
