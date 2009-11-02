// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery.ajaxSetup({  
    'beforeSend': function (xhr) {xhr.setRequestHeader("Accept", "text/javascript"); }  
});

/**
 * jQuery Delay - A delay function
 * Copyright (c) 2009 Clint Helfers - chelfers(at)gmail(dot)com | http://blindsignals.com
 * Dual licensed under MIT and GPL.
 * Date: 7/01/2009
 * @author Clint Helfers
 * @version 1.0.0
 *
 * http://blindsignals.com/index.php/2009/07/jquery-delay/
 */

jQuery.fn.delay = function(time, name) {
    return this.queue( ( name || "fx" ), function() {
        var self = this;
        setTimeout(function() { $.dequeue(self); } , time );
    } );
};
//

jQuery.fn.submitWithAjax = function() {
  this.submit( function() {
    $.post(this.action, $(this).serialize(), null, "script");
    return false;
  });
  return this;
};

jQuery.fn.ajaxGet = function() {
	this.click( function(event) {
		event.preventDefault();
		$.get(this.href, null, null, "script");
		return false;
	} );
	return this;
};

$(document).ready(function(){	
	
	$('#params_pmid').bind('keyup', function () {
		var pmid = $(this).val();
		var regx = /^\d{5,8}$/;
		
		if ( regx.test(pmid) ) {
			$('#params_pmid_button').show();
			$('#params_pmid_message').hide();
		} else {
			$('#params_pmid_button').hide();
			$('#params_pmid_message').show().html('Pubmed ID should be between 5 and 8 digits long without any letters');
		}	
	});
	
	//fade flash div
	$('#flash').delay(5000).slideUp("slow");
	
	
	// click on item title to show the details
	$('.item .head').click(function() {
		$(this).next().toggle();
		return false;
	}).next().hide();
	
	
	//autocomplete for journal long_title in new paper
	$('#paper_journal_attributes_long_title').autocomplete('/journal_list');


	//update paper fields from pubmed instead of loading preview
	$('#pmid_submit_form').submitWithAjax();
	
	//improve delete links -- confirmation on page
	$('a.delete').click(function(event) {
		event.preventDefault();
		var original = $(this).closest('div.original');
		var confirm = original.next('div.confirm');
		var item = original.closest('div.item');
		original.hide();
		confirm.show();
		item.addClass('highlight');
	});
	
	$('a.delete-cancel').click(function (event) {
		event.preventDefault();
		var confirm = $(this).closest('div.confirm');
		var original = confirm.prev('div.original');
		var item = original.closest('div.item');
		confirm.hide();
		original.show();
		item.removeClass('highlight');
	})
	
	$('a.delete-confirm').click(function(event) {
		event.preventDefault();
		var form = $(this).closest('form');
		var item = $(this).closest('div.item');
		$.ajax({
		  type: "DELETE",
		  url: form[0].action,
		  success: function() {
		    item.slideUp(600, function() {
	            $(this).remove();
	    	});
		  }
		});
		return false;
	})
	
	//date select
	$('.date_select').datepicker();

		
	//form validation
	$('form').not('.skip_validation').validate({
		ignore: ".ignore",
		errorClass:"invalid",
		errorElement: "em"

	});
	
	$('#new_paper').validate({
		ignore: ".ignore",
		errorClass:"invalid",
		errorElement: "em"

	});
	//fix cancel button function
	$("input[name='cancel']").bind('click', function () {
		$(':input').addClass('ignore');
	     $(this).parent('form').submit();
		});
	




});

