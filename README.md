# NAME

Device::RadioThermostat - Access Radio Thermostat Co of America (3M-Filtrete) WiFi thermostats

# SYNOPSIS

    use Device::RadioThermostat;
    my $thermostat = Device::RadioThermostat->new( address => "http://$ip");
    $thermostat->temp_cool(65);
    say "It is currently " . $thermostat->tstat()->{temp} "F inside.";

# DESCRIPTION

Device::RadioThermostat is a perl module for accessing the API of thermostats
manufactured by Radio Thermostat Corporation of America.  3M-Filtrete themostats
with WiFi are OEM versions manufactured by RTCOA.

# METHODS

For additional information on the arguments and values returned see the
[RTCOA API documentation (pdf)](http://www.radiothermostat.com/documents/RTCOAWiFIAPIV1\_3.pdf).

## new( address=> 'http://192.168.1.1')

Constructor takes named parameters.  Currently only `address` which should be
the HTTP URL for the thermostat.

## tstat

Retrieve a hash of lots of info on the current thermostat state.  Possible keys
include: `temp`, `tmode`, `fmode`, `override`, `hold`, `t_heat`,
`t_cool`, `it_heat`, `It_cool`, `a_heat`, `a_cool`, `a_mode`,
`t_type_post`, `t_state`.  For a description of their values see the
[RTCOA API documentation (pdf)](http://www.radiothermostat.com/documents/RTCOAWiFIAPIV1\_3.pdf).

## set\_mode($mode)

Takes a single integer argument for your desired mode. Values are 0 for off, 1 for
heating, 2 for cooling, and 3 for auto.

## get\_target

Returns undef if current mode is off.  Returns heat or cooling set point based
on the current mode.  If current mode is auto returns a reference to a two
element array containing the cooling and heating set points.

## get\_targets

Returns a reference to a hash of the set points.  Keys are `t_cool` and `t_heat`.

## temp\_heat($temp)

Set a temporary heating set point, takes one argument the desired target.  Will
also set current mode to heating.

## temp\_cool($temp)

Set a temporary cooling set point, takes one argument the desired target.  Will
also set current mode to cooling.

## remote\_temp

Returns a reference to a hash containing at least `rem_mode` but possibly also
`rem_temp`.  When `rem_mode` is 1, the temperature passed to `set_remote_temp`
is used instead of the thermostats internal temp sensor for thermostat operation.

This can be used to have the thermostat act as if it was installed in a better
location by feeding the temp from a sensor at that location to the thermostat
periodically.

## set\_remote\_temp($temp)

Takes a single value to set the current remote temp.

## disable\_remote\_temp

Disables remote\_temp mode and reverts to using the thermostats internal temp
sensor.

## lock

## lock($mode)

With mode specified, sets mode and returns false on failure.  With successful
mode change or no mode specified, returns the current mode.  Mode is an integer,
0 - disabled, 1 - partial lock, 2 - full lock, 3 - utility lock.

## user\_message($line, $message)

Display a message on one of the two lines of alphanumeric display at the bottom
of the thermostat.  Valid values for line are 0 and 1.  Messages too long will
scroll.  This is only supported by the CT-80 model thermostats.

## price\_message($line, $message)

Display a message in the price message area on the thermostat.  Messages can be
numeric plus decimal only.  Valid values for line are 0 - 3.  Multiple messages
for different lines are rotated through.  I believe line number used will cause
an indicator for units to display based on the number used but it's not
mentioned in the API docs and I'm not home currently.

## clear\_message

Clears the `price_message` area.  May also clear the `user_message`, I'd
appreciate someone with a CT-80 letting me know.

## datalog

Returns individual run times for heating and cooling yesterday and today.  This
method isn't documented in the current API so it may go away in the future but
does still work with the latest firmware. Sample data:

    $data = {
              'today' => {
                         'cool_runtime' => { 'minute' => 29, 'hour' => 2 },
                         'heat_runtime' => { 'minute' => 0,  'hour' => 0 }
                       },
              'yesterday' => {
                         'heat_runtime' => { 'minute' => 0,  'hour' => 0 },
                         'cool_runtime' => { 'minute' => 14, 'hour' => 0 }
                       }
            };

# AUTHOR

Mike Greb <michael@thegrebs.com>

# COPYRIGHT

Copyright 2013- Mike Greb

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO
