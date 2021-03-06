package org.crosswire.swordweb;

import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathFactory;
import org.xml.sax.InputSource;
import java.net.URL;
import javax.xml.xpath.XPathConstants;
import com.sun.org.apache.xml.internal.dtm.ref.DTMNodeList;
import java.net.*;
import org.w3c.dom.Node;
import org.w3c.dom.Document;
import org.w3c.dom.*;
import java.io.*;
import greekconverter.UnicodeToBetacode;
import greekconverter.BetacodeToUnicode;

public class PerseusUtils {
    public static String getLiddellScottDef(String lemma) {
        UnicodeToBetacode bc = new UnicodeToBetacode();
        String retVal = "";
        XPath xpath = XPathFactory.newInstance().newXPath();
        String expression = "//entry/sense";
        URL url = null;
	int start = 0;
        int end = 0;
	if (lemma.indexOf(", ") > -1) {
            retVal = "<h2><span class=\"verse\">"+lemma+"</span></h2>";
        }
	do {
	    end = lemma.indexOf(", ", start);
	    String part = (end > -1) ? lemma.substring(start, end) : lemma.substring(start);
            String lemmaUnicode = part;
            part = bc.convertString(part).toLowerCase();
            // Perseus wants final sigma to be "s"
            if (part.endsWith("j")) part = part.substring(0, part.length()-1) + "s";
            start = end + 2;
            try {
                url = new URL("http://www.perseus.tufts.edu/hopper/xmlchunk?doc=Perseus%3Atext%3A1999.04.0058%3Aentry%3D"+URLEncoder.encode(part));
                InputSource inputSource = new InputSource(url.openStream());
                DTMNodeList nodes = (DTMNodeList)xpath.evaluate(expression, inputSource, XPathConstants.NODESET);
                if (nodes.getLength() > 0) {
                    retVal += "<h2><span class=\"verse\">"+lemmaUnicode+"</span></h2>";
                    for (int i = 0; i < nodes.getLength(); i++) {
                         Node n = nodes.item(i);
                         retVal += outputSenseNode(n);
                     }
                }
            } catch (Exception ex) { ex.printStackTrace(); }
	} while (end > -1);
        return retVal;
    }
    
    static String outputSenseNode(Node sense) {
        String retVal = "<p>";
        Node n = sense.getAttributes().getNamedItem("n");
        if (n != null) retVal += "<span class=\"sameLemma\">"+n.getNodeValue()+"</span>. ";
        NodeList children = sense.getChildNodes();
        StringBuffer out = new StringBuffer();
        for (int i = 0; i < children.getLength(); i++) {
            print(children.item(i), out);
        }
        retVal += out.toString();
        retVal += "</p>";
        return retVal;
    }
    
    
    
    /** Prints the specified node, recursively. */
  static public void print(Node node, StringBuffer out) {

   // is there anything to do?
   if ( node == null ) {
      return;
   }

   int type = node.getNodeType();
   switch (type) {
      // print document
      case Node.DOCUMENT_NODE: {
            print(((Document)node).getDocumentElement(), out);
            break;
         }

         // print element with attributes
      case Node.ELEMENT_NODE: {
            out.append('<');
            out.append(node.getNodeName());
            NamedNodeMap attrs = node.getAttributes();
            for ( int i = 0; i < attrs.getLength(); i++ ) {
               Node attr = attrs.item(i);
               out.append(' ');
               out.append(attr.getNodeName());
               out.append("=\"");
               out.append(normalize(attr.getNodeValue()));
               out.append('"');
            }
            out.append('>');
            NodeList children = node.getChildNodes();
            if ( children != null ) {
               int len = children.getLength();
               for ( int i = 0; i < len; i++ ) {
                  print(children.item(i), out);
               }
            }
            break;
         }

         // handle entity reference nodes
      case Node.ENTITY_REFERENCE_NODE: {
               NodeList children = node.getChildNodes();
               if ( children != null ) {
                  int len = children.getLength();
                  for ( int i = 0; i < len; i++ ) {
                     print(children.item(i), out);
                  }
               }
            break;
         }

         // print cdata sections
      case Node.CDATA_SECTION_NODE: {
               out.append(normalize(node.getNodeValue()));
            break;
         }

         // print text
      case Node.TEXT_NODE: {
            String txt = node.getNodeValue();
            Node l = node.getParentNode().getAttributes().getNamedItem("lang");
            if ((l != null) && ("greek".equals(l.getNodeValue()))) {
  //            txt = (new BetacodeToUnicode().convertString(txt));	// THIS FAILS.  BUMMER.  NOT NEEDED ANYMORE?
            }
            out.append(normalize(txt));
            break;
         }

         // print processing instruction
      case Node.PROCESSING_INSTRUCTION_NODE: {
            out.append("<?");
            out.append(node.getNodeName());
            String data = node.getNodeValue();
            if ( data != null && data.length() > 0 ) {
               out.append(' ');
               out.append(data);
            }
            out.append("?>");
            break;
         }
   }

   if ( type == Node.ELEMENT_NODE ) {
      out.append("</");
      out.append(node.getNodeName());
      out.append('>');
   }
} // print(Node)
    
  static String normalize(String s) {
   StringBuffer str = new StringBuffer();

   int len = (s != null) ? s.length() : 0;
   for ( int i = 0; i < len; i++ ) {
      char ch = s.charAt(i);
      switch ( ch ) {
         case '<': {
               str.append("&lt;");
               break;
            }
         case '>': {
               str.append("&gt;");
               break;
            }
         case '&': {
               str.append("&amp;");
               break;
            }
         case '"': {
               str.append("&quot;");
               break;
            }
         case '\r':
         case '\n': {
                  str.append("&#");
                  str.append(Integer.toString(ch));
                  str.append(';');
                  break;
            }
         default: {
               str.append(ch);
            }
      }
   }

   return (str.toString());

} // normalize(String):String


}

