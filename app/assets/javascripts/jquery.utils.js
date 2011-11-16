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
/*

Copyright (c) 2009 Stefano J. Attardi, http://attardi.org/

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

*/
(function($) {
    function toggleLabel() {
        var input = $(this);
        setTimeout(function() {
            var def = input.attr('title');
            if (!input.val() || (input.val() == def)) {
                input.prev('label').css('visibility', '');
                if (def) {
                    var dummy = $('<label></label>').text(def).css('visibility','hidden').appendTo('body');
                    input.prev('label').css('margin-left', dummy.width() + 3 + 'px');
                    dummy.remove();
                }
            } else {
                input.prev('label').css('visibility', 'hidden');
            }
        }, 0);
    };

    function resetField() {
        var def = $(this).attr('title');
        if (!$(this).val() || ($(this).val() == def)) {
            $(this).val(def);
            $(this).prev('label').css('visibility', '');
        }
    };

    $('.togglelabel > input, textarea').live('keydown', toggleLabel);
    $('.togglelabel > input, textarea').live('paste', toggleLabel);
    $('select').live('change', toggleLabel);

    $('.togglelabel > input, textarea').live('focusin', function() {
        $(this).prev('label').css('color', '#ccc');
    });
    $('.togglelabel > input, textarea').live('focusout', function() {
        $(this).prev('label').css('color', '#999');
    });

    $(function() {
        $('.togglelabel > input, textarea').each(function() { toggleLabel.call(this); });
    });

})(jQuery);
