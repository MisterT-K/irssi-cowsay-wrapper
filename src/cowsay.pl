# Depends: LibGetopt Long

use strict;
use vars qw($VERSION %IRSSI);

# use Getopt::Mixed;
use Getopt::Long qw(GetOptionsFromString); # 
use Irssi;

# Getopt::Mixed::init( 'f:s');
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

#Animal candidate hash list

my %animals;

# Fill in animal options to hash for search purposes.

foreach("apt", "beavis.zen", "bong", "bud-frogs", "bunny", "calvin", "cheese", "cock", "cower", "daemon", "default", "dragon", "dragon-and-cow", "duck", "elephant", "elephant-in-snake", "eyes", "flaming-sheep", "ghostbusters", "gnu", "head-in", "hellokitty", "kiss", "kitty", "koala", "kosh", "luke-koala", "mech-and-cow", "meow", "milk", "moofasa", "moose", "mutilated", "pony", "pony-smaller", "ren", "sheep", "skeleton", "snowman", "sodomized-sheep", "stegosaurus", "stimpy", "suse", "three-eyes", "turkey", "turtle", "tux", "unipony", "unipony-smaller", "vader", "vader-koala", "www"){
    $animals{$_} = 1;
}

# Usage: /COWSAY [--fortune  [-f animal] | [-f animal] <msg>] . See cowsay -l for animal list
sub cmd_cowsay {
    # data - contains the parameters for /COWSAY
    # server - the active server in window
    # witem - the active window item (eg. channel, query)
    #         or undef if the window is empty
    my ($data, $server, $witem) = @_;
    my $animal = "default";
    my $animalCandidate = '';
    my $fortune = 0;
    my $ret;
    my $args;

    
    # Check if connected
    if (!$server || !$server->{connected}) {
        Irssi::print("Not connected to server");
        return;
    }

    ($ret, $args) = GetOptionsFromString($data, "f:s" => \$animalCandidate, "fortune" => \$fortune); # flag, optional animal
    
    # If animal candidate in parameters is good-to-go, use that
    if(exists $animals{$animalCandidate}){
        $animal = $animalCandidate;
    }
    
    # If there is an active window, run cowsay [+fortune] with correct input
    if ($witem) {
        # theres query/channel active in window
        my $r_v = -1;
        my @output;
        
        if($fortune eq 1){
            @output = qx{fortune|cowsay -f "$animal"};
        } else {
            # Rest of the input for the command (outside of -f target)
            my $inputText = join(' ', @$args);
            @output = qx{echo "$inputText"|cowsay -f "$animal"};
        }
        $r_v = $?;
        
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

# Bind the command to irssi
Irssi::command_bind('cowsay', 'cmd_cowsay');

