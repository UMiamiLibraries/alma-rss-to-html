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
                var newUrl = 'http://sp.library.miami.edu/external_scripts/newbooks/pnx.php?alma_id=' + almaId;

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

		    var bookCoverUrl = "http://sp.library.miami.edu/external_scripts/newbooks/bookcover.php?syndetics_client_code=miamih&image_size=LC&isbn=" + isbn;
		    
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
