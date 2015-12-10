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
    if ($witem) {
        # there's query/channel active in window
        my $r_v = -1;
        my @output;
        if($data eq "fortune"){
            @output = qx{fortune|cowsay};
            $r_v = $?;
        } else {
            @output = qx{cowsay $data};
            $r_v = $?;
        }
        # Handle errors with commands cowsay and fortune
        if($r_v == -1) {
            Irssi::print("Cowsay and/or Fortune command(s) not available for irssi");
        }
        for my $el (@output)
        {
            $witem->command("MSG ".$witem->{name}." ".$el);
        }
    } else {
        Irssi::print("No active channel/query in window");
    }
}
Irssi::command_bind('cowsay', 'cmd_cowsay');
