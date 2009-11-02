jQuery.validator.addMethod("phone", function(phone_number, element) {
    phone_number = phone_number.replace(/\s+/g, ""); 
	return this.optional(element) || phone_number.length > 9 &&
		phone_number.match(/^[0-9]\d{2}-\d{3}-\d{4}$/);
}, "Please specify a valid phone number");

jQuery.validator.addMethod("pmid", function(pubmed_id, element) {
	return this.optional(element) || pubmed_id.match(/^\d{5,8}$/);
});

jQuery.validator.addMethod("emaila", function(email_address, element) {
	return this.optional(element) || email_address.match(/^(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6}$/);
}, "Please enter a valid email address");

jQuery.validator.addMethod("year", function(y, element) {
	var time = new Date();
	var current_year = time.getFullYear();
	var year = parseInt(y,10);
	return this.optional(element) || y.match(/^\d{4}/) && year > 1950 && year <= current_year;
}, "Year must be between 1950 and now" );

jQuery.validator.addMethod("volume", function(vol, element) {
	return this.optional(element) || vol.match(/^\d{1,3}$/);
}, "Volume should be all digits and between 1 and 999");

jQuery.validator.addMethod("issue", function(issue, element) {
	return this.optional(element) || issue.match(/^\d{1,2}$/);
}, "Issue should be a number between 1 and 99" );

jQuery.validator.addMethod('pages', function(pages, element) {
	return this.optional(element) || pages.match(/^[0-9\-]+$/);
}, "Please enter a valid page or pages");

jQuery.validator.addMethod('author_list', function(list, element) {
	return this.optional(element) || list.match(/^[A-Za-z, -]+$/);
}, "Author list should be first name last name, separated by commas, ie John Smith, George Washington");

jQuery.validator.addMethod("alpha", function(value, element) {
	return this.optional(element) || value.match(/^\w\s\D$/);
}, "Letters, spaces or underscores only please");

jQuery.validator.addMethod("isbn", function(value,element) {
	value = value.replace('x', 'X')
	value = value.replace(/[ \-]/g, "")
	if (value.length == 10) {
		if (value[9] == 'X') { var last = 10;} else {var last = value[9]; }
		var isbn_wt_sum = (10*value[0]) + (9*value[1]) + (8*value[2]) + (7*value[3]) + (6*value[4]) + (5*value[5]) + (4*value[6]) + (3*value[7]) + (2*value[8]) + 1*last;
		if (isbn_wt_sum % 11 == 0) { var valid_checksum = true; } else { var valid_checksum = false;}
	} else if (value.length == 13) {
		var isbn_wt_sum = value[0] + 3*value[1] + 1*value[2] + 3*value[3] + 1*value[4] + 3*value[5] + 1*value[6] + 3*value[7] + 1*value[8] + 3*value[9] + 1*value[10] + 3*value[11] + 1*value[12];
		if (isbn_wt_sum % 10 == 0) { var valid_checksum = true; } else { var valid_checksum = false;}
	} else {var valid_checksum = false; }
 
	return this.optional(element) || value.match(/^(97(8|9))?\d{9}(\d|X)$/) && valid_checksum;
}, "Please enter a valid ISBN-10 or ISBN-13 number, ie 0-8436-1072-7")