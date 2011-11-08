(function($){
  var settings;
  
  $.bottomlessPagination = function(callerSettings) {
    settings = $.extend({
        ajaxLoaderPath:'../../assets/loading.gif',
        results:'#user_postings .generic_container',
        objName:'posts',
        callback:null
    },callerSettings||{});
    
    settings.imgLoader = new Image();
    settings.imgLoader.src = settings.ajaxLoaderPath;
    settings.href = $(".next_page").attr("href");

    // Get the total number of pages from the last numbered pagination link
    last_pagination_link = $(".apple_pagination a").not(".next_page, .previous_page").last();
    
    if (last_pagination_link.length)
    {
        settings.total_pages = getPageNumber(last_pagination_link.attr('href'));

        // If pagination exists, hide existing and append the bottomless pagination html
        if ($('div.apple_pagination').size() > 0){
          $('div.apple_pagination').wrap("<div class='pagination_links'></div>").hide();
          
          $('.pagination_links').append(
            "<div class='live_pagination clearfix'><div>" +
              "<a class='more_links'>More " + settings.objName + "<span class='icon'></span></a>" +
            "</div></div>"
          );

          // Setup the loader. If no image provided use a text message. Loader is initially hidden.
          if ((settings.ajaxLoaderPath == '') || (settings.ajaxLoaderPath == null)) {
            $(".more_links").after("<div class='now_loading'>Loading...</div>");
          } else {
            $(".more_links").after("<div class='now_loading'><img src='"+settings.imgLoader.src+"' /></div>");
          }
          
          $(".now_loading").hide();
      }
    }
    
    $(".more_links").click(function(e){
      e.preventDefault();
      $(".more_links").hide();
      $(".now_loading").show();
      
      // Get the data & update links
      $.get(settings.href,function(data){
          $(settings.results).addrows(data);
          $(".now_loading").hide();
          $(".more_links").show();
        }
      );
      return false;
    });
    
    $.fn.addrows = function(data) {
        if(typeof settings.href !== 'undefined' && settings.href.length) {
            curr_page = getPageNumber(settings.href);
            $(data).find('.posting_element').each(function(index) {
                $(settings.results).append($(this));
                $.toggleContextMenu($(this));
            }); 

            // Replace live pagination if there are no more results, else update the href for the next page
            if (curr_page == settings.total_pages) {
                $('.live_pagination').remove();
                $('.pagination_links').append('<div class="live_pagination"></div>');
                return false;
            } else {
                next_page = curr_page + 1;
                settings.href = settings.href.replace('page=' + curr_page, 'page=' + next_page.toString());
            }

            if (settings.callback) settings.callback();
        } else {
            $('.live_pagination').remove();
            $('.pagination_links').append('<div class="live_pagination"></div>');
            return false;
        }
    };
    
    function getPageNumber(url) {
        pageRE = /page=(\d+)/;
        pageMatch = url.match(pageRE);
        return parseInt(pageMatch[1]);
    };
    
  };
    
})(jQuery);