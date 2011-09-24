// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
//

if(history && history.pushState ) {

	$(function() {
		$("#users .apple_pagination a, #groups .apple_pagination a, #public_postings .apple_pagination a, #user_postings .apple_pagination a").live("click", function() {
			$(".apple_pagination").html("<img src='../../assets/loading.gif' alt='Loading' />");
			$.getScript(this.href);
			history.pushState(null, document.title, this.href);
			return false;
		});
		
	    $("#user_groups #load_group a").live("click", function() {
			$("#group_title").html("<img src='../../assets/loading.gif' alt='Loading' />");
			//$("#group_title").html("Loading...");
			$.getScript(this.href);
			history.pushState(null, document.title, this.href);
			return false;
		});

		$(window).bind("popstate", function() {
			$.getScript(location.href);
		});

		$("#users_search").submit(function() {
			$.get(this.action, $(this).serialize(), null, "script");
			history.pushState(null, document.title, $("#users_search").attr("action") + "?" + $("#users_search").serialize());
			return false;
		});
		
	    $("#groups_search").submit(function() {
			$.get(this.action, $(this).serialize(), null, "script");
			history.pushState(null, document.title, $("#groups_search").attr("action") + "?" + $("#groups_search").serialize());
			return false;
		});

		$("#new_posting").live("ajax:complete", function(event, xhr, status) {
			$('#posting_content').val('');
		});
	});
}
