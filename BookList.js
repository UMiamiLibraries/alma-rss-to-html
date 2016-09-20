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
                            sortAscending: false
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

                    //show author labels when sorting by author
                    $( document ).ready(function() {
                        var authorBtn = $('button[data-sort-value="author"]');

                        if (authorBtn.hasClass('active-sort')) {
                            $('#new_books_container .label-author').show();
                            $('#new_books_container .label-title').show();
                            $('#new_books_container .item-title').hide();
                            $('#new_books_container .item-author').hide();
                        }
                        else {
                            $('#new_books_container .label-author').hide();
                            $('#new_books_container .label-title').hide();
                            $('#new_books_container .item-title').show();
                            $('#new_books_container .item-author').show();
                        }
                    });

                    //placeholder for empty author
                    $('#new_books_container .item-author').each(function() {
                        if($(this).is(':empty')){
                            $('#new_books_container .item-author').append('<span>[Click for details]</span>');
                        }
                    });

                    $('#new_books_container .label-author').each(function() {
                        if($(this).is(':empty')){
                            $('#new_books_container .label-author').append('<span>[Click for details]</span>');
                        }
                    });



                }); //end .getScript

            

        },
        urlExists: function (url){
            var result = true;

            $.ajax({
                url:url,
                type:'HEAD',
                async: false,
                error: function()
                {
                    result =false;
                }
            });

            debugger;
            return result;
        },
        iterateUrls: function () {
            var elements = document.querySelectorAll('[property="url"]');
            var almaJSON = '';
            var almaCacheFileExists = myBookList.urlExists('http://sp.library.miami.edu/external_scripts/newitems/cover_cache/alma_ids.json');

            debugger;

            if (almaCacheFileExists){
                $.ajax({
                    type: "GET",
                    url: 'http://sp.library.miami.edu/external_scripts/newitems/cover_cache/alma_ids.json',
                    dataType: "text",
                    async: false,
                    success: function (data) {
                        almaJSON = $.parseJSON(data);
                    }
                });
            }

            debugger;

            $('.item-title a').each(function(i) {
                var url = $(this).attr('href');
                var grandFather = $(this).parent().parent();
                var split = url.split(",");
                var almaId = split[split.length - 1];
                var bookCoverUrl = '';

                if (almaJSON.length != 0) {
                    debugger;
                    if (almaJSON.hasOwnProperty(almaId)) {
                        bookCoverUrl = almaJSON[almaId].book_cover;
                        myBookList.setBookCover(grandFather, bookCoverUrl);
                    } else {
                        myBookList.getBookMetadata(almaId, grandFather);
                    }
                }else{
                    myBookList.getBookMetadata(almaId, grandFather);
                }
            });
        },
        setBookCover : function (grandFather, bookCoverUrl) {
            $.get(bookCoverUrl, function(data) {
                var imgCover = document.createElement('img');
                imgCover.setAttribute('src', data);
                grandFather.find(".item-image").prepend(imgCover);
                $("#new_books_container .item-image").addClass("remove-placeholder-cover");
            });

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

                var bookCoverUrl = "http://sp.library.miami.edu/external_scripts/newitems/bookcover.php?syndetics_client_code=miamih&image_size=LC&isbn=" + isbn;
                myBookList.setBookCover(grandFather, bookCoverUrl);

                $.ajax({
                    type: "GET",
                    url: 'http://sp.library.miami.edu/external_scripts/newitems/updatealmacache.php',
                    data: {
                        "isbn": isbn,
                        "book_cover_url": bookCoverUrl,
                        "alma_id": almaId
                    },
                    dataType: "text"
                });

            });
        }
    };
    return myBookList;
}

var bookList = bookList();
bookList.init();