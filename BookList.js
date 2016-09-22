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
                            sortAscending: false
                        });

                        //$('.books-loading').hide();

                    });

                    // sort items on button click
                    $('#sorts').on( 'click', 'button', function() {
                        var sortByValue = $(this).attr('data-sort-value');
                        $('#new_books').isotope({ sortBy: sortByValue, sortAscending: true});
                        console.log('click');
                        $('#sorts button').removeClass('active-sort');
                        $(this).addClass('active-sort');
                    });

                    //flip
                    $('.flip-btn').on( 'click', function() {
                        var flipCard = $(this).parent();
                        $(flipCard).toggleClass('hover');
                    });                  
                    

                   $( document ).ready(function() {

                        //set timeout to remove preloader
                        setTimeout(function(){
                            $('#sorts').css('visibility', 'visible');
                            $('#new_books').css('visibility', 'visible');
                        }, 1000);
                    
                        //placeholder for empty author
                        $('#new_books_container .item-author').each(function() {
                            if($(this).is(':empty')){
                                $('#new_books_container .item-author:empty').append('<span>[Click for details]</span>');
                            }
                        });

                        $('#new_books_container .label-author a span').each(function() {
                            if($(this).is(':empty')){
                                $('#new_books_container .label-author a span:empty').append('<span>[Click for details]</span>');
                            }
                        });

                        //show author labels when sorting by author
                   
                        var authorBtn = $('button[data-sort-value="author"]');
                        var titleBtn = $('button[data-sort-value="title"]');
                        var dateBtn = $('button[data-sort-value="arrivaldate"]');

                        $(authorBtn).on( 'click', function() {
                                $('#new_books_container .label-author').show();
                                $('#new_books_container .label-title').show();
                                $('#new_books_container .item-title').hide();
                                $('#new_books_container .item-author').hide();                            
                        }); 
                       
                       $(titleBtn).on( 'click', function() {                            
                                $('#new_books_container .label-author').hide();
                                $('#new_books_container .label-title').hide();
                                $('#new_books_container .item-title').show();
                                $('#new_books_container .item-author').show();                            
                        }); 

                       $(dateBtn).on( 'click', function() {                            
                                $('#new_books_container .label-author').hide();
                                $('#new_books_container .label-title').hide();
                                $('#new_books_container .item-title').show();
                                $('#new_books_container .item-author').show();                           
                        }); 

                       
                       //clean up slash on titles                       
                       //$('#new_books_container .item-title .item-title-text').each(function() {
                        //    var frontTitle = $('#new_books_container .item-title .item-title-text').text();
                        //    frontTitle = frontTitle.replace(/\//g, " ");
                        //    $(this).append(frontTitle);
                       // });


                    });

               
                }); //end .getScript            

        },
        iterateUrls: function () {

            $('.item-title a').each(function(i) {
                var url = $(this).attr('href');
                var grandFather = $(this).parent().parent().parent();
                var split = url.split(",");
                var almaId = split[split.length - 1];
                var bookCoverUrl = '';
                var almaJSON = '';

                $.ajax({
                    type: "GET",
                    url: 'http://sp.library.miami.edu/external_scripts/newitems/cover_cache/'+almaId+'.json',
                    dataType: "text",
                    success: function (data) {
                        almaJSON = $.parseJSON(data);
                        if (almaJSON.length != 0) {
                            bookCoverUrl = almaJSON[almaId].book_cover;
                            myBookList.setBookCover(grandFather, bookCoverUrl);
                        }
                    },
                    error: function(xhr) {
                        myBookList.getBookMetadata(almaId, grandFather);
                    }
                });
            });
        },
        setBookCover : function (grandFather, bookCoverUrl) {

                var imgCover = document.createElement('img');
                imgCover.setAttribute('src', bookCoverUrl);
                grandFather.find(".item-image").prepend(imgCover);
                $("#new_books_container .item-image").addClass("remove-placeholder-cover");


            //set fallback image
            $( document ).ready(function() {
                var cover = $(".item-image img");
                var altCover = "../../assets/images/blank-cover.png";

                $('.item-image img').each(function() {

                    if($(this).attr('src') == "") {
                        console.log("no cover");
                        $(this).attr("src", altCover);
                    } else {
                        console.log("cover found");
                    }

                });  
            });
        },
        getBookMetadata : function (almaId, grandFather) {
            var newUrl = 'http://sp.library.miami.edu/external_scripts/newitems/pnx.php?alma_id=' + almaId;
            $.get(newUrl, function (data) {

                var isbn = $.parseJSON(data).search.isbn;
                if (Array.isArray(isbn)) {
                    for (var j = 0; j < isbn.length; j++) {
                        if (isbn[j].length === 13) {
                            isbn = isbn [j];
                            break;
                        }
                    }
                }

                var bookCoverUrl = "http://sp.library.miami.edu/external_scripts/newitems/bookcover.php?syndetics_client_code=miamih&image_size=LC&googleBooksKey=AIzaSyAcN6sHJbsrvKzbRJ1ksV48A2vCW2qGk20&isbn=" + isbn;

                $.get(bookCoverUrl, function (url){
                    myBookList.setBookCover(grandFather, url);
                    $.ajax({
                        type: "GET",
                        url: 'http://sp.library.miami.edu/external_scripts/newitems/updatealmacache.php',
                        data: {
                            "isbn": isbn,
                            "book_cover_url": url,
                            "alma_id": almaId
                        },
                        dataType: "text"
                    });
                });



            });
        }
    };
    return myBookList;
}

var bookList = bookList();
bookList.init();