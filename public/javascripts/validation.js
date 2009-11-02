

jQuery.fn.validate = function(options) {
	
	// allow suppresing validation by adding a cancel class to the submit button
	this.find("input[name='submit']").click(function() {
		this.submitWithAjax(function (event) {
			event.preventDefault();
			$.post(this.action, $(this).serialize(), function(data) {
				
				alert(data.errors);
			}, "json");
		})
	});
}