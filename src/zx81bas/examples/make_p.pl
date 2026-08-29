#!/usr/bin/env perl

# make a .P file from a mix of BASIC and ASSEMBLY
# code between #ASM and #ENDASM is assembled and converted to a REM line
# labels can be referenced in BASIC by &NAME

use Modern::Perl;
use Path::Tiny;

my @z80asm_options;
while ( @ARGV && $ARGV[0] =~ /^-/ ) {
    push @z80asm_options, shift @ARGV;
}
@ARGV == 1 or die "Usage: $0 [-z80asm-options] file.bas\n";
my $input_bas = shift;

# read code
my @asm;
my @basic;
my $fh;
open( $fh, "<", $input_bas ) or die "open $input_bas: $!\n";
my $in_basic = 1;
while (<$fh>) {
    if (/#ASM/) {
        $in_basic = 0;
    }
    elsif (/#ENDASM/) {
        $in_basic = 1;
    }
    elsif ($in_basic) {
        push @basic, $_;
    }
    else {
        push @asm, $_;
    }
}

# make assembly
( my $output_asm = $input_bas ) =~ s/\.\w+$/.asm/;
path($output_asm)->spew_raw(@asm);
run("z88dk-z80asm -b -m -l -r16514 @z80asm_options $output_asm");

# read binary output, insert as REM in basic
( my $bin_file = $input_bas ) =~ s/\.\w+$/.bin/;
my $bin = path($bin_file)->slurp_raw;
my $rem = "1 REM ";
for ( split( //, $bin ) ) {
    $rem .= "\\" . sprintf( "%02X", ord($_) );
}
$rem .= "\n";
unshift @basic, $rem;

# read map file
( my $map_file = $input_bas ) =~ s/\.\w+$/.map/;
my %labels;
open( $fh, "<", $map_file ) or die "open $map_file: $!\n";
while (<$fh>) {
    /^(\w+)\s*=\s*\$([0-9a-fA-F]+)/ and $labels{$1} = hex($2);
}

# write sym file for eightyone
( my $sym_file = $input_bas ) =~ s/\.\w+$/.sym/;
my @syms;
while ( my ( $name, $value ) = each %labels ) {
    push @syms, sprintf( "%04X %s\n", $value, $name );
}
path($sym_file)->spew_raw( sort @syms );

# translate labels in basic and hex numbers
for (@basic) {
    s/(&(\w+))/ exists $labels{$2} ? $labels{$2} : $1 /gie;
    s/\$([0-9a-f]+)\b/ hex($1) /gie;
}

# output basic
( my $output_b81 = $input_bas ) =~ s/\.\w+$/.b81/;
path($output_b81)->spew_raw(@basic);

# convert to .P
( my $output_p = $input_bas ) =~ s/\.\w+$/.p/;
run("t2p -o $output_p $output_b81");

# rename line 1 REM to 0
my @bytes = map { ord } split //, path($output_p)->slurp_raw;
$bytes[ 0x407d - 0x4009 ] = 0;
$bytes[ 0x407e - 0x4009 ] = 0;

# remove last byte (t2p writes the first byte of E_LINE)
pop @bytes;

path($output_p)->spew_raw( join "", map { chr } @bytes );

sub run {
    my ($cmd) = @_;
    print "% $cmd\n";
    system($cmd) == 0 or die "command failed\n";
}
