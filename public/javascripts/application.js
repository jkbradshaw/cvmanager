// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery.ajaxSetup({  
    'beforeSend': function (xhr) {xhr.setRequestHeader("Accept", "text/javascript")}  
});

jQuery.fn.submitWithAjax = function() {
  this.submit( function() {
    $.post(this.action, $(this).serialize(), null, "script");
    return false;
  });
  return this;
};

$(document).ready(function(){

	$('#params_pmid_button').hide();
	
	function disable_pmid_search() {
		$('#params_pmid_button').hide();
		$('#params_pmid_message').show().html('Pubmed ID should be between 5 and 10 digits long without any letters');
	}
	
	function enable_pmid_search() {
		$('#params_pmid_button').show();
		$('#params_pmid_message').hide();
	}
	
	$('#params_pmid').bind('keyup', function () {
		var pmid = $(this).val();
		var regx = /^\d{5,10}$/
		
		if ( regx.test(pmid) ) {
			enable_pmid_search();
		} else {
			disable_pmid_search();
		}	
	});
	
	// click on publication title to show the entire publication
	$('.publication .head').click(function() {
		$(this).next().toggle();
		return false;
	}).next().hide();
	
	$('.item .head').click(function() {
		$(this).next().toggle();
		return false;
	}).next().hide();
	
	
	//autocomplete for journal long_title in new paper
	$('#paper_journal_attributes_long_title').autocomplete('/journal_list')


	//update paper fields from pubmed instead of loading preview
	$('#pmid_submit_form').submitWithAjax();
	


});

