package org.crosswire.web.i18n;

import javax.servlet.jsp.tagext.BodyTagSupport;
import javax.servlet.jsp.tagext.BodyContent;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspTagException;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpServletRequest;
import java.util.Vector;


public class PageStart extends BodyTagSupport {

	public int doEndTag() throws JspException {
		try {
			HttpSession session = pageContext.getSession();
			session.setAttribute("pageTags", new Vector());
			try {
				session.setAttribute("requestURL", ((HttpServletRequest)pageContext.getRequest()).getRequestURI());
			}
			catch (Exception e1) {}
		}
		catch(Exception e) {
			throw new JspTagException("IO Error: " + e.getMessage());
		}
		return EVAL_PAGE;
	}
}
