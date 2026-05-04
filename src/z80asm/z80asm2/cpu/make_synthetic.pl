#!/usr/bin/env perl

#------------------------------------------------------------------------------
# Z80 assembler
# Copyright (C) Paulo Custodio, 2011-2026
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

use Modern::Perl;
use FindBin;
use lib "$FindBin::Bin";    # adjust to find modules
use Opcodes;

@ARGV == 2 or die "usage: $0 opcodes.dat output.dat\n";
my ( $opcodes_file, $synthetic_file ) = @ARGV;

# read opcodes.dat
my $opcodes = Opcodes->from_file("opcodes.dat");

# map real opcode bytes to asm
# iterate twice; first see all; second see only strict; this way "mov" gets overwritten by "ld"
my $ops = {};
for my $strict ( 0 .. 1 ) {
    for my $asm ( sort keys %{ $opcodes->{opcodes} } ) {
        for my $cpu ( sort keys %{ $opcodes->{opcodes}{$asm} } ) {
            if ($strict) {
                next unless $cpu =~ /strict/;    # check only official opcodes
            }
            $cpu =~ s/_strict//;                 # save table for non-strict version
            my $opcode = $opcodes->{opcodes}{$asm}{$cpu};
            if ( !$opcode->{synth} ) {
                my @ops = map { @$_ } @{ $opcode->{ops} };    # flatten list
                                                              #say "$asm $cpu @ops";
                $ops->{"@ops"}{$cpu} = $asm;
            }
        }
    }
}

# look for synthetic opcodes, map to the different base instructions
my $synth = {};
for my $asm ( sort keys %{ $opcodes->{opcodes} } ) {
    for my $cpu ( sort keys %{ $opcodes->{opcodes}{$asm} } ) {
        my $opcode = $opcodes->{opcodes}{$asm}{$cpu};
        if ( $opcode->{synth} ) {
            my @instr = find_instrs( $asm, $cpu );
            $synth->{$asm}{$cpu} = \@instr;
        }
    }
}

open( my $fh, ">", $synthetic_file ) or die "write $synthetic_file: $!\n";
say $fh "asm|cpu|synth";
for my $asm ( sort keys %{$synth} ) {
    for my $cpu ( sort keys %{ $synth->{$asm} } ) {
        my @instr = @{ $synth->{$asm}{$cpu} };
        say $fh "$asm|$cpu|" . join( ";", @instr );
    }
}

