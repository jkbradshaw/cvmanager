(function($) {
	$.fn.inPlaceEdit = function(options) {
		var opts = $.extend({}, $.fn.inPlaceEdit.defaults, options);
		
		var $table = $(this);	
	
		var $selected = $('td.' + opts.editable + ':first',$table)
		$selected.addClass(opts.selected);
		$table.data('selected',$selected)
		$('td.' + opts.editable,$table).each( function() {
			$(this).bind('click', function() {
				$(this).focus();
				edit($(this));
				} );
			$(this).bind('focus',  function() {
				$table.data('selected').blur();
				$(this).addClass(opts.selected);
				
				var windowTop = $(window).scrollTop();
				var windowBottom = windowTop + $(window).height();
				var elementTop = $(this).offset().top;
				var elementBottom = elementTop + $(this).height();
				
				if (windowTop > elementTop) {
					$(window).scrollTop(elementTop);
				} else if (windowBottom < elementBottom) {
					$(window).scrollTop(elementBottom - $(window).height());
				}
				
				$table.data('selected',$(this))
				return $(this);
				
				});
			$(this).bind('blur',  function() {
				$(this).removeClass(opts.selected);
				});

		});
	
		$(document).bind('keydown',function(e) {
			var code = (e.keyCode ? e.keyCode : e.which);
			$selected = $table.data('selected');
			switch(code) {
				case 13: 	
					e.preventDefault();
					edit($table.data('selected'));
					break;
						
				case 38: 	
					e.preventDefault(); 
					nextUp($selected).focus();
					break;
						
				case 40: 	
					e.preventDefault();
					nextDown($selected).focus();
					break;
						
				case 37: 	
					e.preventDefault();
					nextLeft($selected).focus();
					break;
						
				case 39:
				 	e.preventDefault();
					nextRight($selected).focus();
					break;
			}
		});
		
		
	}
	
	$.fn.inPlaceEdit.defaults = {
		selected: 'selected',
		editable: 'editable'
	};
	
	function edit($cell) {
		var $original = $cell.find('span.original');
		var original_value = $original.text();
		var $edit = $cell.find('span.edit');
		var $form = $edit.find('form');
		var $input = $edit.find(':input[type!="hidden"]');

		$original.hide();
		$edit.show();
		$input.val(original_value);
		$input.focus().select();
		
		//not the right way to do this but it works for now
		$input.bind('keydown', function(e) {
			var code = (e.keyCode ? e.keyCode : e.which);
			switch(code) {
				case 13:
					$.ajax({
						url: $form[0].action,
						type: 'PUT',
						data: $form.serialize(),
						dataType: 'json',
						success: function(data) {
							if (data.success) {
								$original.text(data.new_value);
								$edit.hide();
								$original.show();
							} else { $('#error_messages').show().html(data.msg[0]);	}
						},
						error: function() { $('#error_messages').show().html('Some other error');}
					});
					$input.unbind('keydown');
					break;
				case 27:
					$edit.hide();
					$original.show();
					$input.unbind('keydown');
					break;
			}

		});

		$input.blur(function(event) {
			$edit.hide();
			$original.show();
			$('#error_messages').html('').hide();
			$input.unbind('keydown');
		});
	}
	
	function nextDown($cell) {
		var column = $cell.prevAll('td').size() + 1;
		var nextrow = $cell.closest('tr:not("tr:has(th)")').next('tr:not("tr:has(th)")');
		if (nextrow.size() > 0) { 
			return nextrow.children('td:nth-child(' + (column) + ')'); 
			} else { return $cell; }
	};
	
	function nextUp($cell) {
		var column = $cell.prevAll('td').size() + 1;
		var nextrow = $cell.closest('tr:not("tr:has(th)")').prev('tr:not("tr:has(th)")')
		if (nextrow.size() > 0) { return nextrow.children('td:nth-child(' + (column) + ')'); }
		else {	return $cell; }
	};
	
	function nextLeft($cell) {
		var $previous = $cell.prevAll('td.editable');
		var s = $previous.size();
		if (s > 0) { return $cell.prev(); } else { return $cell; }
	};
	
	function nextRight($cell) {
		var $nextone = $cell.nextAll('td.editable');
		if ($nextone.size() > 0) { return $cell.next(); } else {return $cell; }
	};
	
})(jQuery);
	