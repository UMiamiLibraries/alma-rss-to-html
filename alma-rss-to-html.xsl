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
	      <script type="text/javascript" src="bookList.js">&#160;</script> 
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
