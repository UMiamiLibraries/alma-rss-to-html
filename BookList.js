/**
 * Created by cbrownroberts on 9/13/16.
 */
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
                        },
                       sortBy: 'arrivaldate',
                       sortAscending: 'false'
                    });

                    $('.books-loading').hide();

                });

                // sort items on button click
                $('#sorts').on( 'click', 'button', function() {
                    var sortByValue = $(this).attr('data-sort-value');
                    $('#new_books').isotope({ sortBy: sortByValue});
                    console.log('click');
                    $('#sorts button').removeClass('active-sort');
                     $(this).addClass('active-sort');
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
                        imgCover.setAttribute('class', 'webservice-cover');
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

$( document ).ready(function() {
   //set fallback image
   var cover = $(".item-image img");
   var altCover = "http://lorempixel.com/200/215";

   $('.item-image img').each(function() {

       if($(this).attr('src') == "") {
           console.log("no cover");
           $(this).attr("src", altCover);
       } else {
           console.log("cover found");
       }

   });
});