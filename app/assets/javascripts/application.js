// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require_tree .
//

if(history && history.pushState ) {

	$(function() {

		//$("#users .apple_pagination a, #boards .apple_pagination a, #public_postings .apple_pagination a, #user_postings .apple_pagination a").live("click", function() {
		$("#user_postings .apple_pagination a, #search_container .apple_pagination a, .generic_container .apple_pagination a, #public_postings .apple_pagination a").live("click", function() {
			$(".loading").html("<img src='../../assets/loading.gif' alt='Loading' />");
			$.getScript(this.href);
			history.pushState(null, document.title, this.href);
			return false;
		});
		// #msg board school #                    #groups boards
	    $("#top_title_nav a, ._sub_title_action a, .nav_link a, .posting_element .action_button a, .close_button a").live("click", function() {
			$(".loading").html("<img src='../../assets/loading.gif' alt='Loading' />");
			//$('.action_tab').slideUp('fast', 0);
			$.getScript(this.href);
			history.pushState(null, document.title, this.href);
			return false;
		});
		
        /* do not remove this function anymore
         * (withot it a new page will not reload after history events (e.g. Back)) */
		$(window).bind("popstate", function() {
			$.getScript(location.href);
		});

		$("#users_search").submit(function() {
			$(".loading").html("<img src='../../assets/loading.gif' alt='Loading' />");
			$.get(this.action, $(this).serialize(), null, "script");
			history.pushState(null, document.title, $("#users_search").attr("action") + "?" + $("#users_search").serialize());
			return false;
		});
		
	    $("#boards_search").submit(function() {
	    	$(".loading").html("<img src='../../assets/loading.gif' alt='Loading' />");
			$.get(this.action, $(this).serialize(), null, "script");
			history.pushState(null, document.title, $("#boards_search").attr("action") + "?" + $("#boards_search").serialize());
			return false;
		});
		
	    $("#schools_search").submit(function() {
	    	$(".loading").html("<img src='../../assets/loading.gif' alt='Loading' />");
			$.get(this.action, $(this).serialize(), null, "script");
			history.pushState(null, document.title, $("#schools_search").attr("action") + "?" + $("#schools_search").serialize());
			return false;
		});
		
		$("#tab_schools_search").submit(function() {
			$(".loading").html("<img src='../../assets/loading.gif' alt='Loading' />");
			$.get(this.action, $(this).serialize(), null, "script");
			history.pushState(null, document.title, $("#tab_schools_search").attr("action") + "?" + $("#tab_schools_search").serialize());
			return false;
		});
		
		$("#new_user_board").submit(function() {
			$(".loading").html("<img src='../../assets/loading.gif' alt='Loading' />");
			$.get(this.action, $(this).serialize(), null, "script");
			history.pushState(null, document.title, this.href);
			return false;
		});
		
		/*$(".inline_right .new_message").submit(function() {
			$.get(this.action, $(this).serialize(), null, "script");
			history.pushState(null, document.title, $("#tab_schools_search").attr("action") + "?" + $("#tab_schools_search").serialize());
			return false;
		});*/
		
		/*$("#tab_schools_search input").keyup(function() {
			$.get($("#tab_schools_search").attr("action"), $("#tab_schools_search").serialize(), null, "script");
			history.pushState(null, document.title, $("#tab_schools_search").attr("action") + "?" + $("#tab_schools_search").serialize());
			return false;
		});*/
		
		$(".join_board, .join_school").submit(function() {
			$(".loading").html("<img src='../../assets/loading.gif' alt='Loading' />");
			$.get(this.action, $(this).serialize(), null, "script");
			//history.pushState(null, document.title, this.href);
			return false;
		});

		$("#new_posting").live("ajax:complete", function(event, xhr, status) {
			$('#posting_content').val('');
		});
	});
}

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

    $('input, textarea').live('keydown', toggleLabel);
    $('input, textarea').live('paste', toggleLabel);
    $('select').live('change', toggleLabel);

    $('input, textarea').live('focusin', function() {
        $(this).prev('label').css('color', '#ccc');
    });
    $('input, textarea').live('focusout', function() {
        $(this).prev('label').css('color', '#999');
    });

    $(function() {
        $('input, textarea').each(function() { toggleLabel.call(this); });
    });

})(jQuery);
