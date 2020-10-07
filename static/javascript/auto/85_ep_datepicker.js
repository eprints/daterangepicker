function ep_datepicker_pre(id)
{
  // console.log("in ep_datepicker_pre " + id);
  var y = jQuery( "#" + id + "_year" ).val();
  var m = jQuery( "#" + id + "_month" ).val();
  var d = jQuery( "#" + id + "_day" ).val();
  if( y == "" ) { y = "2020"; }
  if( m == "00" ) { m = "01"; }
  if( d == "00" ) { d = "01"; }
  jQuery( "#" + id + "_datepicker" ).val( m+"/"+d+"/"+y ); // us format
  // console.log( jQuery( "#" + id + "_datepicker" ).val() );
}

function ep_datepicker_post(id)
{
  // console.log("in ep_datepicker_post " + id);
  var string = jQuery( "#" + id + "_datepicker" ).val(); // us format
  var parts = string.split("/", 3)
  var y = jQuery( "#" + id + "_year" ).val( parts[2] );
  var m = jQuery( "#" + id + "_month" ).val( parts[0] );
  var d = jQuery( "#" + id + "_day" ).val( parts[1] );  
}
