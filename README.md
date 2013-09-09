# NAME

Device::RadioThermostat - Access Radio Thermostat Co of America (3M-Filtrete) WiFi thermostats

# SYNOPSIS

    use Device::RadioThermostat;
    my $thermostat = Device::RadioThermostat->new( address => "http://$ip");



# DESCRIPTION

Device::RadioThermostat is a perl module for accessing the API of thermostats
manufactured by Radio Thermostat Corporation of America.  3M-Filtrete themostats
with WiFi are OEM versions manufactured by RTCOA.

# METHODS

## new( address=> 'http://192.168.1.1')

Constructor takes named parameters.  Currently only `address` which should be
the HTTP URL for the thermostat.

## tstat

Retrieve lots of infos from the thermostat.  Your goto for the 411 on your thermostat.

## set\_mode

Takes a single integer argument for your desired mode. Values are 0 - OFF, 1 -
HEAT, 2 - COOL, 3 - AUTO.

## get\_target

Returns undef if current mode is off.  Returns heat or cooling set point based
on the current mode.  If current mode is AUTO returns a reference to a two
element array containing the cooling and heating set points.

## get\_targets

Returns a reference to a hash of the set points.  Keys are 't\_cool' and 't\_heat'.

## temp\_heat

Set a temporary heating set point, takes one argument the desired target.  Will
also set current mode to heating.

## temp\_cool

Set a temporary cooling set point, takes one argument the desired target.  Will
also set current mode to cooling.

## remote\_temp

Returns a reference to a hash containing at least `rem_mode` but possibly also
`rem_temp`.  When `rem_temp` is 1, the temperature passed to `set_remote_temp`
is used instead of the thermostats internal temp sensor for thermostat operation.

This can be used to have the thermostat act as if it was installed in a better
location by feeding the temp from a sensor at that location to the thermostat
periodically.

## set\_remote\_temp

Takes a single value to set the current remote temp.

## disable\_remote\_temp

Disables remote\_temp mode and reverts to using the thermostats internal temp
sensor.

# AUTHOR

Mike Greb <michael@thegrebs.com>

# COPYRIGHT

Copyright 2013- Mike Greb

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO
