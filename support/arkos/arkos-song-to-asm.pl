#!/usr/bin/env perl
#
# converts an Arkos song or sound effects file to an ASM file you can
# include in your program

use strict;
use warnings;
use utf8;
use Getopt::Std;
use Data::Dumper;

# arkos installation path, may be undef
my $arkos_path;

# arkos2_convert_song_to_asm: receives a file name (an song in AKS format)
# and a C symbol name which will be the name of the song during the game. 
# Returns a file name under /tmp which is the AKS song exported in ASM
# format.
sub arkos2_convert_song_to_asm {
    my ( $song_file, $song_symbol ) = @_;

    my $tmp_file = "temp_song.$$";

    my $command = sprintf( "'%s' -sppostlbl : '%s' '%s' >/dev/null 2>&1",
        # if we specified the Arkos install path, use it, otherwise assume
        # the tool is the command search path
        ( defined( $arkos_path ) ? $arkos_path . '/tools/SongToAkg' : 'SongToAkg' ),
        $song_file,
        $tmp_file,
    );
    if ( system( $command ) != 0 ) {
        die sprintf( "Error running command: %s\n", join( ' ', $command ) );
    }
    open TMPIN, $tmp_file or
        die "Could not open file $tmp_file for reading\n";

    my @asmout;

    push @asmout, "section rodata_user\n";
    push @asmout, sprintf( "public %s\n", $song_symbol );
    push @asmout, sprintf( "%s:\n", $song_symbol );

    while (<TMPIN>) {
        chomp;
        s/\r//g;
        push @asmout, $_."\n";
    };

    close TMPIN;
    unlink( $tmp_file );

    return @asmout;
}

# arkos2_convert_effects_to_asm: receives a file name (an song with effects
# in AKS format) and a C symbol name which will be the name of the effects
# table during the game.  Returns a file name under /tmp which is the AKS
# effects table exported in ASM format.

sub arkos2_convert_effects_to_asm {
    my ( $song_file, $song_symbol ) = @_;

    my $tmp_file = "temp_effects.$$";

    my $command = sprintf( "'%s' -sppostlbl : '%s' '%s' >/dev/null 2>&1",
        # if we specified the Arkos install path, use it, otherwise assume
        # the tool is the command search path
        ( defined( $arkos_path ) ? $arkos_path . '/tools/SongToSoundEffects' : 'SongToSoundEffects' ),
        $song_file,
        $tmp_file,
    );
    if ( system( $command ) != 0 ) {
        die sprintf( "Error running command: %s\n", join( ' ', $command ) );
    }
    open TMPIN, $tmp_file or
        die "Could not open file $tmp_file for reading\n";

    my @asmout;

    push @asmout, "section data_sound_ay\n";
    push @asmout, sprintf( "public %s\n", $song_symbol );
    push @asmout, sprintf( "%s:\n", $song_symbol );

    while (<TMPIN>) {
        chomp;
        s/\r//g;
        push @asmout, $_."\n";
    };

    close TMPIN;
    unlink( $tmp_file );

    return @asmout;
}

sub arkos2_count_sound_effects {
    my @asmin = @_;
    my $count = 0;
    foreach my $line ( @asmin ) {
        if ( $line =~ /^\s+dw\s+SoundEffects_Sound\d+\s+/ ) {
            $count++;
        }
    }
    return $count;
}

sub show_help_and_exit {
    die <<EOF_HELP
usage:
    Convert a song:  $0 [-p <arkos_install_dir>] -s _my_song_symbol my_song.aks
    Convert effects: $0 [-p <arkos_install_dir>] -e -s _my_effects_symbol my_effects.aks
EOF_HELP
;
    exit;
}

################
## main loop
################

# get CLI options
our ( $opt_s, $opt_p, $opt_e );
getopts("es:p:");

# -s and file argument are mandatory
( defined( $opt_s ) and scalar( @ARGV ) ) or
    show_help_and_exit;
my $symbol = $opt_s;
my $input_file = $ARGV[0];

# song or effects mode
my $song_mode = ( defined( $opt_e ) ? 0 : 1 );

# arkos install path
$arkos_path = ( defined( $opt_p ) ? $opt_p : undef );

# on with the show :-)
if ( $song_mode ) {
    my @asm = arkos2_convert_song_to_asm( $input_file, $symbol );
    print join( '', @asm );
} else {
    my @asm = arkos2_convert_effects_to_asm( $input_file, $symbol );
    my $num_effects = arkos2_count_sound_effects( @asm );
    print join( '', @asm );
    printf ";; num_effects: %d\n", $num_effects;
}
