// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function(){

	$('#tabs').tabs({ 
   	 	load: function(event, ui) {
		        $('a', 'main').click(function() {
		            $('main').load(this.href);
		            return false;
		        });
		    }
		});


});

 jQuery.ajaxSetup({  
     'beforeSend': function (xhr) {xhr.setRequestHeader("Accept", "text/javascript")}  
 });