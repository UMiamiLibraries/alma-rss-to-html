<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="1.0">
  <xsl:template match="/">
      <div id="new_books_container">            

          <div id="sorts" class="sort-by-button-group">
              <button data-sort-value="arrivaldate" class="active-sort">Arrival Date</button>
              <button data-sort-value="title">Title</button>
              <button data-sort-value="author">Author</button>
          </div>

          <div id="new_books">
            <xsl:apply-templates select="/rss//item[position() &lt; 101]"/>
          </div> <!--end #new_books-->
      </div><!--end #new_books_container-->
   
  </xsl:template>  

  <xsl:template match="/rss//item[position() &lt; 101]">
      <div>
          <xsl:attribute name="class">element-item flip-container</xsl:attribute>
          <xsl:attribute name="data-author"><xsl:value-of select="./author"/></xsl:attribute>
          <xsl:attribute name="data-title"><xsl:value-of select="./title"/></xsl:attribute>
          <xsl:attribute name="data-language"><xsl:value-of select="language"/></xsl:attribute>
          <xsl:attribute name="data-arrivaldate"><xsl:value-of select="./arrivalDate"/></xsl:attribute>

          <div class="flip-btn" title="Click for more details"><i class="fa fa-info"><span class="fake-space">fake</span></i></div>
          <div class="item flipper" vocab="http://schema.org/" typeof="Book">
              <div class="front">
                  <div class="item-image"><span class="fake-space">fake</span></div>
                  <div class="front-labels">
                        <div class="item-title">
                            <a>
                                <xsl:attribute name="property">url</xsl:attribute>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="./link"/>
                                </xsl:attribute>
                                <span class="item-title-text">
                                    <xsl:attribute name="property">name</xsl:attribute>
                                    <xsl:value-of select="./title"/>
                                </span>
                            </a>
                        </div>
                        <div class="label-author">
                          <a>
                                <xsl:attribute name="property">url</xsl:attribute>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="./link"/>
                                </xsl:attribute>
                                <span class="item-title-text">
                                    <xsl:attribute name="property">author</xsl:attribute>
                                    <xsl:value-of select="./author"/>
                                </span>
                            </a>
                        </div>
                  </div>
              </div><!--end front-->

              <div class="back">
                  <ul class="item-info">
                      <li class="label-title">
                        <xsl:attribute name="property">name</xsl:attribute>
                          <xsl:value-of select="./title"/>
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
                      <li class="item-arrivaldate">
                          <xsl:value-of select="./arrivalDate"/>
                      </li>
                  </ul>
                  <div class="cat-request">
                    <a target="blank" title="See item in uSearch">
                      <xsl:attribute name="property">url</xsl:attribute>
                          <xsl:attribute name="href">
                              <xsl:value-of select="./link"/>
                          </xsl:attribute>
                    More details
                    </a>
                  </div>
              </div><!--end back-->
          </div>
      </div>
  </xsl:template>
</xsl:stylesheet>
