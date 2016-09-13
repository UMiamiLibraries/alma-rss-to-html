<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="1.0">
  <xsl:template match="/">
      <div id="new_books_container">
          <div class="books-loading"><i class="fa fa-spinner" aria-hidden="true"></i><br />Loading</div>

          <div id="sorts" class="sort-by-button-group">
              <button data-sort-value="original-order">Original Order</button>
              <button data-sort-value="arrivaldate">Arrival Date</button>
              <button data-sort-value="title">Title</button>
              <button data-sort-value="author">Author</button>
              <button data-sort-value="language">Language</button>
          </div>

          <div id="new_books">
            <xsl:apply-templates select="/rss//item[position() &lt; 10]"/>
          </div> <!--end #new_books-->
      </div><!--end #new_books_container-->

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

                      var isotopeScript = "http://unpkg.com/isotope-layout@3.0.1/dist/isotope.pkgd.min.js";
                  
                      //get script
                      $.getScript(isotopeScript, function(){
                         $("head").append("<script src='" + isotopeScript + "'>");               
                         
                         var $win = $(window);               
                
                          //set timeout to remove preloader
                          setTimeout(function(){                  
                              $('#sorts').css('visibility', 'visible');
                              $('#new_books').css('visibility', 'visible');
                          }, 1000);

                        $win.on('load', function(){                    

                            // init Isotope
                            $('#new_books').isotope({
                                 itemSelector: '.element-item',
                                 layoutMode: 'fitRows',
                                 fitRows: {
                                    gutter: 0
                                  },
                                 getSortData: {
                                     title: '[data-title]',
                                     author: '[data-author]',
                                     arrivaldate: '[data-arrivaldate]',
                                     language: '[data-language]'
                                 }
                            });

                            $('.books-loading').hide();                 
                                             
                        });

                          // sort items on button click
                           $('#sorts').on( 'click', 'button', function() {                     
                               var sortByValue = $(this).attr('data-sort-value');
                               $('#new_books').isotope({ sortBy: sortByValue}); 
                               console.log('click');
                           }); 

                           //flip
                           $('.flip-btn').on( 'click', function() {                     
                               var flipCard = $(this).parent();
                               $(flipCard).toggleClass('hover');
                           });

                           
                      }); //end .getScript

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
                            grandFather.find(".item-image").prepend(imgCover); 
                            $("#new_books_container .item-image").addClass("remove-placeholder-cover");
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
        <div class="element-item flip-container" data-author="<xsl:value-of select='./author'/>" data-arrivaldate="<xsl:value-of select='./arrivalDate'/>" data-language="<xsl:value-of select='language'/>" data-title="<xsl:value-of select='./title'/>">
            <div class="flip-btn" title="Click for more details"><i class="fa fa-info" aria-hidden="true"></i></div>
            <div class="item flipper" vocab="http://schema.org/" typeof="Book">
                <div class="front">
                    <div class="item-image"></div>
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
                </div><!--end front-->

                <div class="back">
                    <ul class="item-info">
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
                </div><!--end back-->
            </div>
        </div>
      </xsl:when>
      <xsl:otherwise>
          <div class="element-item flip-container" data-author="<xsl:value-of select='./author'/>" data-arrivaldate="<xsl:value-of select='./arrivalDate'/>" data-language="<xsl:value-of select='language'/>" data-title="<xsl:value-of select='./title'/>">
            <div class="flip-btn" title="Click for more details"><i class="fa fa-info" aria-hidden="true"></i></div>
            <div class="item flipper" vocab="http://schema.org/" typeof="Book">
                <div class="front">
                    <div class="item-image"></div>
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
                </div><!--end front-->

                <div class="back">
                    <ul class="item-info">
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
                </div><!--end back-->
            </div>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
