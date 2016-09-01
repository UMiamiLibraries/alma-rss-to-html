<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="1.0">
  <xsl:template match="/">
  
        <xsl:apply-templates select="/rss//item[position() &lt; 10]"/>
	<script>
	  <xsl:text disable-output-escaping="yes">
	    <![CDATA[
		     function bookList() {

    "use strict";

    var myBookList = {

        settings: {},
        strings: {},
        bindUiActions: function () {
            myBookList.iterateUrls();
        },
        init: function () {
            myBookList.bindUiActions();
        },
        iterateUrls: function () {
            var elements = document.querySelectorAll('[property="url"]');

	    $('.item-title a').each(function(i) {
		var url = $(this).attr('href');
		var grandFather = $(this).parent().parent();
		var split = url.split(",");
                var almaId = split[split.length - 1];
                var newUrl = 'http://sp.library.miami.edu/external_scripts/newitems/pnx.php?alma_id=' + almaId;

		$.get(newUrl, function(data) {

		    var isbn = $.parseJSON(data).search.isbn;
		    if( Array.isArray(isbn)) {
                        for (var j = 0; j < isbn.length; j++){
                            if (isbn[j].length === 13){
                                isbn = isbn [j];
                                break;
                            }
                        }
                    }

		    var bookCoverUrl = "http://sp.library.miami.edu/external_scripts/newitems/bookcover.php?syndetics_client_code=miamih&image_size=LC&isbn=" + isbn;
		    
		    $.get(bookCoverUrl, function(data) {
			var imgCover = document.createElement('img');
			imgCover.setAttribute('src', data);
			console.log(grandFather);
			grandFather.prepend(imgCover);
		    });
		});
	    });
	}	    
    };
    return myBookList;
}

var bookList = bookList();
bookList.init();
	    ]]>
	  </xsl:text>
	</script>
	
   
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
