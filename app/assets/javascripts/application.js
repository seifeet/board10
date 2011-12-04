// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require tinymce-jquery
//= require_tree .
//

if(history && history.pushState ) {

    $(function() {

        $(".clickable a").live("click", function() {
            $(".loading").html("<img src='../../assets/loading.gif' alt='Loading' />");
            $.getScript(this.href);
            history.pushState(null, document.title, this.href);
            return false;
        });
        
        /* do not remove this function anymore
         * (withot it a new page will not reload after history events (e.g. Back)) */
        /*
        $(window).bind("popstate", function() {
            $.getScript(location.href);
        });*/

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
        
        $("#tab_posts_search").submit(function() {
            $(".loading").html("<img src='../../assets/loading.gif' alt='Loading' />");
            $.get(this.action, $(this).serialize(), null, "script");
            history.pushState(null, document.title, $("#tab_posts_search").attr("action") + "?" + $("#tab_posts_search").serialize());
            return false;
        });
        
        $("#tab_boards_search").submit(function() {
            $(".loading").html("<img src='../../assets/loading.gif' alt='Loading' />");
            $.get(this.action, $(this).serialize(), null, "script");
            history.pushState(null, document.title, $("#tab_boards_search").attr("action") + "?" + $("#tab_boards_search").serialize());
            return false;
        });
        
        $("#tab_schools_search").submit(function() {
            $(".loading").html("<img src='../../assets/loading.gif' alt='Loading' />");
            $.get(this.action, $(this).serialize(), null, "script");
            history.pushState(null, document.title, $("#tab_schools_search").attr("action") + "?" + $("#tab_schools_search").serialize());
            return false;
        }); 
        
        $("#tab_invite_search").submit(function() {
            $(".loading").html("<img src='../../assets/loading.gif' alt='Loading' />");
            $.get(this.action, $(this).serialize(), null, "script");
            history.pushState(null, document.title, $("#tab_invite_search").attr("action") + "?" + $("#tab_invite_search").serialize());
            return false;
        });
        
        $("#tab_user_search").submit(function() {
            $(".loading").html("<img src='../../assets/loading.gif' alt='Loading' />");
            $.get(this.action, $(this).serialize(), null, "script");
            history.pushState(null, document.title, $("#tab_user_search").attr("action") + "?" + $("#tab_user_search").serialize());
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
        
        $(".submitable").submit(function() {
            $(".loading").html("<img src='../../assets/loading.gif' alt='Loading' />");
            $.get(this.action, $(this).serialize(), null, "script");
            //history.pushState(null, document.title, this.href);
            return false;
        });
    });
}

$(function() {
	
	$(".tips").tipTip();

    $("#new_posting").live("ajax:complete", function(event, xhr, status) {
        $('#editor').val('');
        $('#posting_content').val('');
        return false;
    });
 
    $(".posting_element").live("ajax:complete", function(event, xhr, status) {
        if ( status == "success" ){
          $(this).hide();
          return false;
        } else {
          // just skip on failure //alert("Can't do it! (" + status + ")");
        }
    });
    
    $('#whatsNew .small_container').jscroll({duration:20000});
    
    $(".voting").live("ajax:complete", function(event, xhr, status) {
        if ( status == "success" ){
          $(this).find(':input.togglable').toggleClass('hidden').slideToggle('slow');
          return false;
        } else {
          // just skip on failure //alert("Can't do it! (" + status + ")");
        }
    });
  
});
