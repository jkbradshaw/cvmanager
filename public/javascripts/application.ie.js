$.uicornerfix = function(r){
  DD_roundies.addRule('.ui-corner-all', r);
  DD_roundies.addRule('.ui-corner-top', r+' '+r+' 0 0');
  DD_roundies.addRule('.ui-corner-bottom', '0 0 '+r+' '+r);
  DD_roundies.addRule('.ui-corner-right', '0 '+r+' '+r+' 0');
  DD_roundies.addRule('.ui-corner-left', r+' 0 0 '+r);
  DD_roundies.addRule('.ui-corner-tl', r+' 0 0 0');
  DD_roundies.addRule('.ui-corner-tr', '0 '+r+' 0 0');
  DD_roundies.addRule('.ui-corner-br', '0 0 '+r+' 0');
  DD_roundies.addRule('.ui-corner-bl', '0 0 0 '+r);
};

$.uicornerfix('4px');

$('.ui-corner-top').addClass('cornerfix');