/*
 * Copyright (c) 2005-2006, Luke Plant
 * All rights reserved.
 * E-mail: <L.Plant.98@cantab.net>
 * Web: http://lukeplant.me.uk/
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *
 *      * Redistributions of source code must retain the above copyright
 *        notice, this list of conditions and the following disclaimer.
 *
 *      * Redistributions in binary form must reproduce the above
 *        copyright notice, this list of conditions and the following
 *        disclaimer in the documentation and/or other materials provided
 *        with the distribution.
 *
 *      * The name of Luke Plant may not be used to endorse or promote
 *        products derived from this software without specific prior
 *        written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * Rewrite with Java language and modified for lorsource by Ildar Hizbulin 2011
 * E-mail: <hizel@vyborg.ru>
 */

package ru.org.linux.util.bbcode.tags;

import ru.org.linux.util.bbcode.Parser;
import ru.org.linux.util.bbcode.ParserParameters;
import ru.org.linux.util.bbcode.nodes.Node;
import ru.org.linux.util.bbcode.nodes.TagNode;
import ru.org.linux.util.bbcode.nodes.TextNode;

import java.util.Set;

/**
 * Created by IntelliJ IDEA.
 * User: hizel
 * Date: 6/30/11
 * Time: 12:34 PM
 */
public class QuoteTag extends Tag {

  public static final String citeHeader = "<div class=\"none\">&gt;&gt;-----Цитата----&gt;&gt;</div><div class=\"quote\">";
  public static final String citeFooter = "</div><div class=\"none\">&lt;&lt;-----Цитата----&lt;&lt;</div>";

  public static final String citeHeaderRSS = "<div style=\"border-width: 0 0 0 5px; border-style: solid; border-color: black; padding: 0 0 0 .5em; \">";
  public static final String citeFooterRSS = "</div>";


  public QuoteTag(String name, Set<String> allowedChildren, String implicitTag, ParserParameters parserParameters) {
    super(name, allowedChildren, implicitTag, parserParameters);
  }

  @Override
  public String renderNodeXhtml(Node node) {
    StringBuilder ret = new StringBuilder();
    boolean emtyQuote = false;
    if (node.lengthChildren() == 0) {
      return "";
    } else {
      // обработка пустого тэга
      if (node.lengthChildren() == 1) {
        Node child = node.getChildren().iterator().next();
        if (TextNode.class.isInstance(child) && ((TextNode) child).getText().trim().isEmpty()) {
          return "";
        }
        if (TagNode.class.isInstance(child)) {
          TagNode tagNode = (TagNode)child;
          Tag tag = tagNode.getBbtag();
          if("quote".equals(tag.getName())) {
            emtyQuote = true;
          }
        }
      }
    }
    if (!node.isParameter()) {
      node.setParameter("");
    } else {
      node.setParameter(node.getParameter().trim());
    }

    boolean rss = ((TagNode)node).getRootNode().isRss();

    if (!node.getParameter().isEmpty()) {
      if(rss) {
        ret.append(citeHeaderRSS);
      } else {
        ret.append(citeHeader);
      }
      ret.append("<p><cite>");
      ret.append(Parser.escape(node.getParameter().replaceAll("\"", "")));
      ret.append("</cite></p>");
      ret.append(node.renderChildrenXHtml());
      if(rss) {
        ret.append(citeFooterRSS);
      } else {
        ret.append(citeFooter);
      }
    } else {
      if(emtyQuote) {
        ret.append(node.renderChildrenXHtml());
      } else {
        if(rss) {
          ret.append(citeHeaderRSS);
        } else {
          ret.append(citeHeader);
        }
        ret.append(node.renderChildrenXHtml());
        if(rss) {
          ret.append(citeFooterRSS);
        } else {
          ret.append(citeFooter);
        }
      }
    }
    return ret.toString();
  }
}
