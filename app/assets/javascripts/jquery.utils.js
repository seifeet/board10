(function($){

  //auto-refresh
  $.autoRefresh = function() {
    if ( typeof this.intervalSet == 'undefined' ) {
      setInterval(function() {
       /*
        $('.refreshable').find('form').each(function(index) {
        alert(index);
        });
       */
      $('.refreshable').find('form').submit();
      }, 10000); //10 seconds
		
      this.intervalSet = true;
    }
  };
  
  // transform buttons into context menu
  $.toggleContextMenu = function(element) {
        element.find(".hidable").hide();
        element.bind("contextmenu", function(e) {
            $(this).find(".hidable").toggle(500);
            return false;
        });
  };
    
})(jQuery);