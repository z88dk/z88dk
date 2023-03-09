#!/usr/bin/perl

use strict;
use warnings;
use utf8;
use Getopt::Std;

sub show_help_and_die {
	die <<EOF_HELP
usage: $0 <pasmo_asm_file> [-r] [-e]
  -r: the ASM input file has been configured for ROM code
  -s: process input in SONG mode (does not include EXTERN declarations for Arkos player functions)
EOF_HELP
;
}

# check arguments and options
our ( $opt_r, $opt_s );
getopts("rs");
my $rom_mode = $opt_r || 0;
my $song_mode = $opt_s || 0;

my $input = $ARGV[0];
defined( $input ) or show_help_and_die;

# open input and start processing
open SRC, $input or
	die "Could not open $input for reading...\n";

my @output;

# output proper section name, and if in code mode, public declarations
if ( $song_mode ) {
	push @output, "section data_sound_ay\n";
} else {
	push @output, "section code_sound_ay\n";
	push @output, map { "public PLY_AKG_$_\n" } qw( INIT STOP PLAY INITSOUNDEFFECTS PLAYSOUNDEFFECT );
}

my @all_symbols;
my $arkos_var_offset_max = 0;
while ( my $line = <SRC> ) {
	chomp $line;

	# remove DOS-style line feeds
	$line =~ s/\r//g;

	# all leading blanks -> 1 tab
	$line =~ s/^\s+/\t/g;

	# add : to all labels which are alone on a single line
	if ( $line =~ /^(\w+)$/ ) {
		push @output, "\n$1:\n";
		push @all_symbols, $1;		# save the symbol
		next;
	}

	# replace $+N with ASMPC defs
	if ( $line =~ /^(\w+)\s+equ\s+\$([\+\-]\d+)/i ) {
		push @output, "defc $1 = ASMPC $2\n";
		push @all_symbols, $1;
		next;
	}

	# add : to all labels with instructions on the same line
	# except if it's an EQU definition
	if ( $line =~ /^(\w+)\s+(\w+)(.*)$/ ) {
		if ( lc($2) ne 'equ' ) {
			push @output, "$1:\n\t$2$3\n";
			push @all_symbols, $1;
			next;
		}
	}

	# if it is an arkos variable definition, transform it into an external ref
	if ( $line =~ /^(PLY_AKG_\w+)\s+equ\s+(\d+)$/ ) {
		my $var_offset = $2 - 0xc000;
		push @output, sprintf( "%s equ _arkos_var_buffer + %d\n", $1, $var_offset );
		push @all_symbols, $1;
		if ( $arkos_var_offset_max < $var_offset ) {
			$arkos_var_offset_max = $var_offset;
		}
		next;
	}

	# save processed line
	push @output, "$line\n";
}
close SRC;

# if $arkos_var_offset_max is > 0, some arkos vars were detected, which
# means a) this is code, not a song, and b) this is rom mode
if ( $arkos_var_offset_max ) {
	push @output, sprintf( ";;\n;; maximum arkos variable offset: %d\n;; _arkos_var_buffer size: %d\n\n", $arkos_var_offset_max, $arkos_var_offset_max+1 );
	push @output, "\nsection bss_sound_ay\n";
	push @output, sprintf("_arkos_var_buffer:\n\tdefs %d\n", $arkos_var_offset_max + 1 );
}

print join( "", @output ), "\n";
