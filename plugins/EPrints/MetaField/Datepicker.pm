package EPrints::MetaField::Datepicker;

use strict;
use warnings;

use EPrints::MetaField::Text;

BEGIN
{
	our( @ISA );
	@ISA = qw( EPrints::MetaField::Text );
}

sub get_property_defaults
{
	my( $self ) = @_;
	my %defaults = $self->SUPER::get_property_defaults;

	$defaults{format} = "DD/MM/YYYY";
	$defaults{dropdowns} = 1;
	$defaults{range} = 0;

	return %defaults;
}

#for use when rendering a date picker in a compound field context - need to set field's render_input property (see Lists sortable field for example)
sub render_input_field_compound
{
	my( $self, $session, $value, $basename, $staff, $obj, $one_field_component ) = @_;
	my $maxlength = $self->get_max_input_size;
	my $size = ( $maxlength > $self->{input_cols} ?
					$self->{input_cols} : 
					$maxlength );

	my $input;
	my @classes = (
		"ep_form_text",
	);

	my $readonly = defined $self->get_property( "readonly" ) ? $self->get_property( "readonly" ) : undef;
	push @classes, "ep_readonly" if $readonly;

	if( defined($self->{dataset}) )
	{
		push @classes,
		join('_', 'ep', $self->{dataset}->base_id, $self->name);
	}

	$input = $session->render_noenter_input_field(
		class=> join(' ', @classes),
		name => $basename,
		id => $basename,
		value => $value,
		size => $size,
		readonly => $readonly,
		maxlength => $maxlength,
		'aria-labelledby' => $self->get_labelledby( $basename ),
		'aria-describedby' => $self->get_describedby( $basename, $one_field_component ) );

        my $random_id = "field_" . int(rand(1e16));
	my $format = $self->get_property( "format" );
	my $single = $self->get_property( "range" ) ? "false" : "true";
	my $dropdowns = $self->get_property( "dropdowns" ) ? "true" : "false";
	my $result = $session->make_element( "span", id=>$random_id );

	$result->appendChild( $input );

	my $script = <<EOS

  var selector = '#$random_id input';
  jQuery(selector).attr('autocomplete', 'off');

  jQuery(selector).daterangepicker({
      autoUpdateInput: false,
      singleDatePicker: $single,
      showDropdowns: $dropdowns,
      locale: {
          format: '$format',
          cancelLabel: 'Clear'
      }
  });

  jQuery(selector).on('apply.daterangepicker', function(ev, picker) {
      if ($single) {
          jQuery(this).val(picker.startDate.format('$format'));
      } else {
          jQuery(this).val(picker.startDate.format('$format') + ' - ' + picker.endDate.format('$format'));
      }
  });

  jQuery(selector).on('cancel.daterangepicker', function(ev, picker) {
      jQuery(this).val('');
  });

EOS
;
	$result->appendChild( $session->make_javascript( $script ) );

	return $result;
	return [ [ { el=>$result } ] ];
}

sub render_input_field_actual
{
	my( $self, $session, $value, $dataset, $staff, $hidden_fields, $obj, $basename ) = @_;

        my $random_id = "field_" . int(rand(1e16));
	my $format = $self->get_property( "format" );
	my $single = $self->get_property( "range" ) ? "false" : "true";
	my $dropdowns = $self->get_property( "dropdowns" ) ? "true" : "false";

	my $text_field = $self->SUPER::render_input_field_actual(
		$session, $value, $dataset, $staff, $hidden_fields, $obj, $basename );

	my $result = $session->make_element( "div", id=>$random_id );

	$result->appendChild( $text_field );

	my $script = <<EOS

  var selector = '#$random_id input';

  jQuery(selector).attr('autocomplete', 'off');
  jQuery(selector).daterangepicker({
      autoUpdateInput: false,
      singleDatePicker: $single,
      showDropdowns: $dropdowns,
      locale: {
          format: '$format',
          cancelLabel: 'Clear'
      }
  });

  jQuery(selector).on('apply.daterangepicker', function(ev, picker) {
      if ($single) {
          jQuery(this).val(picker.startDate.format('$format'));
      } else {
          jQuery(this).val(picker.startDate.format('$format') + ' - ' + picker.endDate.format('$format'));
      }
  });

  jQuery(selector).on('cancel.daterangepicker', function(ev, picker) {
      jQuery(this).val('');
  });

EOS
;

	$result->appendChild( $session->make_javascript( $script ) );

	return $result;
}

1;
