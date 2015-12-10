use strict;
use vars qw($VERSION %IRSSI);

use Irssi;
$VERSION = '1.00';
%IRSSI = (
    authors     =>  'Mr. T. Kärkäs',
    contact     =>  'tommikarkas@gmail.com',
    name        =>  'Cowsay wrapper for Irssi',
    description =>  'This script allows ' .
                    'you to express yourself ' .
                    'through cowsay.',
    license     =>  'Public Domain',
);

# Usage: /COWSAY [<msg>|fortune]
sub cmd_cowsay {
    # data - contains the parameters for /COWSAY
    # server - the active server in window
    # witem - the active window item (eg. channel, query)
    #         or undef if the window is empty
    my ($data, $server, $witem) = @_;
    if (!$server || !$server->{connected}) {
        Irssi::print("Not connected to server");
        return;
    }
    if ($data && $witem && $data eq "fortune") {
        # there's query/channel active in window
        if($data eq "fortune"){
            $output = qx{fortune|cowsay};
        } else {
            $output = qx{cowsay $data};
        }
        # TODO: Handle errors with commands cowsay and fortune
        $witem->command("MSG ".$witem->{name}." ".$output);
    } else {
        Irssi::print("No active channel/query in window");
    }
}
Irssi::command_bind('cowsay', 'cmd_cowsay');
