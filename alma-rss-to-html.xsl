<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="1.0">
  <xsl:output method="html" doctype-system="about:legacy-compat" encoding="UTF-8" indent="yes"/>
  <xsl:template match="/">
    <html>
      <head>
        <title>New Items</title>
      </head>
      <body>
        <xsl:apply-templates select="/rss//item[position() &lt; 10]"/>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
	<script>
	  <xsl:text disable-output-escaping="yes">
	    <![CDATA[
		     function bookList(){"use strict";var a={settings:{},strings:{},bindUiActions:function(){a.iterateUrls()},init:function(){a.bindUiActions()},iterateUrls:function(){document.querySelectorAll('[property="url"]');$(".item-title a").each(function(a){var b=$(this).attr("href"),c=$(this).parent().parent(),d=b.split(","),e=d[d.length-1],f="http://sp.library.miami.edu/external_scripts/newbooks/pnx.php?alma_id="+e;$.get(f,function(a){var b=$.parseJSON(a).search.isbn;if(Array.isArray(b))for(var d=0;d<b.length;d++)if(13===b[d].length){b=b[d];break}var e="http://sp.library.miami.edu/external_scripts/newbooks/bookcover.php?syndetics_client_code=miamih&image_size=LC&isbn="+b;$.get(e,function(a){var b=document.createElement("img");b.setAttribute("src",a),console.log(c),c.prepend(b)})})})}};return a}var bookList=bookList();bookList.init();
	    ]]>
	  </xsl:text>
	</script>
	
      </body>
    </html>
  </xsl:template>
  <xsl:template match="/rss//item[position() &lt; 10]">
    <xsl:choose>
      <xsl:when test="./mattype/text()='BOOK'">
        <div class="item" vocab="http://schema.org/" typeof="Book">
          <ul class="item-info">
            <li class="item-title">
              <a>
                <xsl:attribute name="property">url</xsl:attribute>
                <xsl:attribute name="href">
                  <xsl:value-of select="./link"/>
                </xsl:attribute>
                <span>
                  <xsl:attribute name="property">name</xsl:attribute>
                  <xsl:value-of select="./title"/>
                </span>
              </a>
            </li>
            <li class="item-author">
              <xsl:attribute name="property">author</xsl:attribute>
              <xsl:value-of select="./author"/>
            </li>
            <li class="item-description">

              <xsl:attribute name="property">description</xsl:attribute>
              <xsl:value-of select="./description"/>
            </li>
            <li class="item-language">
              <xsl:attribute name="property">inLanguage</xsl:attribute>

              <xsl:value-of select="language"/>
            </li>
            <li class="item-format">
              <xsl:value-of select="./format"/>
            </li>
            <li class="item-type">
              <xsl:value-of select="./mattype"/>
            </li>
            <li class="item-pubdate">
              <xsl:attribute name="property">datePublished</xsl:attribute>
              <xsl:value-of select="./pubDate"/>
            </li>
            <li class="item-arrivaldate">
              <xsl:value-of select="./arrivalDate"/>
            </li>
          </ul>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <div class="item" vocab="http://schema.org/" typeof="CreativeWork">
          <ul class="item-info">
            <li class="item-title">
              <a>
                <xsl:attribute name="property">url</xsl:attribute>
                <xsl:attribute name="href">
                  <xsl:value-of select="./link"/>
                </xsl:attribute>
                <span>
                  <xsl:attribute name="property">name</xsl:attribute>
                  <xsl:value-of select="./title"/>
                </span>
              </a>
            </li>
            <li class="item-author">
              <xsl:attribute name="property">author</xsl:attribute>
              <xsl:value-of select="./author"/>
            </li>
            <li class="item-description">

              <xsl:attribute name="property">description</xsl:attribute>
              <xsl:value-of select="./description"/>
            </li>
            <li class="item-language">
              <xsl:attribute name="property">inLanguage</xsl:attribute>

              <xsl:value-of select="language"/>
            </li>
            <li class="item-format">
              <xsl:value-of select="./format"/>
            </li>
            <li class="item-type">
              <xsl:value-of select="./mattype"/>
            </li>
            <li class="item-pubdate">
              <xsl:attribute name="property">datePublished</xsl:attribute>
              <xsl:value-of select="./pubDate"/>
            </li>
            <li class="item-arrivaldate">
              <xsl:value-of select="./arrivalDate"/>
            </li>
          </ul>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
