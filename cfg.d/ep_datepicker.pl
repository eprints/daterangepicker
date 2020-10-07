# adds a datepicker to workflow date fields.
# set $c->{use_workflow_datepicker} = 1 to enable

$c->{workflow_datepicker} = sub
{
  my ( $session, $basename ) = @_;

  my $use_datepicker = $session->config( "use_workflow_datepicker" );
  return undef unless ( defined $use_datepicker && $use_datepicker == 1 );

  my $picker =  $session->make_element( "div", class=>"ep_datepicker" );

  $picker->appendChild( $session->make_element("input", type=>"text", id=>$basename."_datepicker", size=>10, style=>"display:none" ) );
  my $js = <<JS;
jQuery( function()
{ jQuery( "#${basename}_datepicker" ).datepicker(
    { onSelect: function() { ep_datepicker_post("${basename}"); }
  });
});
JS
  $picker->appendChild( $session->make_javascript( $js ) );

  my $img = $session->make_element("img", src=>"/images/cal_small.png", class=>"ep_datepicker_icon", onclick=>"jQuery('#".$basename."_datepicker').trigger('click');" );
  my $link = $session->make_element("a", onclick=>"ep_datepicker_pre('".$basename."'); jQuery('#".$basename."_datepicker').datepicker('show');" );
  $link->appendChild($img);
  $picker->appendChild($link);

  return $picker;
}

