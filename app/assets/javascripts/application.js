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
		$("#search_container .apple_pagination a, .generic_container .apple_pagination a, #public_postings .apple_pagination a").live("click", function() {
			$(".apple_pagination").html("<img src='../../assets/loading.gif' alt='Loading' />");
			$.getScript(this.href);
			history.pushState(null, document.title, this.href);
			return false;
		});
		// #msg board school #                    #groups boards
	    $("#top_title_nav a, ._sub_title_action a, .nav_link a, .posting_element .action_button a").live("click", function() {
			//$("._sub_title").html("<img src='../../assets/loading.gif' alt='Loading' />");
			$("#_sub_title").html("Loading...");
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
			$.get(this.action, $(this).serialize(), null, "script");
			history.pushState(null, document.title, $("#users_search").attr("action") + "?" + $("#users_search").serialize());
			return false;
		});
		
	    $("#boards_search").submit(function() {
			$.get(this.action, $(this).serialize(), null, "script");
			history.pushState(null, document.title, $("#boards_search").attr("action") + "?" + $("#boards_search").serialize());
			return false;
		});
		
	    $("#schools_search").submit(function() {
			$.get(this.action, $(this).serialize(), null, "script");
			history.pushState(null, document.title, $("#schools_search").attr("action") + "?" + $("#schools_search").serialize());
			return false;
		});
		
		$("#tab_schools_search").submit(function() {
			$.get(this.action, $(this).serialize(), null, "script");
			history.pushState(null, document.title, $("#tab_schools_search").attr("action") + "?" + $("#tab_schools_search").serialize());
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

		$("#new_posting").live("ajax:complete", function(event, xhr, status) {
			$('#posting_content').val('');
		});
		
		$("#datepicker").datepicker();
	});
}
