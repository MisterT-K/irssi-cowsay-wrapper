# Cowsay irssi wrapper with fortune command
# Usage: /COWSAY [--list]|[--fortune  [-f animal] | [-f animal] <msg>]
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
    license     =>  'Creative Commons Attribution 4.0 International (CC BY 4.0)',
);

# Animal variant.
my $animal = "default";

# Animal candidate hash list

my %animals;

# Fill in animal options to hash for search purposes. Hash search structure is better for "exists in" operations compared to an array which would require a complete lookup

foreach("apt", "beavis.zen", "bong", "bud-frogs", "bunny", "calvin", "cheese", "cock", "cower", "daemon", "default", "dragon", "dragon-and-cow", "duck", "elephant", "elephant-in-snake", "eyes", "flaming-sheep", "ghostbusters", "gnu", "head-in", "hellokitty", "kiss", "kitty", "koala", "kosh", "luke-koala", "mech-and-cow", "meow", "milk", "moofasa", "moose", "mutilated", "pony", "pony-smaller", "ren", "sheep", "skeleton", "snowman", "sodomized-sheep", "stegosaurus", "stimpy", "suse", "three-eyes", "turkey", "turtle", "tux", "unipony", "unipony-smaller", "vader", "vader-koala", "www"){
    $animals{$_} = 1;
}

# Cowsay command for irssi, bound later
sub cmd_cowsay {

    # data - contains the parameters for /COWSAY
    # server - the active server in window
    # witem - the active window item (eg. channel, query)
    #         or undef if the window is empty
    my ($data, $server, $witem) = @_;

    my $animalCandidate = '';
    my $fortune         = 0;
    my $list            = 0;
    my $ret;
    my $args;
    my $r_v = -1;
    my @output;
    
    # Check if connected
    if (!$server || !$server->{connected}) {
        Irssi::print("Not connected to server");
        return;
    }
    
    # Parse metacharacters out of data var (quotemeta did not work well with whitespace as it broke argument tokenization in GetOptionsFromString)
    $data =~ s/([^A-Za-z _0-9])/\\$1/g;

    # There's query/channel active in window
    # Parse arguments to irssi command

    ($ret, $args) = GetOptionsFromString(
        $data,
        "f:s"       => \$animalCandidate,
        "fortune"   => \$fortune,
        "list"      => \$list
    );
    
    # If list option, merely output cowsay list
    if($list eq 1){

        @output = qx{cowsay -l};
        
        # Return value of the shell execution
        $r_v = $?;
        
        # Handle errors with commands cowsay
        if($r_v == -1) {
            Irssi::print("Cowsay and/or Fortune command(s) not available for irssi");
            return;
        }

        # If good, output list to server window
        Irssi::print(join(' ', @output));

    } elsif ($witem) { # If there is an active window, run cowsay [+fortune] with correct input
        
        # If animal candidate in parameters is good-to-go, use that
        if(exists $animals{$animalCandidate}){
            $animal = $animalCandidate;
        }
        
        if($fortune eq 1){
            
            # Check if fortune flag was in use, output fortune message if so
            @output = qx{fortune|cowsay -f "$animal"};

        } else {

            # Output rest of the unhandled parameters as the output string
            my $inputText = join(' ', @$args);
            # Some special character handling for perl shell execution. Single quotes handled with "glue"
            $inputText =~ s/'/'"'"'/g;
            @output = qx{echo '$inputText'|cowsay -f $animal};

        }

        # Return value of the shell execution
        $r_v = $?;
        
        # Handle errors with commands cowsay and fortune
        if($r_v == -1) {
            Irssi::print("Cowsay and/or Fortune command(s) not available for irssi");
        }
        
        # Output loop
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

