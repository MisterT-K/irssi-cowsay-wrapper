use strict;
use vars qw($VERSION %IRSSI);

use Getopt::Mixed;
use Irssi;

Getopt::Mixed::init( 'f:s');
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
my $animal = "default";

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
            # Someone'll kill me for this, but quotes don't prevent -f injections in the command so... through echo we go
            @output = qx{echo "$data"|cowsay};
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

while( my( $option, $value, $pretty ) = Getopt::Mixed::nextOption() ) {
    OPTION: {
      $option eq 'f' and do {
        $animal = $value;

        last OPTION;
      };
      # ...
    }
}
Getopt::Mixed::cleanup();

Irssi::command_bind('cowsay', 'cmd_cowsay');