sub find_instrs {
    my ( $asm, $cpu ) = @_;
    my $opcode = $opcodes->{opcodes}{$asm}{$cpu};
    my @ops    = @{ $opcode->{ops} };
    my @instr;

    # create labels for %t[N]
    @ops = resolve_labels(@ops);

    # replace each group of 1..N opcodes by a single instruction
    # N because prefixes are coded as separate instructions
ops:
    while (@ops) {
        if ( @{ $ops[0] } == 1 && $ops[0][0] =~ /%t\d*:/ ) {
            push @instr, $ops[0][0];
            shift @ops;
            next ops;
        }
        if ( ( @{ $ops[0] } == 3 || @{ $ops[0] } == 4 ) && $ops[0][0] == 0xCD ) {
            my $sub = $ops[0][1] =~ s/^\@//r;
            push @instr, "extern $sub" unless $sub eq "%m";
            push @instr, "call $sub";
            shift @ops;
            next ops;
        }
        if ( @{ $ops[0] } == 1 && $ops[0][0] eq '%d' ) {
            push @instr, "defb %d";
            shift @ops;
            next ops;
        }
        if ( @{ $ops[0] } == 3 && $ops[0][1] eq '%n' && $ops[0][2] eq '%s' ) {
            my @flat = ( $ops[0][0], '%m', '%m' );
            exists $ops->{"@flat"}{$cpu} or die "$asm $cpu @flat";
            my $instr = $ops->{"@flat"}{$cpu} =~ s/%m/%n/r;
            push @instr, $instr;
            shift @ops;
            next ops;
        }
        if ( @{ $ops[0] } == 3 && $ops[0][1] eq '%d' && $ops[0][2] eq '%s' ) {
            my @flat = ( $ops[0][0], '%m', '%m' );
            exists $ops->{"@flat"}{$cpu} or die "$asm $cpu @flat";
            my $instr = $ops->{"@flat"}{$cpu} =~ s/%m/%d/r;
            push @instr, $instr;
            shift @ops;
            next ops;
        }
        if ( @{ $ops[0] } == 4 && $ops[0][1] eq '%n' && $ops[0][2] eq '%s' && $ops[0][3] eq '%s' ) {
            my @flat = ( $ops[0][0], '%m', '%m', '%m' );
            exists $ops->{"@flat"}{$cpu} or die "$asm $cpu @flat";
            my $instr = $ops->{"@flat"}{$cpu} =~ s/%m/%n/r;
            push @instr, $instr;
            shift @ops;
            next ops;
        }
        if ( @{ $ops[0] } == 4 && $ops[0][1] eq '%d' && $ops[0][2] eq '%s' && $ops[0][3] eq '%s' ) {
            my @flat = ( $ops[0][0], '%m', '%m', '%m' );
            exists $ops->{"@flat"}{$cpu} or die "$asm $cpu @flat";
            my $instr = $ops->{"@flat"}{$cpu} =~ s/%m/%d/r;
            push @instr, $instr;
            shift @ops;
            next ops;
        }
        if ( @{ $ops[0] } == 2 && $ops[0][0] == 0x06 && $ops[0][1] eq 0 ) {
            push @instr, "ld b, 0";
            shift @ops;
            next ops;
        }
        if ( @{ $ops[0] } == 2 && $ops[0][0] == 0x0E && $ops[0][1] eq 0 ) {
            push @instr, "ld c, 0";
            shift @ops;
            next ops;
        }
        if ( @{ $ops[0] } == 2 && $ops[0][0] == 0x16 && $ops[0][1] eq 0 ) {
            push @instr, "ld d, 0";
            shift @ops;
            next ops;
        }
        if ( @{ $ops[0] } == 2 && $ops[0][0] == 0x1E && $ops[0][1] eq 0 ) {
            push @instr, "ld e, 0";
            shift @ops;
            next ops;
        }
        if ( @{ $ops[0] } == 2 && $ops[0][0] == 0x26 && $ops[0][1] eq 0 ) {
            push @instr, "ld h, 0";
            shift @ops;
            next ops;
        }
        if ( @{ $ops[0] } == 2 && $ops[0][0] == 0x2E && $ops[0][1] eq 0 ) {
            push @instr, "ld l, 0";
            shift @ops;
            next ops;
        }
        if ( @{ $ops[0] } == 3 && $ops[0][0] == 0xDD && $ops[0][1] == 0x26 && $ops[0][2] eq 0 ) {
            push @instr, "ld ixh, 0";
            shift @ops;
            next ops;
        }
        if ( @{ $ops[0] } == 3 && $ops[0][0] == 0xDD && $ops[0][1] == 0x2E && $ops[0][2] eq 0 ) {
            push @instr, "ld ixl, 0";
            shift @ops;
            next ops;
        }
        if ( @{ $ops[0] } == 3 && $ops[0][0] == 0xFD && $ops[0][1] == 0x26 && $ops[0][2] eq 0 ) {
            push @instr, "ld iyh, 0";
            shift @ops;
            next ops;
        }
        if ( @{ $ops[0] } == 3 && $ops[0][0] == 0xFD && $ops[0][1] == 0x2E && $ops[0][2] eq 0 ) {
            push @instr, "ld iyl, 0";
            shift @ops;
            next ops;
        }
        if ( @{ $ops[0] } == 2 && $ops[0][0] == 0x36 && $ops[0][1] eq 0 ) {
            push @instr, "ld (hl), 0";
            shift @ops;
            next ops;
        }
        if (   @{ $ops[0] } == 1
            && $ops[0][0] == 0xDB
            && @{ $ops[1] } == 2
            && $ops[1][0] == 0x36
            && $ops[1][1] eq 0 )
        {
            push @instr, "ioe ld (hl), 0";
            splice @ops, 0, 2;
            next ops;
        }
        if (   @{ $ops[0] } == 1
            && $ops[0][0] == 0xD3
            && @{ $ops[1] } == 2
            && $ops[1][0] == 0x36
            && $ops[1][1] eq 0 )
        {
            push @instr, "ioi ld (hl), 0";
            splice @ops, 0, 2;
            next ops;
        }
        if ( @{ $ops[0] } == 2 && $ops[0][0] == 0x3E && $ops[0][1] eq 0 ) {
            push @instr, "ld a, 0";
            shift @ops;
            next ops;
        }
        if ( @{ $ops[0] } == 4 && $ops[0][0] == 0xDD && $ops[0][1] == 0x36 && $ops[0][2] eq 0 && $ops[0][3] eq 0 ) {
            push @instr, "ld (ix), 0";
            shift @ops;
            next ops;
        }
        if ( @{ $ops[0] } == 4 && $ops[0][0] == 0xFD && $ops[0][1] == 0x36 && $ops[0][2] eq 0 && $ops[0][3] eq 0 ) {
            push @instr, "ld (iy), 0";
            shift @ops;
            next ops;
        }
        if ( @{ $ops[0] } == 4 && $ops[0][0] == 0xDD && $ops[0][1] == 0x36 && $ops[0][2] eq '%d' && $ops[0][3] eq 0 ) {
            push @instr, "ld (ix+%d), 0";
            shift @ops;
            next ops;
        }
        if ( @{ $ops[0] } == 4 && $ops[0][0] == 0xFD && $ops[0][1] == 0x36 && $ops[0][2] eq '%d' && $ops[0][3] eq 0 ) {
            push @instr, "ld (iy+%d), 0";
            shift @ops;
            next ops;
        }
        if (   @{ $ops[0] } == 1
            && $ops[0][0] == 0xDB
            && @{ $ops[1] } == 4
            && $ops[1][0] == 0xDD
            && $ops[1][1] == 0x36
            && $ops[1][2] eq 0
            && $ops[1][3] eq 0 )
        {
            push @instr, "ioe ld (ix), 0";
            splice @ops, 0, 2;
            next ops;
        }
        if (   @{ $ops[0] } == 1
            && $ops[0][0] == 0xDB
            && @{ $ops[1] } == 4
            && $ops[1][0] == 0xFD
            && $ops[1][1] == 0x36
            && $ops[1][2] eq 0
            && $ops[1][3] eq 0 )
        {
            push @instr, "ioe ld (iy), 0";
            splice @ops, 0, 2;
            next ops;
        }
        if (   @{ $ops[0] } == 1
            && $ops[0][0] == 0xDB
            && @{ $ops[1] } == 4
            && $ops[1][0] == 0xDD
            && $ops[1][1] == 0x36
            && $ops[1][2] eq '%d'
            && $ops[1][3] eq 0 )
        {
            push @instr, "ioe ld (ix+%d), 0";
            splice @ops, 0, 2;
            next ops;
        }
        if (   @{ $ops[0] } == 1
            && $ops[0][0] == 0xDB
            && @{ $ops[1] } == 4
            && $ops[1][0] == 0xFD
            && $ops[1][1] == 0x36
            && $ops[1][2] eq '%d'
            && $ops[1][3] eq 0 )
        {
            push @instr, "ioe ld (iy+%d), 0";
            splice @ops, 0, 2;
            next ops;
        }
        if (   @{ $ops[0] } == 1
            && $ops[0][0] == 0xD3
            && @{ $ops[1] } == 4
            && $ops[1][0] == 0xDD
            && $ops[1][1] == 0x36
            && $ops[1][2] eq 0
            && $ops[1][3] eq 0 )
        {
            push @instr, "ioi ld (ix), 0";
            splice @ops, 0, 2;
            next ops;
        }
        if (   @{ $ops[0] } == 1
            && $ops[0][0] == 0xD3
            && @{ $ops[1] } == 4
            && $ops[1][0] == 0xFD
            && $ops[1][1] == 0x36
            && $ops[1][2] eq 0
            && $ops[1][3] eq 0 )
        {
            push @instr, "ioi ld (iy), 0";
            splice @ops, 0, 2;
            next ops;
        }
        if (   @{ $ops[0] } == 1
            && $ops[0][0] == 0xD3
            && @{ $ops[1] } == 4
            && $ops[1][0] == 0xDD
            && $ops[1][1] == 0x36
            && $ops[1][2] eq '%d'
            && $ops[1][3] eq 0 )
        {
            push @instr, "ioi ld (ix+%d), 0";
            splice @ops, 0, 2;
            next ops;
        }
        if (   @{ $ops[0] } == 1
            && $ops[0][0] == 0xD3
            && @{ $ops[1] } == 4
            && $ops[1][0] == 0xFD
            && $ops[1][1] == 0x36
            && $ops[1][2] eq '%d'
            && $ops[1][3] eq 0 )
        {
            push @instr, "ioi ld (iy+%d), 0";
            splice @ops, 0, 2;
            next ops;
        }
        if (   @{ $ops[0] } == 1
            && $ops[0][0] == 0x76
            && @{ $ops[1] } == 2
            && $ops[1][0] == 0x06
            && $ops[1][1] eq 0 )
        {
            push @instr, "altd ld b, 0";
            splice @ops, 0, 2;
            next ops;
        }
        if ( @{ $ops[0] } == 3 && ( $ops[0][0] == 0xDD || $ops[0][0] == 0xFD ) && $ops[0][2] eq 1 ) {
            my @flat = ( $ops[0][0], $ops[0][1], '%d' );
            exists $ops->{"@flat"}{$cpu} or die "$asm $cpu @flat";
            my $instr = $ops->{"@flat"}{$cpu} =~ s/%d/1/r;
            push @instr, $instr;
            shift @ops;
            next ops;
        }
        if (   @{ $ops[0] } == 1
            && $ops[0][0] == 0x76
            && @{ $ops[1] } == 2
            && $ops[1][0] == 0x0E
            && $ops[1][1] eq 0 )
        {
            push @instr, "altd ld c, 0";
            splice @ops, 0, 2;
            next ops;
        }
        if (   @{ $ops[0] } == 1
            && $ops[0][0] == 0x76
            && @{ $ops[1] } == 2
            && $ops[1][0] == 0x16
            && $ops[1][1] eq 0 )
        {
            push @instr, "altd ld d, 0";
            splice @ops, 0, 2;
            next ops;
        }
        if (   @{ $ops[0] } == 1
            && $ops[0][0] == 0x76
            && @{ $ops[1] } == 2
            && $ops[1][0] == 0x1E
            && $ops[1][1] eq 0 )
        {
            push @instr, "altd ld e, 0";
            splice @ops, 0, 2;
            next ops;
        }
        if (   @{ $ops[0] } == 1
            && $ops[0][0] == 0x76
            && @{ $ops[1] } == 2
            && $ops[1][0] == 0x26
            && $ops[1][1] eq 0 )
        {
            push @instr, "altd ld h, 0";
            splice @ops, 0, 2;
            next ops;
        }
        if (   @{ $ops[0] } == 1
            && $ops[0][0] == 0x76
            && @{ $ops[1] } == 2
            && $ops[1][0] == 0x2E
            && $ops[1][1] eq 0 )
        {
            push @instr, "altd ld l, 0";
            splice @ops, 0, 2;
            next ops;
        }
        if (   @{ $ops[0] } == 1
            && $ops[0][0] == 0x76
            && @{ $ops[1] } == 2
            && $ops[1][0] == 0x3E
            && $ops[1][1] eq 0 )
        {
            push @instr, "altd ld a, 0";
            splice @ops, 0, 2;
            next ops;
        }
        if (   @{ $ops[0] } == 1
            && $ops[0][0] == 0x76
            && @{ $ops[1] } == 2
            && $ops[1][0] == 0x3E
            && $ops[1][1] eq 0 )
        {
            push @instr, "altd ld a, 0";
            splice @ops, 0, 2;
            next ops;
        }
        if ( @{ $ops[0] } == 3 && $ops[0][0] == 0x01 && $ops[0][1] eq 0 && $ops[0][2] eq 0 ) {
            push @instr, "ld bc, 0";
            shift @ops;
            next ops;
        }
        if ( @{ $ops[0] } == 3 && $ops[0][0] == 0x11 && $ops[0][1] eq 0 && $ops[0][2] eq 0 ) {
            push @instr, "ld de, 0";
            shift @ops;
            next ops;
        }
        if ( @{ $ops[0] } == 3 && $ops[0][0] == 0x21 && $ops[0][1] eq 0 && $ops[0][2] eq 0 ) {
            push @instr, "ld hl, 0";
            shift @ops;
            next ops;
        }
        if ( @{ $ops[0] } == 4 && $ops[0][0] == 0xDD && $ops[0][1] == 0x21 && $ops[0][2] eq 0 && $ops[0][3] eq 0 ) {
            push @instr, "ld ix, 0";
            shift @ops;
            next ops;
        }
        if ( @{ $ops[0] } == 4 && $ops[0][0] == 0xFD && $ops[0][1] == 0x21 && $ops[0][2] eq 0 && $ops[0][3] eq 0 ) {
            push @instr, "ld iy, 0";
            shift @ops;
            next ops;
        }
        if ( @{ $ops[0] } == 3 && $ops[0][0] == 0x21 && $ops[0][1] eq 1 && $ops[0][2] eq 0 ) {
            push @instr, "ld hl, 1";
            shift @ops;
            next ops;
        }
        if ( @{ $ops[0] } == 3 && $ops[0][0] == 0x21 && $ops[0][1] eq 2 && $ops[0][2] eq 0 ) {
            push @instr, "ld hl, 2";
            shift @ops;
            next ops;
        }
        if ( @{ $ops[0] } == 4 && $ops[0][0] == 0x21 && $ops[0][1] eq 1 && $ops[0][2] eq 0 && $ops[0][3] eq 0 ) {
            push @instr, "ld hl, 1";
            shift @ops;
            next ops;
        }
        if ( @{ $ops[0] } == 4 && $ops[0][0] == 0xDD && $ops[0][1] == 0x21 && $ops[0][2] eq 1 && $ops[0][3] eq 0 ) {
            push @instr, "ld ix, 1";
            shift @ops;
            next ops;
        }
        if (   @{ $ops[0] } == 5
            && $ops[0][0] == 0xDD
            && $ops[0][1] == 0x21
            && $ops[0][2] eq 1
            && $ops[0][3] eq 0
            && $ops[0][4] eq 0 )
        {
            push @instr, "ld ix, 1";
            shift @ops;
            next ops;
        }
        if ( @{ $ops[0] } == 4 && $ops[0][0] == 0xFD && $ops[0][1] == 0x21 && $ops[0][2] eq 1 && $ops[0][3] eq 0 ) {
            push @instr, "ld iy, 1";
            shift @ops;
            next ops;
        }
        if (   @{ $ops[0] } == 5
            && $ops[0][0] == 0xFD
            && $ops[0][1] == 0x21
            && $ops[0][2] eq 1
            && $ops[0][3] eq 0
            && $ops[0][4] eq 0 )
        {
            push @instr, "ld iy, 1";
            shift @ops;
            next ops;
        }
        if ( @{ $ops[0] } == 4 && $ops[0][0] == 0x01 && $ops[0][1] eq 0 && $ops[0][2] eq 0 && $ops[0][3] eq 0 ) {
            push @instr, "ld bc, 0";
            shift @ops;
            next ops;
        }
        if ( @{ $ops[0] } == 4 && $ops[0][0] == 0x11 && $ops[0][1] eq 0 && $ops[0][2] eq 0 && $ops[0][3] eq 0 ) {
            push @instr, "ld de, 0";
            shift @ops;
            next ops;
        }
        if ( @{ $ops[0] } == 4 && $ops[0][0] == 0x21 && $ops[0][1] eq 0 && $ops[0][2] eq 0 && $ops[0][3] eq 0 ) {
            push @instr, "ld hl, 0";
            shift @ops;
            next ops;
        }
        if (   @{ $ops[0] } == 5
            && $ops[0][0] == 0xDD
            && $ops[0][1] == 0x21
            && $ops[0][2] eq 0
            && $ops[0][3] eq 0
            && $ops[0][4] eq 0 )
        {
            push @instr, "ld ix, 0";
            shift @ops;
            next ops;
        }
        if (   @{ $ops[0] } == 5
            && $ops[0][0] == 0xFD
            && $ops[0][1] == 0x21
            && $ops[0][2] eq 0
            && $ops[0][3] eq 0
            && $ops[0][4] eq 0 )
        {
            push @instr, "ld iy, 0";
            shift @ops;
            next ops;
        }
        if (   @{ $ops[0] } == 1
            && $ops[0][0] == 0x76
            && @{ $ops[1] } == 3
            && $ops[1][0] == 0x01
            && $ops[1][1] eq 0
            && $ops[1][2] eq 0 )
        {
            push @instr, "altd ld bc, 0";
            splice @ops, 0, 2;
            next ops;
        }
        if (   @{ $ops[0] } == 1
            && $ops[0][0] == 0x76
            && @{ $ops[1] } == 3
            && $ops[1][0] == 0x11
            && $ops[1][1] eq 0
            && $ops[1][2] eq 0 )
        {
            push @instr, "altd ld de, 0";
            splice @ops, 0, 2;
            next ops;
        }
        if (   @{ $ops[0] } == 1
            && $ops[0][0] == 0x76
            && @{ $ops[1] } == 3
            && $ops[1][0] == 0x21
            && $ops[1][1] eq 0
            && $ops[1][2] eq 0 )
        {
            push @instr, "altd ld hl, 0";
            splice @ops, 0, 2;
            next ops;
        }
        if ( @{ $ops[0] } == 2 && $ops[0][1] =~ /%t\d*/ ) {
            my @flat = ( $ops[0][0], '%j' );
            exists $ops->{"@flat"}{$cpu} or die "$asm $cpu @flat";
            my $instr = $ops->{"@flat"}{$cpu} =~ s/%j/$ops[0][1]/r;
            push @instr, $instr;
            shift @ops;
            next ops;
        }
        if ( @{ $ops[0] } == 3 && $ops[0][1] =~ /%t\d*/ && $ops[0][2] =~ /%t\d*/ ) {
            my @flat = ( $ops[0][0], '%m', '%m' );
            exists $ops->{"@flat"}{$cpu} or die "$asm $cpu @flat";
            my $instr = $ops->{"@flat"}{$cpu} =~ s/%m/$ops[0][1]/r;
            push @instr, $instr;
            shift @ops;
            next ops;
        }
        if ( @{ $ops[0] } == 3 && $ops[0][1] eq '%m1' && $ops[0][2] eq '%m1' ) {
            my @flat = ( $ops[0][0], '%m', '%m' );
            exists $ops->{"@flat"}{$cpu} or die "$asm $cpu @flat";
            my $instr = $ops->{"@flat"}{$cpu} =~ s/%m/%m+1/r;
            push @instr, $instr;
            shift @ops;
            next ops;
        }
        if ( @{ $ops[0] } == 3 && ( $ops[0][0] == 0xDD || $ops[0][0] == 0xFD ) && $ops[0][2] eq '%d1' ) {
            my @flat = ( $ops[0][0], $ops[0][1], '%d' );
            exists $ops->{"@flat"}{$cpu} or die "$asm $cpu @flat";
            my $instr = $ops->{"@flat"}{$cpu} =~ s/%d/%d+1/r;
            push @instr, $instr;
            shift @ops;
            next ops;
        }
        for my $i ( 0 .. $#ops ) {
            my @flat = map { @$_ } @ops[ 0 .. $i ];
            if ( exists $ops->{"@flat"}{$cpu} ) {
                push @instr, $ops->{"@flat"}{$cpu};
                splice( @ops, 0, $i + 1 );
                next ops;
            }
        }
        die "$asm $cpu ", join( ":", @instr ), ", ", join( " ", map { @$_ } @ops );
    }

    # check relative jumps converted to absolute jumps
    if ( $asm =~ /%j/ && grep /%m/, @instr ) {
        for (@instr) {
            s/%m/%j/;
        }
    }

    return @instr;
}

sub resolve_labels {
    my (@ops) = @_;

    # find out where the labels point: %t at end; %t1 end-1 byte, ...
    my %labels;
    for (@ops) {
        for (@$_) {
            if (/%t(\d*)/) {
                $labels{$_} = $1 ? $1 : 0;
            }
        }
    }
    return @ops unless %labels;

    # build opcodes backwards until location of labels
    my @out;
    my $offset = 0;
    for my $op ( reverse @ops ) {

        # output labels at offset
        for my $label ( keys %labels ) {
            if ( $labels{$label} == $offset ) {
                unshift @out, [ $label . ":" ];
                delete $labels{$label};
            }
        }

        # update offset and output opcode
        $offset += scalar @$op;
        unshift @out, $op;
    }

    return @out;
}
