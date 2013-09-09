package Device::RadioThermostat;

use strict;
use warnings;

use 5.010_001;
our $VERSION = '0.01';

use Carp;
use Mojo::UserAgent;
use Data::Printer;

sub new {
    my ( $class, %args ) = @_;
    my $self = {
        address => $args{address},
        ua      => Mojo::UserAgent->new() };
    croak 'Must pass address to new.' unless $self->{address};

    return bless $self, $class;
}

sub tstat {
    my $self = shift;
    return $self->_ua_get('/tstat');
}

sub set_mode {
    my ( $self, $mode ) = @_;
    return $self->_ua_post( '/tstat', { tmode => $mode } );
}

sub get_target {
    my ($self) = @_;
    my $mode = $self->tstat->{tmode};
    return if $mode == 0;
    my $targets = $self->get_targets();
    if ( $mode == 1 ) {
        return $targets->{t_heat};
    }
    elsif ( $mode == 2 ) {
        return $targets->{t_cool};
    }
    else {
        return [ $targets->{t_cool}, $targets->{t_heat} ];
    }
}

sub get_targets {
    my ($self) = @_;
    return $self->_ua_get('/tstat/ttemp');
}

sub temp_heat {
    my ( $self, $temp ) = @_;
    return $self->_ua_post( '/tstat', { t_heat => $temp } );
}

sub temp_cool {
    my ( $self, $temp ) = @_;
    return $self->_ua_post( '/tstat', { t_cool => $temp } );
}

sub remote_temp {
    my ($self) = @_;
    return $self->_ua_get('/tstat/remote_temp');
}

sub disable_remote_temp {
    my ($self) = @_;
    return $self->_ua_post( '/tstat/remote_temp', { rem_mode => 0 } );
}

sub set_remote_temp {
    my ( $self, $temp ) = @_;
    return $self->_ua_post( '/tstat/remote_temp', { rem_temp => $temp } );
}

sub _ua_post {
    my ( $self, $path, $data ) = @_;
    my $transaction
        = $self->{ua}->post( $self->{address} . $path, json => $data );
    if ( my $response = $transaction->success ) {
        my $result = $response->json;

        # return $result;
        return exists( $result->{success} ) ? 1 : 0;
    }
    else {
        my ( $err, $code ) = $transaction->error;
        carp $code ? "$code response: $err" : "Connection error: $err";
        return;
    }
}

sub _ua_get {
    my ( $self, $path ) = @_;
    my $transaction = $self->{ua}->get( $self->{address} . $path );
    if ( my $response = $transaction->success ) {
        return $response->json;
    }
    else {
        my ( $err, $code ) = $transaction->error;
        carp $code ? "$code response: $err" : "Connection error: $err";
        return;
    }
}

1;
__END__

=encoding utf-8

=head1 NAME

Device::RadioThermostat - Access Radio Thermostat Co of America (3M-Filtrete) WiFi thermostats

=head1 SYNOPSIS

  use Device::RadioThermostat;
  my $thermostat = Device::RadioThermostat->new( address => "http://$ip");


=head1 DESCRIPTION

Device::RadioThermostat is a perl module for accessing the API of thermostats
manufactured by Radio Thermostat Corporation of America.  3M-Filtrete themostats
with WiFi are OEM versions manufactured by RTCOA.

=head1 METHODS

=head2 new( address=> 'http://192.168.1.1')

Constructor takes named parameters.  Currently only C<address> which should be
the HTTP URL for the thermostat.

=head2 tstat

Retrieve lots of infos from the thermostat.  Your goto for the 411 on your thermostat.

=head2 set_mode

Takes a single integer argument for your desired mode. Values are 0 - OFF, 1 -
HEAT, 2 - COOL, 3 - AUTO.

=head2 get_target

Returns undef if current mode is off.  Returns heat or cooling set point based
on the current mode.  If current mode is AUTO returns a reference to a two
element array containing the cooling and heating set points.

=head2 get_targets

Returns a reference to a hash of the set points.  Keys are 't_cool' and 't_heat'.

=head2 temp_heat

Set a temporary heating set point, takes one argument the desired target.  Will
also set current mode to heating.

=head2 temp_cool

Set a temporary cooling set point, takes one argument the desired target.  Will
also set current mode to cooling.

head2 remote_temp

Returns a reference to a hash containing at least C<rem_mode> but possibly also
C<rem_temp>.  When C<rem_temp> is 1, the temperature passed to C<set_remote_temp>
is used instead of the thermostats internal temp sensor for thermostat operation.

This can be used to have the thermostat act as if it was installed in a better
location by feeding the temp from a sensor at that location to the thermostat
periodically.

=head2 set_remote_temp

Takes a single value to set the current remote temp.

=head2 disable_remote_temp

Disables remote_temp mode and reverts to using the thermostats internal temp
sensor.

=head1 AUTHOR

Mike Greb E<lt>michael@thegrebs.comE<gt>

=head1 COPYRIGHT

Copyright 2013- Mike Greb

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
