#!/usr/bin/env perl

#------------------------------------------------------------------------------
# Z80 assembler
# Copyright (C) Paulo Custodio, 2011-2026
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

use Modern::Perl;
use Test::More;
use Clone 'clone';
use Data::Dump 'dump';

@ARGV == 1 or die "usage: $0 synthetic.dat\n";
my ($synthetic_file) = @ARGV;

open( my $fh, "<", $synthetic_file ) or die "open $synthetic_file: $!\n";
ok 1, "$synthetic_file open";

chomp( my $title = <$fh> );
is $title, "asm|cpu|synth", "title ok";

while (<$fh>) {
    chomp;
    my ( $asm, $cpu, $instr ) = split /\|/, $_, 3;
    my @effect_synth = parse_effect( $asm, $cpu );
    my @effect_real  = map { parse_effect( $_, $cpu ) } split /;/, $instr;
    @effect_real = normalize_effects(@effect_real);

    is_deeply \@effect_synth, \@effect_real, "$asm | $cpu"
        or do {
        my $msg = join( "\n",
            "$asm | $cpu | $instr",
            "Expected:", dump( \@effect_synth ),
            "Got:",      dump( \@effect_real ) );
        die "$msg\n";
        };
}

close($fh);
done_testing;

#------------------------------------------------------------------------------
# Convert assembly instruction to effects, including synthetic instructions
# {
#     type	 => 'inst',
#     opcode => 'ld',
#     cond   => undef, # condition code for conditional instructions, e.g. 'z' for 'jp z, ...'
#     prefixes => {
#         altd => 0,	# Rabbit alt destination register set
#         alts => 0,    # Rabbit alt source register set
#         io  => undef, # Rabbit IO specifier 'ioe', 'ioi', or undef
#     },
#     suffix   => undef,# eZ80 width suffix: /[sl]i[sl]/ or undef
#     args     => [
#         { type => 'reg', name => 'a', alt => 0, width => undef },
#		  { type => 'regpair', name => 'hl', alt => 0, width => undef }
#		  { type => 'imm', value => '%n', width => undef },
#         { type => 'mem', base => 'hl', disp => 0, disp_offset => 0,
#                   space => 'mem', post => +1, width => undef },
#		  { type => 'mem', base => undef, addr => '%m', space => 'mem', width => undef }
#         { type => 'symbol', name => '__z80asm__xxx' },
#         { type => 'labelref', name => '%t1' },
#         { type => 'ident', name => 'c' },
#         { type => 'cond', name => 'c' },
#     ],
# }
# {
#     type => 'label',
#     name => '%t1',
# }
#------------------------------------------------------------------------------
sub parse_effect {
    my ( $asm, $cpu ) = @_;

    $asm = intel_to_zilog($asm);
    my $inst = parse_assembly( $asm, $cpu );
    return if $inst->{type} eq "inst" && $inst->{opcode} eq "extern";    # ignore extern

    $inst = lower_condition($inst);
    $inst = lower_emulated_ops($inst);
    $inst = lower_rabbit_prefixes($inst);
    $inst = lower_ez80_suffixes($inst);
    $inst = normalize_ex_args($inst);
    $inst = normalize_adi($inst);
    my @insts = lower_postinc($inst);
    @insts = map { remove_prefixes_and_suffixes($_) } @insts;
    @insts = map { normalize_opcodes($_) } @insts;
    @insts = map { normalize_conditions( $_, $cpu ) } @insts;
    return @insts;
}

sub parse_assembly {
    my ( $asm, $cpu ) = @_;

    # text cleanup
    $asm = lc($asm);
    $asm =~ s/^\s+|\s+$//g;

    if ( $asm =~ /^ (%t \d*) : $/x ) {
        return { type => 'label', name => $1 };
    }

    my %prefixes = extract_prefixes( \$asm );
    my ( $opcode, $suffix ) = extract_opcode_and_suffix( \$asm, $cpu );
    my @opr = split /\s*,\s*/, $asm;
    add_default_a_register( \@opr, $opcode );
    add_default_b_register( \@opr, $opcode );
    my @args = map { parse_operand($_) } @opr;

    return {
        type     => 'inst',
        opcode   => $opcode,
        prefixes => \%prefixes,
        suffix   => $suffix,
        args     => \@args,
    };
}

sub extract_prefixes {
    my ($asm_ref) = @_;

    my %prefixes = ( altd => 0, alts => 0, io => undef );
    while ( $$asm_ref =~ s/^(altd|alts|altsd|ioi|ioe)\s+// ) {
        my $prefix = $1;
        $prefixes{altd}++       if $prefix =~ /^(altd|altsd)$/;
        $prefixes{alts}++       if $prefix =~ /^(alts|altsd)$/;
        $prefixes{io} = $prefix if $prefix =~ /^(ioi|ioe)$/;
    }

    return %prefixes;
}

sub extract_opcode_and_suffix {
    my ( $asm_ref, $cpu ) = @_;

    if ( $$asm_ref =~ s/^ (\w+) \. ( [sl]i[sl] | i[sl] | [sl] ) \b \s* //x ) {
        my ( $opcode, $suffix ) = ( $1, $2 );
        if ( $suffix =~ /^i[sl]$/ ) {
            $suffix = ( $cpu eq "ez80" ? "l" : "s" ) . $suffix;    # ix -> xix
        }
        elsif ( $suffix =~ /^[sl]$/ ) {
            $suffix .= ( $cpu eq "ez80" ? "il" : "is" );           # x -> xix
        }

        return ( $opcode, $suffix );
    }

    if ( $$asm_ref =~ s/^ (\w+) \b \s* //x ) {
        return ( $1, undef );
    }

    die "Failed to extract opcode and suffix from '$$asm_ref'";
}

sub add_default_a_register {
    my ( $args_ref, $opcode ) = @_;

    # add default a register for certain opcodes with only one operand
    if ( @$args_ref == 1 && $opcode =~ /\b(add|adc|sub|sbc|and|or|xor|cp|cmp)\b/ ) {
        unshift @$args_ref, "a";
    }
    elsif ( @$args_ref == 0 && $opcode =~ /\b(neg|cpl)\b/ ) {
        push @$args_ref, "a";
    }
}

sub add_default_b_register {
    my ( $args_ref, $opcode ) = @_;

    # add default b register for djnz with only one operand
    if ( @$args_ref == 1 && $opcode =~ /\bdjnz\b/ ) {
        unshift @$args_ref, "b";
    }
}

sub parse_operand {
    my ($opr) = @_;

    if ( $opr =~ /^ (a|f|b|d|e|h|l|ixl|ixh|iyl|iyh) ('?) $/x ) {
        return { type => 'reg', name => $1, alt => $2 ? 1 : 0, width => undef };
    }

    if ( $opr =~ /^ (bc|de|hl|jk|af|sp|ix|iy) ('?) $/x ) {
        return { type => 'regpair', name => $1, alt => $2 ? 1 : 0, width => undef };
    }

    if ( $opr =~ /^ (bcde|jkhl) ('?) $/x ) {
        return { type => 'regpair', name => $1, alt => $2 ? 1 : 0, width => undef };
    }

    if ( $opr =~ /^ (hl|sp) \+ (%d|%n) ('?) $/x ) {
        return {
            type        => 'regpair',
            name        => $1,
            alt         => $3 ? 1 : 0,
            disp        => $2,
            disp_offset => 0,
            width       => undef
        };
    }

    if ( $opr =~ /^ (nz|z|nc|po|pe|p|m|nv|v|lz|lo|eq|ne|gtu|ltu|geu|leu|lt|gt|ge|le) $/x ) {
        return { type => 'cond', name => $1 };
    }

    if ( $opr =~ /^ (c) ('?) $/x ) {    # C can be a register or a flag
        my $alt = $2 ? 1 : 0;
        return { type => $alt ? 'reg' : 'ident', name => $1, alt => $alt, width => undef };
    }

    if ( $opr =~ /^ \( (c) \) $/x ) {
        return {
            type  => 'mem',
            base  => $1,
            disp  => undef,
            space => 'io',
            post  => 0,
            width => undef
        };
    }

    if ( $opr =~ /^ \( (hl) ([id]?) \) $/x ) {
        return {
            type  => 'mem',
            base  => $1,
            disp  => undef,
            space => 'mem',
            post  => $2 eq "i" ? 1 : $2 eq "d" ? -1 : 0,
            width => undef
        };
    }

    if ( $opr =~ /^ \( (bc|de|hl|sp|ix|iy) ([-+]?) \) $/x ) {
        return {
            type  => 'mem',
            base  => $1,
            disp  => undef,
            space => 'mem',
            post  => $2 eq '+' ? 1 : $2 eq '-' ? -1 : 0,
            width => undef
        };
    }

    if ( $opr =~ /^ \( (ix|iy) \) $/x ) {
        return {
            type        => 'mem',
            base        => $1,
            disp        => undef,
            disp_offset => 0,
            space       => 'mem',
            post        => 0,
            width       => undef
        };
    }

    if ( $opr =~ /^ \( (ix|iy) \+ 1\) $/x ) {
        return {
            type        => 'mem',
            base        => $1,
            disp        => undef,
            disp_offset => 1,
            space       => 'mem',
            post        => 0,
            width       => undef
        };
    }

    if ( $opr =~ /^ \( (ix|iy) \+ (%d) \) $/x ) {
        return {
            type        => 'mem',
            base        => $1,
            disp        => $2,
            disp_offset => 0,
            space       => 'mem',
            post        => 0,
            width       => undef
        };
    }

    if ( $opr =~ /^ \( (ix|iy) \+ \( (%d) \) \+ 1 \) $/x ) {
        return {
            type        => 'mem',
            base        => $1,
            disp        => $2,
            disp_offset => 1,
            space       => 'mem',
            post        => 0,
            width       => undef
        };
    }

    if ( $opr =~ /^ (%n|%d|%m|%j|%J|0|1|2) $/x ) {
        return { type => 'imm', value => $1, width => undef };
    }

    if ( $opr =~ /^ \( (%m) \) $/x ) {
        return {
            type        => 'mem',
            base        => undef,
            addr        => $1,
            disp        => undef,
            disp_offset => 0,
            space       => 'mem',
            width       => undef
        };
    }

    if ( $opr =~ /^ \( \+ \( (%m) \) \+ (1) \) $/x ) {
        return {
            type        => 'mem',
            base        => undef,
            addr        => $1,
            disp        => undef,
            disp_offset => 1,
            space       => 'mem',
            width       => undef
        };
    }

    if ( $opr =~ /^ (%t\d*) $/x ) {
        return { type => 'labelref', name => $1, width => undef };
    }

    if ( $opr =~ /^ (__z80asm__\w+) $/x ) {
        return { type => 'symbol', name => $1 };
    }

    die "Failed to parse operand '$opr'";
}

sub lower_condition {
    my ($inst) = @_;

    return $inst unless $inst->{type} eq "inst";

    # check if condition is allowed
    my $can_have_cond = $inst->{opcode} =~ /^ ( jp | jp3 | jmp | 
                                jr | jre | call | call3 | 
                                ret | ret3
                            ) \b /x;

    # replace ident 'c' by 'cond' or 'reg' depending on context
    for my $arg ( @{ $inst->{args} } ) {
        if ( $arg->{type} eq "ident" && $arg->{name} eq "c" ) {
            if ($can_have_cond) {
                $arg->{type} = "cond";
            }
            else {
                $arg->{type} = "reg";
            }
        }
        die "Unexpected argument type 'ident': ", dump($inst)
            if $arg->{type} eq "ident";
    }

    # remove cond argument and move to opcode
    if ($can_have_cond) {
        if ( @{ $inst->{args} } && $inst->{args}->[0]{type} eq "cond" ) {
            $inst->{cond} = $inst->{args}->[0]{name};
            shift @{ $inst->{args} };
        }
    }

    # all cond arguments should have been processed
    for my $arg ( @{ $inst->{args} } ) {
        if ( $arg->{type} eq "cond" ) {
            die "Unexpected condition argument: ", dump($inst);
        }
    }

    return $inst;
}

sub lower_emulated_ops {
    my ($inst) = @_;

    return $inst unless $inst->{type} eq "inst";

    if (   $inst->{opcode} eq "call"
        && @{ $inst->{args} } == 1
        && $inst->{args}->[0]->{type} eq "symbol"
        && $inst->{args}->[0]->{name} =~ /^__z80asm__/ )
    {
        my $func = $inst->{args}->[0]->{name};
        if ( $func =~ /__z80asm__adc_hl_(\w\w)/ ) {
            return {
                type     => 'inst',
                opcode   => 'adc',
                prefixes => {},
                suffix   => undef,
                args     => [
                    { type => 'regpair', name => 'hl', alt => 0, width => undef },
                    { type => 'regpair', name => $1,   alt => 0, width => undef }
                ]
            };
        }
        if ( $func =~ /__z80asm__add_(\w\w)_a/ ) {
            return {
                type     => 'inst',
                opcode   => 'add',
                prefixes => {},
                suffix   => undef,
                args     => [
                    { type => 'regpair', name => $1,  alt => 0, width => undef },
                    { type => 'reg',     name => 'a', alt => 0, width => undef }
                ]
            };
        }
        if ( $func =~ /__z80asm__add_hl_(\w\w)/ ) {
            return {
                type     => 'inst',
                opcode   => 'add',
                prefixes => {},
                suffix   => undef,
                args     => [
                    { type => 'regpair', name => 'hl', alt => 0, width => undef },
                    { type => 'regpair', name => $1,   alt => 0, width => undef }
                ]
            };
        }
        if ( $func =~ /__z80asm__sbc_hl_(\w\w)/ ) {
            return {
                type     => 'inst',
                opcode   => 'sbc',
                prefixes => {},
                suffix   => undef,
                args     => [
                    { type => 'regpair', name => 'hl', alt => 0, width => undef },
                    { type => 'regpair', name => $1,   alt => 0, width => undef }
                ]
            };
        }
        if ( $func =~ /__z80asm__sub_hl_(\w\w)/ ) {
            return {
                type     => 'inst',
                opcode   => 'sub',
                prefixes => {},
                suffix   => undef,
                args     => [
                    { type => 'regpair', name => 'hl', alt => 0, width => undef },
                    { type => 'regpair', name => $1,   alt => 0, width => undef }
                ]
            };
        }
        if ( $func =~ /__z80asm__add_sp_d/ ) {
            return {
                type     => 'inst',
                opcode   => 'add',
                prefixes => {},
                suffix   => undef,
                args     => [
                    { type => 'regpair', name  => 'sp', alt   => 0, width => undef },
                    { type => 'imm',     value => '%d', width => undef }
                ]
            };
        }
        if ( $func =~ /__z80asm__(cpi|cpir|cpd|cpdr|ldi|ldir|ldd|lddr|daa|rld|rrd)$/ ) {
            return { type => 'inst', opcode => $1, prefixes => {}, suffix => undef, args => [] };
        }
        if ( $func =~ /__z80asm__sra_(\w\w)/ ) {
            return {
                type     => 'inst',
                opcode   => 'sra',
                prefixes => {},
                suffix   => undef,
                args     => [ { type => 'regpair', name => $1, alt => 0, width => undef } ]
            };
        }
        if ( $func =~ /__z80asm__rl_(\w\w)/ ) {
            return {
                type     => 'inst',
                opcode   => 'rl',
                prefixes => {},
                suffix   => undef,
                args     => [ { type => 'regpair', name => $1, alt => 0, width => undef } ]
            };
        }
        if ( $func =~ /__z80asm__rr_(\w\w)/ ) {
            return {
                type     => 'inst',
                opcode   => 'rr',
                prefixes => {},
                suffix   => undef,
                args     => [ { type => 'regpair', name => $1, alt => 0, width => undef } ]
            };
        }
        if ( $func =~ /__z80asm__call_(\w\w)/ ) {
            return {
                type     => 'inst',
                opcode   => 'call',
                prefixes => {},
                suffix   => undef,
                args     => [
                    {
                        type  => 'mem',
                        base  => $1,
                        space => 'mem',
                        disp  => undef,
                        post  => 0,
                        width => undef
                    }
                ]
            };
        }
        if ( $func =~ /__z80asm__ex_sp_hl/ ) {
            return {
                type     => 'inst',
                opcode   => 'ex',
                prefixes => {},
                suffix   => undef,
                args     => [
                    {
                        type  => 'mem',
                        base  => 'sp',
                        disp  => undef,
                        space => 'mem',
                        post  => 0,
                        width => undef
                    },
                    { type => 'regpair', name => 'hl', alt => 0, width => undef }
                ]
            };
        }
    }

    for my $arg ( @{ $inst->{args} } ) {
        if ( $arg->{type} eq "symbol" ) {
            die "Unknown emulated function: ", dump($inst);
        }
    }

    return $inst;
}

sub lower_rabbit_prefixes {
    my ($inst) = @_;

    return $inst unless $inst->{type} eq "inst";

    if ( $inst->{prefixes}{altd} ) {
        @{ $inst->{args} } or die "altd prefix requires at least one argument in ", dump($inst);
        my $first_arg = $inst->{args}->[0];
        if ( $first_arg->{type} eq "reg" || $first_arg->{type} eq "regpair" ) {
            $first_arg->{alt} = 1;
        }
        else {
            die "altd prefix requires first argument to be a register in ", dump($inst);
        }
    }

    if ( $inst->{prefixes}{alts} ) {
        @{ $inst->{args} } == 2
            or die "alts prefix requires exactly two arguments in ", dump($inst);
        my $second_arg = $inst->{args}->[1];
        if ( $second_arg->{type} eq "reg" || $second_arg->{type} eq "regpair" ) {
            $second_arg->{alt} = 1;
        }
        else {
            die "alts prefix requires second argument to be a register in ", dump($inst);
        }
    }

    if ( defined $inst->{prefixes}{io} ) {
        my $io = $inst->{prefixes}{io};
        for my $arg ( @{ $inst->{args} } ) {
            if ( $arg->{type} eq "mem" ) {
                $arg->{space} = $io;
            }
        }
    }

    return $inst;
}

sub lower_ez80_suffixes {
    my ($inst) = @_;

    return $inst unless $inst->{type} eq "inst";

    if ( $inst->{suffix} ) {
        my $suffix = $inst->{suffix};
        for my $arg ( @{ $inst->{args} } ) {
            if ( $arg->{type} eq "regpair" || $arg->{type} eq "mem" || $arg->{type} eq "imm" ) {
                $arg->{width} = $suffix;
            }
        }
    }

    return $inst;
}

sub normalize_ex_args {
    my ($inst) = @_;

    return $inst unless $inst->{type} eq "inst";
    return $inst unless $inst->{opcode} eq "ex";

    # ensure ex arguments are in a consistent order
    @{ $inst->{args} } =
        sort { $a->{type} cmp $b->{type} || $a->{name} cmp $b->{name} || $a->{alt} cmp $b->{alt} }
        @{ $inst->{args} };

    # replace ex af, af by ex af, af'
    if ( @{ $inst->{args} } == 2 ) {
        my ( $arg1, $arg2 ) = @{ $inst->{args} };
        if (   $arg1->{type} eq "regpair"
            && $arg1->{name} eq "af"
            && $arg1->{alt} == 0
            && $arg2->{type} eq "regpair"
            && $arg2->{name} eq "af"
            && $arg2->{alt} == 0 )
        {
            $arg2->{alt} = 1;
        }
    }

    return $inst;
}

sub normalize_adi {
    my ($inst) = @_;

    return $inst unless $inst->{type} eq "inst";
    return $inst unless $inst->{opcode} eq "adi";

    if ( @{ $inst->{args} } == 2
        && $inst->{args}->[0]{type} eq "regpair" )
    {
        my $base = $inst->{args}->[0]{name};

        if ( $inst->{args}->[1]{type} eq "imm"
            && defined $inst->{args}->[1]{value} )
        {
            my $disp = $inst->{args}->[1]{value};
            return {
                type     => 'inst',
                opcode   => 'ld',
                prefixes => {},
                suffix   => undef,
                args     => [
                    { type => 'regpair', name => "de", alt => 0, width => undef },
                    {
                        alt         => 0,
                        disp        => $disp,
                        disp_offset => 0,
                        type        => 'regpair',
                        name        => $base,
                        width       => undef
                    }
                ]
            };
        }
    }

    return $inst;
}

sub lower_postinc {
    my ($inst) = @_;

    return $inst unless $inst->{type} eq "inst";

    my $is_post = $inst->{opcode} eq "ldi" ? 1 : $inst->{opcode} eq "ldd" ? -1 : 0;
    if ( $is_post != 0 ) {
        $inst->{opcode} = "ld";
    }

    my @new_insts;
    for my $i ( 0 .. $#{ $inst->{args} } ) {
        my $arg         = $inst->{args}[$i];
        my $is_post_arg = defined $arg->{post} ? $arg->{post} : 0;
        if ( $is_post != 0 && $is_post_arg != 0 ) {
            die "Post-increment/decrement not allowed on multiple arguments in ", dump($inst);
        }
        my $post = $is_post + $is_post_arg;
        if ( $arg->{type} eq "mem" && $post != 0 ) {
            $arg->{post} = 0;

            # build post-increment/decrement instruction
            my $post_inst = {
                type   => 'inst',
                opcode => $post > 0 ? 'inc' : 'dec',
                args   => [
                    {
                        type  => 'regpair',
                        name  => $arg->{base},
                        alt   => 0,
                        width => $inst->{suffix},
                    }
                ]
            };

            # check if the other argument is a register pair, e.g. ld bc, (hl+)
            $i == 0 || $i == 1 or die "Invalid argument index $i in ", dump($inst);
            if ( $inst->{args}->[ 1 - $i ] && $inst->{args}->[ 1 - $i ]{type} eq "regpair" ) {
                push @new_insts, clone($post_inst);
                push @new_insts, clone($post_inst);
            }
            else {
                push @new_insts, clone($post_inst);
            }
        }
    }

    return ( $inst, @new_insts );
}

sub remove_prefixes_and_suffixes {
    my ($inst) = @_;

    delete $inst->{prefixes};
    delete $inst->{suffix};

    return $inst;
}

sub normalize_conditions {
    my ( $inst, $cpu ) = @_;

    return $inst unless $inst->{type} eq "inst";
    return $inst unless defined $inst->{cond};

    # r4k, r5k, r6k have extra conditions
    if ( $cpu =~ /^r[456]k/ ) {
        for my $flag (qw( gt gtu lt v )) {
            return $inst if $inst->{cond} eq $flag;
            return $inst if $inst->{cond} eq invert_flag($flag);
        }
    }

    if ( $inst->{cond} eq "eq" ) {
        $inst->{cond} = "z";
        return $inst;
    }

    if ( $inst->{cond} eq "ne" ) {
        $inst->{cond} = "nz";
        return $inst;
    }

    if ( $inst->{cond} eq "ltu" ) {
        $inst->{cond} = "c";
        return $inst;
    }

    if ( $inst->{cond} eq "geu" ) {
        $inst->{cond} = "nc";
        return $inst;
    }

    if ( $inst->{cond} eq "lz" ) {
        $inst->{cond} = "po";
        return $inst;
    }

    if ( $inst->{cond} eq "lo" ) {
        $inst->{cond} = "pe";
        return $inst;
    }

    if ( $inst->{cond} eq "nv" ) {
        $inst->{cond} = "po";
        return $inst;
    }

    if ( $inst->{cond} eq "v" ) {
        $inst->{cond} = "pe";
        return $inst;
    }

    return $inst;
}

sub normalize_opcodes {
    my ($inst) = @_;

    return $inst unless $inst->{type} eq "inst";

    if ( $inst->{opcode} eq "jr" ) {
        $inst->{opcode} = "jp";
    }
    elsif ( $inst->{opcode} eq "jre" ) {
        $inst->{opcode} = "jp";
    }
    elsif ( $inst->{opcode} eq "jmp" ) {
        $inst->{opcode} = "jp";
    }
    elsif ( $inst->{opcode} eq "jp3" ) {
        $inst->{opcode} = "jp";
    }
    elsif ( $inst->{opcode} eq "call3" ) {
        $inst->{opcode} = "call";
    }
    elsif ( $inst->{opcode} eq "ret3" ) {
        $inst->{opcode} = "ret";
    }
    elsif ( $inst->{opcode} eq "cmp" ) {
        $inst->{opcode} = "cp";
    }

    return $inst;
}

sub normalize_effects {
    my @effects = @_;

    my $repeat;
    do {
        $repeat = 0;

        # ld reg, 0 -> clr reg
        for my $effect (@effects) {
            if (
                   $effect->{type} eq "inst"
                && $effect->{opcode} eq "ld"
                && @{ $effect->{args} } == 2
                && (   $effect->{args}[0]{type} eq "reg"
                    || $effect->{args}[0]{type} eq "regpair"
                    || $effect->{args}[0]{type} eq "mem" )
                && $effect->{args}[1]{type} eq "imm"
                && $effect->{args}[1]{value} eq "0"
                )
            {
                $effect->{opcode} = "clr";
                splice @{ $effect->{args} }, 1, 1;    # remove immediate argument
                $repeat = 1;
            }
        }

        # ld b, h:ld c, l -> ld bc, hl
        for ( my $i = 0 ; $i <= $#effects - 1 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "ld"
                && @{ $effects[$i]{args} } == 2
                && $effects[$i]{args}[0]{type} eq "reg"
                && $effects[$i]{args}[0]{name} ne "a"
                && $effects[$i]{args}[1]{type} eq "reg"
                && $effects[$i]{args}[1]{name} ne "a" )
            {
                my $dest_h     = $effects[$i]{args}[0]{name};
                my $dest_h_alt = $effects[$i]{args}[0]{alt};
                my $src_h      = $effects[$i]{args}[1]{name};
                my $src_h_alt  = $effects[$i]{args}[1]{alt};

                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "ld"
                    && @{ $effects[ $i + 1 ]{args} } == 2
                    && $effects[ $i + 1 ]{args}[0]{type} eq "reg"
                    && $effects[ $i + 1 ]{args}[0]{name} ne "a"
                    && $effects[ $i + 1 ]{args}[1]{type} eq "reg"
                    && $effects[ $i + 1 ]{args}[1]{name} ne "a" )
                {
                    my $dest_l     = $effects[ $i + 1 ]{args}[0]{name};
                    my $dest_l_alt = $effects[ $i + 1 ]{args}[0]{alt};
                    my $src_l      = $effects[ $i + 1 ]{args}[1]{name};
                    my $src_l_alt  = $effects[ $i + 1 ]{args}[1]{alt};

                    # ensure alt flags match for both high and low parts
                    if (   $dest_h_alt == $dest_l_alt
                        && $src_h_alt == $src_l_alt )
                    {
                        # combine into ld regpair, regpair
                        my $regpair_dest = reg_pair( $dest_h, $dest_l );
                        my $regpair_src  = reg_pair( $src_h,  $src_l );
                        splice @effects, $i, 2,
                            {
                            type   => 'inst',
                            opcode => 'ld',
                            args   => [
                                {
                                    type  => 'regpair',
                                    name  => $regpair_dest,
                                    alt   => $dest_h_alt,
                                    width => undef
                                },
                                {
                                    type  => 'regpair',
                                    name  => $regpair_src,
                                    alt   => $src_h_alt,
                                    width => undef
                                }
                            ]
                            };
                        $repeat = 1;
                    }
                }
            }
        }

        # push hl: push de: pop hl:pop de -> ex de, hl
        for ( my $i = 0 ; $i <= $#effects - 3 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "push"
                && @{ $effects[$i]{args} } == 1
                && $effects[$i]{args}[0]{type} eq "regpair" )
            {
                my $src1_regpair = $effects[$i]{args}[0]{name};
                my $src1_alt     = $effects[$i]{args}[0]{alt};
                my $src1_width   = $effects[$i]{args}[0]{width};

                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "push"
                    && @{ $effects[ $i + 1 ]{args} } == 1
                    && $effects[ $i + 1 ]{args}[0]{type} eq "regpair" )
                {
                    my $src2_regpair = $effects[ $i + 1 ]{args}[0]{name};
                    my $src2_alt     = $effects[ $i + 1 ]{args}[0]{alt};
                    my $src2_width   = $effects[ $i + 1 ]{args}[0]{width};

                    if (   $effects[ $i + 2 ]{type} eq "inst"
                        && $effects[ $i + 2 ]{opcode} eq "pop"
                        && @{ $effects[ $i + 2 ]{args} } == 1
                        && $effects[ $i + 2 ]{args}[0]{type} eq "regpair" )
                    {
                        my $dest1_regpair = $effects[ $i + 2 ]{args}[0]{name};
                        my $dest1_alt     = $effects[ $i + 2 ]{args}[0]{alt};
                        my $dest1_width   = $effects[ $i + 2 ]{args}[0]{width};

                        if (   $effects[ $i + 3 ]{type} eq "inst"
                            && $effects[ $i + 3 ]{opcode} eq "pop"
                            && @{ $effects[ $i + 3 ]{args} } == 1
                            && $effects[ $i + 3 ]{args}[0]{type} eq "regpair" )
                        {
                            my $dest2_regpair = $effects[ $i + 3 ]{args}[0]{name};
                            my $dest2_alt     = $effects[ $i + 3 ]{args}[0]{alt};
                            my $dest2_width   = $effects[ $i + 3 ]{args}[0]{width};

                            if (   $src1_regpair eq $dest1_regpair
                                && ( $src1_alt   // "" ) eq ( $dest1_alt   // "" )
                                && ( $src1_width // "" ) eq ( $dest1_width // "" )
                                && $src2_regpair eq $dest2_regpair
                                && ( $src2_alt   // "" ) eq ( $dest2_alt   // "" )
                                && ( $src2_width // "" ) eq ( $dest2_width // "" ) )
                            {
                                # combine into ex dest1_regpair, src1_regpair
                                my @args = (
                                    {
                                        type  => 'regpair',
                                        name  => $src1_regpair,
                                        alt   => $src1_alt,
                                        width => $src1_width
                                    },
                                    {
                                        type  => 'regpair',
                                        name  => $src2_regpair,
                                        alt   => $src2_alt,
                                        width => $src2_width
                                    }
                                );
                                @args = sort { $a->{name} cmp $b->{name} }
                                    @args;    # ensure consistent order
                                splice @effects, $i, 4,
                                    {
                                    type   => 'inst',
                                    opcode => 'ex',
                                    args   => \@args,
                                    };
                                $repeat = 1;
                            }
                        }
                    }
                }
            }
        }

        # push hl:pop bc -> ld bc, hl
        for ( my $i = 0 ; $i <= $#effects - 1 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "push"
                && @{ $effects[$i]{args} } == 1
                && $effects[$i]{args}[0]{type} eq "regpair" )
            {
                my $src_regpair = $effects[$i]{args}[0]{name};
                my $src_alt     = $effects[$i]{args}[0]{alt};
                my $src_width   = $effects[$i]{args}[0]{width};

                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "pop"
                    && @{ $effects[ $i + 1 ]{args} } == 1
                    && $effects[ $i + 1 ]{args}[0]{type} eq "regpair" )
                {
                    my $dest_regpair = $effects[ $i + 1 ]{args}[0]{name};
                    my $dest_alt     = $effects[ $i + 1 ]{args}[0]{alt};
                    my $dest_width   = $effects[ $i + 1 ]{args}[0]{width};

                    # combine into ld dest_regpair, src_regpair
                    splice @effects, $i, 2,
                        {
                        type   => 'inst',
                        opcode => 'ld',
                        args   => [
                            {
                                type  => 'regpair',
                                name  => $dest_regpair,
                                alt   => $dest_alt,
                                width => $dest_width
                            },
                            {
                                type  => 'regpair',
                                name  => $src_regpair,
                                alt   => $src_alt,
                                width => $src_width
                            }
                        ]
                        };
                    $repeat = 1;
                }
            }
        }

        # push hl: ld hl, %m: add hl, bc: ld bc, hl: pop hl -> add bc, %m
        for ( my $i = 0 ; $i <= $#effects - 4 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "push"
                && @{ $effects[$i]{args} } == 1
                && $effects[$i]{args}[0]{type} eq "regpair"
                && $effects[$i]{args}[0]{name} eq "hl" )
            {
                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "ld"
                    && @{ $effects[ $i + 1 ]{args} } == 2
                    && $effects[ $i + 1 ]{args}[0]{type} eq "regpair"
                    && $effects[ $i + 1 ]{args}[0]{name} eq "hl"
                    && $effects[ $i + 1 ]{args}[1]{type} eq "imm" )
                {
                    my $imm_arg = $effects[ $i + 1 ]{args}[1];

                    if (   $effects[ $i + 2 ]{type} eq "inst"
                        && $effects[ $i + 2 ]{opcode} eq "add"
                        && @{ $effects[ $i + 2 ]{args} } == 2
                        && $effects[ $i + 2 ]{args}[0]{type} eq "regpair"
                        && $effects[ $i + 2 ]{args}[0]{name} eq "hl"
                        && $effects[ $i + 2 ]{args}[1]{type} eq "regpair" )
                    {
                        my $dest_arg = $effects[ $i + 2 ]{args}[1];

                        if (   $effects[ $i + 3 ]{type} eq "inst"
                            && $effects[ $i + 3 ]{opcode} eq "ld"
                            && @{ $effects[ $i + 3 ]{args} } == 2
                            && $effects[ $i + 3 ]{args}[0]{type} eq "regpair"
                            && $effects[ $i + 3 ]{args}[0]{name} eq $dest_arg->{name}
                            && $effects[ $i + 3 ]{args}[1]{type} eq "regpair"
                            && $effects[ $i + 3 ]{args}[1]{name} eq "hl" )
                        {
                            if (   $effects[ $i + 4 ]{type} eq "inst"
                                && $effects[ $i + 4 ]{opcode} eq "pop"
                                && @{ $effects[ $i + 4 ]{args} } == 1
                                && $effects[ $i + 4 ]{args}[0]{type} eq "regpair"
                                && $effects[ $i + 4 ]{args}[0]{name} eq "hl" )
                            {
                                # combine into add dest_arg, imm_arg
                                splice @effects, $i, 5,
                                    {
                                    type   => 'inst',
                                    opcode => 'add',
                                    args   => [ $dest_arg, $imm_arg ],
                                    };
                                $repeat = 1;
                            }
                        }
                    }
                }
            }
        }

        # push de: ld de, %m: add hl, de: pop de -> add hl, %m
        for ( my $i = 0 ; $i <= $#effects - 3 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "push"
                && @{ $effects[$i]{args} } == 1
                && $effects[$i]{args}[0]{type} eq "regpair"
                && $effects[$i]{args}[0]{name} eq "de" )
            {
                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "ld"
                    && @{ $effects[ $i + 1 ]{args} } == 2
                    && $effects[ $i + 1 ]{args}[0]{type} eq "regpair"
                    && $effects[ $i + 1 ]{args}[0]{name} eq "de"
                    && $effects[ $i + 1 ]{args}[1]{type} eq "imm" )
                {
                    my $imm_arg = $effects[ $i + 1 ]{args}[1];

                    if (   $effects[ $i + 2 ]{type} eq "inst"
                        && $effects[ $i + 2 ]{opcode} eq "add"
                        && @{ $effects[ $i + 2 ]{args} } == 2
                        && $effects[ $i + 2 ]{args}[0]{type} eq "regpair"
                        && $effects[ $i + 2 ]{args}[0]{name} eq "hl"
                        && $effects[ $i + 2 ]{args}[1]{type} eq "regpair"
                        && $effects[ $i + 2 ]{args}[1]{name} eq "de" )
                    {
                        my $dest_arg = $effects[ $i + 2 ]{args}[0];

                        if (   $effects[ $i + 3 ]{type} eq "inst"
                            && $effects[ $i + 3 ]{opcode} eq "pop"
                            && @{ $effects[ $i + 3 ]{args} } == 1
                            && $effects[ $i + 3 ]{args}[0]{type} eq "regpair"
                            && $effects[ $i + 3 ]{args}[0]{name} eq "de" )
                        {
                            # combine into add hl, imm_arg
                            splice @effects, $i, 4,
                                {
                                type   => 'inst',
                                opcode => 'add',
                                args   => [ $dest_arg, $imm_arg ],
                                };
                            $repeat = 1;
                        }
                    }
                }
            }
        }

        # add sp, %d: defb %d -> add sp, %d
        for ( my $i = 0 ; $i <= $#effects - 1 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "add"
                && @{ $effects[$i]{args} } == 2
                && $effects[$i]{args}[0]{type} eq "regpair"
                && $effects[$i]{args}[0]{name} eq "sp"
                && $effects[$i]{args}[1]{type} eq "imm" )
            {
                my $imm1_arg = $effects[$i]{args}[1];

                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "defb"
                    && @{ $effects[ $i + 1 ]{args} } == 1
                    && $effects[ $i + 1 ]{args}[0]{type} eq "imm" )
                {
                    my $imm2_arg = $effects[ $i + 1 ]{args}[0];

                    if ( $imm1_arg->{value} eq $imm2_arg->{value} ) {

                        # remove defb %d
                        splice @effects, $i + 1, 1;
                    }
                }
            }
        }

        # push hl: ld de, %n: add hl, de: ex de, hl: pop hl -> ld de, hl+%n
        for ( my $i = 0 ; $i <= $#effects - 4 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "push"
                && @{ $effects[$i]{args} } == 1
                && $effects[$i]{args}[0]{type} eq "regpair"
                && $effects[$i]{args}[0]{name} eq "hl" )
            {
                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "ld"
                    && @{ $effects[ $i + 1 ]{args} } == 2
                    && $effects[ $i + 1 ]{args}[0]{type} eq "regpair"
                    && $effects[ $i + 1 ]{args}[0]{name} eq "de"
                    && $effects[ $i + 1 ]{args}[1]{type} eq "imm" )
                {
                    my $imm_arg = $effects[ $i + 1 ]{args}[1]{value};

                    if (   $effects[ $i + 2 ]{type} eq "inst"
                        && $effects[ $i + 2 ]{opcode} eq "add"
                        && @{ $effects[ $i + 2 ]{args} } == 2
                        && $effects[ $i + 2 ]{args}[0]{type} eq "regpair"
                        && $effects[ $i + 2 ]{args}[0]{name} eq "hl"
                        && $effects[ $i + 2 ]{args}[1]{type} eq "regpair"
                        && $effects[ $i + 2 ]{args}[1]{name} eq "de" )
                    {
                        if (   $effects[ $i + 3 ]{type} eq "inst"
                            && $effects[ $i + 3 ]{opcode} eq "ex"
                            && @{ $effects[ $i + 3 ]{args} } == 2
                            && $effects[ $i + 3 ]{args}[0]{type} eq "regpair"
                            && $effects[ $i + 3 ]{args}[0]{name} eq "de"
                            && $effects[ $i + 3 ]{args}[1]{type} eq "regpair"
                            && $effects[ $i + 3 ]{args}[1]{name} eq "hl" )
                        {
                            if (   $effects[ $i + 4 ]{type} eq "inst"
                                && $effects[ $i + 4 ]{opcode} eq "pop"
                                && @{ $effects[ $i + 4 ]{args} } == 1
                                && $effects[ $i + 4 ]{args}[0]{type} eq "regpair"
                                && $effects[ $i + 4 ]{args}[0]{name} eq "hl" )
                            {
                                # combine into ld de, hl+imm_arg
                                splice @effects, $i, 5,
                                    {
                                    type   => 'inst',
                                    opcode => 'ld',
                                    args   => [
                                        {
                                            type  => 'regpair',
                                            name  => 'de',
                                            alt   => 0,
                                            width => undef
                                        },
                                        {
                                            alt         => 0,
                                            disp        => $imm_arg,
                                            disp_offset => 0,
                                            name        => 'hl',
                                            type        => 'regpair',
                                            width       => undef
                                        }
                                    ],
                                    };
                                $repeat = 1;
                            }
                        }
                    }
                }
            }
        }

        # ex de, hl: ld hl, %n: add hl, sp: ex de, hl -> ld de, sp+%n
        for ( my $i = 0 ; $i <= $#effects - 3 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "ex"
                && @{ $effects[$i]{args} } == 2
                && $effects[$i]{args}[0]{type} eq "regpair"
                && $effects[$i]{args}[0]{name} eq "de"
                && $effects[$i]{args}[1]{type} eq "regpair"
                && $effects[$i]{args}[1]{name} eq "hl" )
            {
                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "ld"
                    && @{ $effects[ $i + 1 ]{args} } == 2
                    && $effects[ $i + 1 ]{args}[0]{type} eq "regpair"
                    && $effects[ $i + 1 ]{args}[0]{name} eq "hl"
                    && $effects[ $i + 1 ]{args}[1]{type} eq "imm" )
                {
                    my $imm_arg = $effects[ $i + 1 ]{args}[1]{value};

                    if (   $effects[ $i + 2 ]{type} eq "inst"
                        && $effects[ $i + 2 ]{opcode} eq "add"
                        && @{ $effects[ $i + 2 ]{args} } == 2
                        && $effects[ $i + 2 ]{args}[0]{type} eq "regpair"
                        && $effects[ $i + 2 ]{args}[0]{name} eq "hl"
                        && $effects[ $i + 2 ]{args}[1]{type} eq "regpair"
                        && $effects[ $i + 2 ]{args}[1]{name} eq "sp" )
                    {
                        if (   $effects[ $i + 3 ]{type} eq "inst"
                            && $effects[ $i + 3 ]{opcode} eq "ex"
                            && @{ $effects[ $i + 3 ]{args} } == 2
                            && $effects[ $i + 3 ]{args}[0]{type} eq "regpair"
                            && $effects[ $i + 3 ]{args}[0]{name} eq "de"
                            && $effects[ $i + 3 ]{args}[1]{type} eq "regpair"
                            && $effects[ $i + 3 ]{args}[1]{name} eq "hl" )
                        {
                            # combine into ld de, hl+imm_arg
                            splice @effects, $i, 4,
                                {
                                type   => 'inst',
                                opcode => 'ld',
                                args   => [
                                    {
                                        type  => 'regpair',
                                        name  => 'de',
                                        alt   => 0,
                                        width => undef
                                    },
                                    {
                                        alt         => 0,
                                        disp        => $imm_arg,
                                        disp_offset => 0,
                                        name        => 'sp',
                                        type        => 'regpair',
                                        width       => undef
                                    }
                                ],
                                };
                            $repeat = 1;
                        }
                    }
                }
            }
        }

        # ex de, hl: clr hl: add hl, sp: ex de, hl -> ld de, sp+%n
        for ( my $i = 0 ; $i <= $#effects - 3 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "ex"
                && @{ $effects[$i]{args} } == 2
                && $effects[$i]{args}[0]{type} eq "regpair"
                && $effects[$i]{args}[0]{name} eq "de"
                && $effects[$i]{args}[1]{type} eq "regpair"
                && $effects[$i]{args}[1]{name} eq "hl" )
            {
                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "clr"
                    && @{ $effects[ $i + 1 ]{args} } == 1
                    && $effects[ $i + 1 ]{args}[0]{type} eq "regpair"
                    && $effects[ $i + 1 ]{args}[0]{name} eq "hl" )
                {
                    if (   $effects[ $i + 2 ]{type} eq "inst"
                        && $effects[ $i + 2 ]{opcode} eq "add"
                        && @{ $effects[ $i + 2 ]{args} } == 2
                        && $effects[ $i + 2 ]{args}[0]{type} eq "regpair"
                        && $effects[ $i + 2 ]{args}[0]{name} eq "hl"
                        && $effects[ $i + 2 ]{args}[1]{type} eq "regpair"
                        && $effects[ $i + 2 ]{args}[1]{name} eq "sp" )
                    {
                        if (   $effects[ $i + 3 ]{type} eq "inst"
                            && $effects[ $i + 3 ]{opcode} eq "ex"
                            && @{ $effects[ $i + 3 ]{args} } == 2
                            && $effects[ $i + 3 ]{args}[0]{type} eq "regpair"
                            && $effects[ $i + 3 ]{args}[0]{name} eq "de"
                            && $effects[ $i + 3 ]{args}[1]{type} eq "regpair"
                            && $effects[ $i + 3 ]{args}[1]{name} eq "hl" )
                        {
                            # combine into ld de, hl+imm_arg
                            splice @effects, $i, 4,
                                {
                                type   => 'inst',
                                opcode => 'ld',
                                args   => [
                                    {
                                        type  => 'regpair',
                                        name  => 'de',
                                        alt   => 0,
                                        width => undef
                                    },
                                    {
                                        alt   => 0,
                                        name  => 'sp',
                                        type  => 'regpair',
                                        width => undef
                                    }
                                ],
                                };
                            $repeat = 1;
                        }
                    }
                }
            }
        }

        # ex de, hl: ld de, sp: ex de, hl -> ld hl, sp
        for ( my $i = 0 ; $i <= $#effects - 2 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "ex"
                && @{ $effects[$i]{args} } == 2
                && $effects[$i]{args}[0]{type} eq "regpair"
                && $effects[$i]{args}[0]{name} eq "de"
                && $effects[$i]{args}[1]{type} eq "regpair"
                && $effects[$i]{args}[1]{name} eq "hl" )
            {
                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "ld"
                    && @{ $effects[ $i + 1 ]{args} } == 2
                    && $effects[ $i + 1 ]{args}[0]{type} eq "regpair"
                    && $effects[ $i + 1 ]{args}[0]{name} eq "de"
                    && $effects[ $i + 1 ]{args}[1]{type} eq "regpair"
                    && $effects[ $i + 1 ]{args}[1]{name} eq "sp" )
                {
                    my $disp_arg = $effects[ $i + 1 ]{args}[1]{disp};

                    if (   $effects[ $i + 2 ]{type} eq "inst"
                        && $effects[ $i + 2 ]{opcode} eq "ex"
                        && @{ $effects[ $i + 2 ]{args} } == 2
                        && $effects[ $i + 2 ]{args}[0]{type} eq "regpair"
                        && $effects[ $i + 2 ]{args}[0]{name} eq "de"
                        && $effects[ $i + 2 ]{args}[1]{type} eq "regpair"
                        && $effects[ $i + 2 ]{args}[1]{name} eq "hl" )
                    {
                        # combine into ld hl, sp
                        splice @effects, $i, 3,
                            {
                            type   => 'inst',
                            opcode => 'ld',
                            args   => [
                                {
                                    type  => 'regpair',
                                    name  => 'hl',
                                    alt   => 0,
                                    width => undef
                                },
                                {
                                    alt   => 0,
                                    name  => 'sp',
                                    type  => 'regpair',
                                    width => undef,
                                    ( defined $disp_arg )
                                    ? ( disp => $disp_arg, disp_offset => 0 )
                                    : ()
                                }
                            ],
                            };
                        $repeat = 1;
                    }
                }
            }
        }

        # clr hl: add hl, sp -> ld hl, sp
        for ( my $i = 0 ; $i <= $#effects - 1 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "clr"
                && @{ $effects[$i]{args} } == 1
                && $effects[$i]{args}[0]{type} eq "regpair"
                && $effects[$i]{args}[0]{name} eq "hl" )
            {
                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "add"
                    && @{ $effects[ $i + 1 ]{args} } == 2
                    && $effects[ $i + 1 ]{args}[0]{type} eq "regpair"
                    && $effects[ $i + 1 ]{args}[0]{name} eq "hl"
                    && $effects[ $i + 1 ]{args}[1]{type} eq "regpair"
                    && $effects[ $i + 1 ]{args}[1]{name} eq "sp" )
                {
                    # combine into ld hl, sp
                    splice @effects, $i, 2,
                        {
                        type   => 'inst',
                        opcode => 'ld',
                        args   => [
                            {
                                type  => 'regpair',
                                name  => 'hl',
                                alt   => 0,
                                width => undef
                            },
                            {
                                alt   => 0,
                                name  => 'sp',
                                type  => 'regpair',
                                width => undef
                            }
                        ],
                        };
                    $repeat = 1;
                }
            }
        }

        # ld hl, %d: add hl, sp -> ld hl, sp+%d
        for ( my $i = 0 ; $i <= $#effects - 1 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "ld"
                && @{ $effects[$i]{args} } == 2
                && $effects[$i]{args}[0]{type} eq "regpair"
                && $effects[$i]{args}[0]{name} eq "hl"
                && $effects[$i]{args}[1]{type} eq "imm" )
            {
                my $imm = $effects[$i]{args}[1]{value};

                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "add"
                    && @{ $effects[ $i + 1 ]{args} } == 2
                    && $effects[ $i + 1 ]{args}[0]{type} eq "regpair"
                    && $effects[ $i + 1 ]{args}[0]{name} eq "hl"
                    && $effects[ $i + 1 ]{args}[1]{type} eq "regpair"
                    && $effects[ $i + 1 ]{args}[1]{name} eq "sp" )
                {
                    # combine into ld hl, sp
                    splice @effects, $i, 2,
                        {
                        type   => 'inst',
                        opcode => 'ld',
                        args   => [
                            {
                                type  => 'regpair',
                                name  => 'hl',
                                alt   => 0,
                                width => undef
                            },
                            {
                                alt         => 0,
                                name        => 'sp',
                                type        => 'regpair',
                                width       => undef,
                                disp        => $imm,
                                disp_offset => 0
                            }
                        ],
                        };
                    $repeat = 1;
                }
            }
        }

        # push af: ld a, DEST_H: and a, SRC_H: ld DEST_H, a:
        # ld a, DEST_L: and a, SRC_L: ld DEST_L, a: pop af
        # -> and hl, REG
        for ( my $i = 0 ; $i <= $#effects - 7 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "push"
                && @{ $effects[$i]{args} } == 1
                && $effects[$i]{args}[0]{type} eq "regpair"
                && $effects[$i]{args}[0]{name} eq "af" )
            {
                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "ld"
                    && @{ $effects[ $i + 1 ]{args} } == 2
                    && $effects[ $i + 1 ]{args}[0]{type} eq "reg"
                    && $effects[ $i + 1 ]{args}[0]{name} eq "a"
                    && $effects[ $i + 1 ]{args}[1]{type} eq "reg" )
                {
                    my $dest_h = $effects[ $i + 1 ]{args}[1]{name};

                    if (
                        $effects[ $i + 2 ]{type} eq "inst"
                        && (   $effects[ $i + 2 ]{opcode} eq "and"
                            || $effects[ $i + 2 ]{opcode} eq "or"
                            || $effects[ $i + 2 ]{opcode} eq "xor" )
                        && @{ $effects[ $i + 2 ]{args} } == 2
                        && $effects[ $i + 2 ]{args}[0]{type} eq "reg"
                        && $effects[ $i + 2 ]{args}[0]{name} eq "a"
                        && $effects[ $i + 2 ]{args}[1]{type} eq "reg"
                        )
                    {
                        my $op_opcode = $effects[ $i + 2 ]{opcode};
                        my $src_h     = $effects[ $i + 2 ]{args}[1]{name};

                        if (   $effects[ $i + 3 ]{type} eq "inst"
                            && $effects[ $i + 3 ]{opcode} eq "ld"
                            && @{ $effects[ $i + 3 ]{args} } == 2
                            && $effects[ $i + 3 ]{args}[0]{type} eq "reg"
                            && $effects[ $i + 3 ]{args}[0]{name} eq $dest_h
                            && $effects[ $i + 3 ]{args}[1]{type} eq "reg"
                            && $effects[ $i + 3 ]{args}[1]{name} eq "a" )
                        {
                            if (   $effects[ $i + 4 ]{type} eq "inst"
                                && $effects[ $i + 4 ]{opcode} eq "ld"
                                && @{ $effects[ $i + 4 ]{args} } == 2
                                && $effects[ $i + 4 ]{args}[0]{type} eq "reg"
                                && $effects[ $i + 4 ]{args}[0]{name} eq "a"
                                && $effects[ $i + 4 ]{args}[1]{type} eq "reg" )
                            {
                                my $dest_l = $effects[ $i + 4 ]{args}[1]{name};

                                if (   $effects[ $i + 5 ]{type} eq "inst"
                                    && $effects[ $i + 5 ]{opcode} eq $op_opcode
                                    && @{ $effects[ $i + 5 ]{args} } == 2
                                    && $effects[ $i + 5 ]{args}[0]{type} eq "reg"
                                    && $effects[ $i + 5 ]{args}[0]{name} eq "a"
                                    && $effects[ $i + 5 ]{args}[1]{type} eq "reg" )
                                {
                                    my $src_l = $effects[ $i + 5 ]{args}[1]{name};

                                    if (   $effects[ $i + 6 ]{type} eq "inst"
                                        && $effects[ $i + 6 ]{opcode} eq "ld"
                                        && @{ $effects[ $i + 6 ]{args} } == 2
                                        && $effects[ $i + 6 ]{args}[0]{type} eq "reg"
                                        && $effects[ $i + 6 ]{args}[0]{name} eq $dest_l
                                        && $effects[ $i + 6 ]{args}[1]{type} eq "reg"
                                        && $effects[ $i + 6 ]{args}[1]{name} eq "a" )
                                    {
                                        if (   $effects[ $i + 7 ]{type} eq "inst"
                                            && $effects[ $i + 7 ]{opcode} eq "pop"
                                            && @{ $effects[ $i + 7 ]{args} } == 1
                                            && $effects[ $i + 7 ]{args}[0]{type} eq "regpair"
                                            && $effects[ $i + 7 ]{args}[0]{name} eq "af" )
                                        {
                                            # combine into op dest, src
                                            my $dest = reg_pair( $dest_h, $dest_l );
                                            my $src  = reg_pair( $src_h,  $src_l );
                                            splice @effects, $i, 8,
                                                {
                                                type   => 'inst',
                                                opcode => $op_opcode,
                                                args   => [
                                                    {
                                                        type  => 'regpair',
                                                        name  => $dest,
                                                        alt   => 0,
                                                        width => undef
                                                    },
                                                    {
                                                        type  => 'regpair',
                                                        name  => $src,
                                                        alt   => 0,
                                                        width => undef
                                                    }
                                                ],
                                                };
                                            $repeat = 1;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        # sra REG_H: rr REG_L -> sra REG
        for ( my $i = 0 ; $i <= $#effects - 1 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "sra"
                && @{ $effects[$i]{args} } == 1
                && $effects[$i]{args}[0]{type} eq "reg" )
            {
                my $reg_h = $effects[$i]{args}[0]{name};

                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "rr"
                    && @{ $effects[ $i + 1 ]{args} } == 1
                    && $effects[ $i + 1 ]{args}[0]{type} eq "reg" )
                {
                    my $reg_l = $effects[ $i + 1 ]{args}[0]{name};

                    my $reg_pair = reg_pair( $reg_h, $reg_l );
                    splice @effects, $i, 2,
                        {
                        type   => 'inst',
                        opcode => "sra",
                        args   => [
                            {
                                type  => 'regpair',
                                name  => $reg_pair,
                                alt   => 0,
                                width => undef
                            }
                        ],
                        };
                    $repeat = 1;
                }
            }
        }

        # rl REG_L: rl REG_H -> rl REG
        for ( my $i = 0 ; $i <= $#effects - 1 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "rl"
                && @{ $effects[$i]{args} } == 1
                && $effects[$i]{args}[0]{type} eq "reg" )
            {
                my $reg_l = $effects[$i]{args}[0]{name};

                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "rl"
                    && @{ $effects[ $i + 1 ]{args} } == 1
                    && $effects[ $i + 1 ]{args}[0]{type} eq "reg" )
                {
                    my $reg_h = $effects[ $i + 1 ]{args}[0]{name};

                    my $reg_pair = reg_pair( $reg_h, $reg_l );
                    splice @effects, $i, 2,
                        {
                        type   => 'inst',
                        opcode => "rl",
                        args   => [
                            {
                                type  => 'regpair',
                                name  => $reg_pair,
                                alt   => 0,
                                width => undef
                            }
                        ],
                        };
                    $repeat = 1;
                }
            }
        }

        # rr REG_H: rr REG_L -> rr REG
        for ( my $i = 0 ; $i <= $#effects - 1 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "rr"
                && @{ $effects[$i]{args} } == 1
                && $effects[$i]{args}[0]{type} eq "reg" )
            {
                my $reg_h = $effects[$i]{args}[0]{name};

                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "rr"
                    && @{ $effects[ $i + 1 ]{args} } == 1
                    && $effects[ $i + 1 ]{args}[0]{type} eq "reg" )
                {
                    my $reg_l = $effects[ $i + 1 ]{args}[0]{name};

                    my $reg_pair = reg_pair( $reg_h, $reg_l );
                    splice @effects, $i, 2,
                        {
                        type   => 'inst',
                        opcode => "rr",
                        args   => [
                            {
                                type  => 'regpair',
                                name  => $reg_pair,
                                alt   => 0,
                                width => undef
                            }
                        ],
                        };
                    $repeat = 1;
                }
            }
        }

        # push af: ld a, REG_H: or a, REG_L: jp z, LABEL
        # ld REG, 1
        # LABEL: pop af -> bool REG
        for ( my $i = 0 ; $i <= $#effects - 6 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "push"
                && @{ $effects[$i]{args} } == 1
                && $effects[$i]{args}[0]{type} eq "regpair"
                && $effects[$i]{args}[0]{name} eq "af" )
            {
                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "ld"
                    && @{ $effects[ $i + 1 ]{args} } == 2
                    && $effects[ $i + 1 ]{args}[0]{type} eq "reg"
                    && $effects[ $i + 1 ]{args}[0]{name} eq "a"
                    && $effects[ $i + 1 ]{args}[1]{type} eq "reg" )
                {
                    my $reg_h     = $effects[ $i + 1 ]{args}[1]{name};
                    my $reg_h_alt = $effects[ $i + 1 ]{args}[1]{alt};

                    if (   $effects[ $i + 2 ]{type} eq "inst"
                        && $effects[ $i + 2 ]{opcode} eq "or"
                        && @{ $effects[ $i + 2 ]{args} } == 2
                        && $effects[ $i + 2 ]{args}[0]{type} eq "reg"
                        && $effects[ $i + 2 ]{args}[0]{name} eq "a"
                        && $effects[ $i + 2 ]{args}[1]{type} eq "reg" )
                    {
                        my $reg_l     = $effects[ $i + 2 ]{args}[1]{name};
                        my $reg_l_alt = $effects[ $i + 2 ]{args}[1]{alt};

                        my $reg_pair = reg_pair( $reg_h, $reg_l );

                        if ( $reg_h_alt == $reg_l_alt ) {
                            if (   $effects[ $i + 3 ]{type} eq "inst"
                                && $effects[ $i + 3 ]{opcode} eq "jp"
                                && $effects[ $i + 3 ]{cond} eq "z"
                                && @{ $effects[ $i + 3 ]{args} } == 1
                                && $effects[ $i + 3 ]{args}[0]{type} eq "labelref" )
                            {
                                my $label = $effects[ $i + 3 ]{args}[0]{name};

                                if (   $effects[ $i + 4 ]{type} eq "inst"
                                    && $effects[ $i + 4 ]{opcode} eq "ld"
                                    && @{ $effects[ $i + 4 ]{args} } == 2
                                    && $effects[ $i + 4 ]{args}[0]{type} eq "regpair"
                                    && $effects[ $i + 4 ]{args}[0]{name} eq $reg_pair
                                    && $effects[ $i + 4 ]{args}[1]{type} eq "imm"
                                    && $effects[ $i + 4 ]{args}[1]{value} eq "1" )
                                {
                                    if (   $effects[ $i + 5 ]{type} eq "label"
                                        && $effects[ $i + 5 ]{name} eq $label )
                                    {
                                        if (   $effects[ $i + 6 ]{type} eq "inst"
                                            && $effects[ $i + 6 ]{opcode} eq "pop"
                                            && @{ $effects[ $i + 6 ]{args} } == 1
                                            && $effects[ $i + 6 ]{args}[0]{type} eq "regpair"
                                            && $effects[ $i + 6 ]{args}[0]{name} eq "af" )
                                        {
                                            # combine into bool reg_pair
                                            splice @effects, $i, 7,
                                                {
                                                type   => 'inst',
                                                opcode => "bool",
                                                args   => [
                                                    {
                                                        type  => 'regpair',
                                                        name  => $reg_pair,
                                                        alt   => $reg_h_alt,
                                                        width => undef
                                                    }
                                                ],
                                                };
                                            $repeat = 1;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        # push af: push hl: ld hl, REG: ld a, h: or a, l: jp z, LABEL
        # ld REG, 1
        # LABEL: pop hl: pop af -> bool REG
        for ( my $i = 0 ; $i <= $#effects - 9 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "push"
                && @{ $effects[$i]{args} } == 1
                && $effects[$i]{args}[0]{type} eq "regpair"
                && $effects[$i]{args}[0]{name} eq "af" )
            {
                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "push"
                    && @{ $effects[ $i + 1 ]{args} } == 1
                    && $effects[ $i + 1 ]{args}[0]{type} eq "regpair"
                    && $effects[ $i + 1 ]{args}[0]{name} eq "hl" )
                {
                    if (   $effects[ $i + 2 ]{type} eq "inst"
                        && $effects[ $i + 2 ]{opcode} eq "ld"
                        && @{ $effects[ $i + 2 ]{args} } == 2
                        && $effects[ $i + 2 ]{args}[0]{type} eq "regpair"
                        && $effects[ $i + 2 ]{args}[0]{name} eq "hl"
                        && $effects[ $i + 2 ]{args}[1]{type} eq "regpair" )
                    {
                        my $reg_pair     = $effects[ $i + 2 ]{args}[1]{name};
                        my $reg_pair_alt = $effects[ $i + 2 ]{args}[1]{alt};

                        if (   $effects[ $i + 3 ]{type} eq "inst"
                            && $effects[ $i + 3 ]{opcode} eq "ld"
                            && @{ $effects[ $i + 3 ]{args} } == 2
                            && $effects[ $i + 3 ]{args}[0]{type} eq "reg"
                            && $effects[ $i + 3 ]{args}[0]{name} eq "a"
                            && $effects[ $i + 3 ]{args}[1]{type} eq "reg"
                            && $effects[ $i + 3 ]{args}[1]{name} eq "h" )
                        {
                            if (   $effects[ $i + 4 ]{type} eq "inst"
                                && $effects[ $i + 4 ]{opcode} eq "or"
                                && @{ $effects[ $i + 4 ]{args} } == 2
                                && $effects[ $i + 4 ]{args}[0]{type} eq "reg"
                                && $effects[ $i + 4 ]{args}[0]{name} eq "a"
                                && $effects[ $i + 4 ]{args}[1]{type} eq "reg"
                                && $effects[ $i + 4 ]{args}[1]{name} eq "l" )
                            {
                                if (   $effects[ $i + 5 ]{type} eq "inst"
                                    && $effects[ $i + 5 ]{opcode} eq "jp"
                                    && $effects[ $i + 5 ]{cond} eq "z"
                                    && @{ $effects[ $i + 5 ]{args} } == 1
                                    && $effects[ $i + 5 ]{args}[0]{type} eq "labelref" )
                                {
                                    my $label = $effects[ $i + 5 ]{args}[0]{name};

                                    if (   $effects[ $i + 6 ]{type} eq "inst"
                                        && $effects[ $i + 6 ]{opcode} eq "ld"
                                        && @{ $effects[ $i + 6 ]{args} } == 2
                                        && $effects[ $i + 6 ]{args}[0]{type} eq "regpair"
                                        && $effects[ $i + 6 ]{args}[0]{name} eq $reg_pair
                                        && $effects[ $i + 6 ]{args}[1]{type} eq "imm"
                                        && $effects[ $i + 6 ]{args}[1]{value} eq "1" )
                                    {
                                        if (   $effects[ $i + 7 ]{type} eq "label"
                                            && $effects[ $i + 7 ]{name} eq $label )
                                        {
                                            if (   $effects[ $i + 8 ]{type} eq "inst"
                                                && $effects[ $i + 8 ]{opcode} eq "pop"
                                                && @{ $effects[ $i + 8 ]{args} } == 1
                                                && $effects[ $i + 8 ]{args}[0]{type} eq "regpair"
                                                && $effects[ $i + 8 ]{args}[0]{name} eq "hl" )
                                            {
                                                if (   $effects[ $i + 9 ]{type} eq "inst"
                                                    && $effects[ $i + 9 ]{opcode} eq "pop"
                                                    && @{ $effects[ $i + 9 ]{args} } == 1
                                                    && $effects[ $i + 9 ]{args}[0]{type} eq
                                                    "regpair"
                                                    && $effects[ $i + 9 ]{args}[0]{name} eq "af" )
                                                {
                                                    # combine into bool reg_pair
                                                    splice @effects, $i, 10,
                                                        {
                                                        type   => 'inst',
                                                        opcode => "bool",
                                                        args   => [
                                                            {
                                                                type  => 'regpair',
                                                                name  => $reg_pair,
                                                                alt   => $reg_pair_alt,
                                                                width => undef
                                                            }
                                                        ],
                                                        };
                                                    $repeat = 1;
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        # jp F, LABEL: call|jp %m: LABEL: -> call|jp NF, %m
        for ( my $i = 0 ; $i <= $#effects - 2 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "jp"
                && defined $effects[$i]{cond}
                && @{ $effects[$i]{args} } == 1
                && $effects[$i]{args}[0]{type} eq "labelref" )
            {
                my $cond     = $effects[$i]{cond};
                my $not_cond = invert_flag($cond);
                my $label    = $effects[$i]{args}[0]{name};

                if (
                    $effects[ $i + 1 ]{type} eq "inst"
                    && (   $effects[ $i + 1 ]{opcode} eq "call"
                        || $effects[ $i + 1 ]{opcode} eq "jp" )
                    && !defined $effects[ $i + 1 ]{cond}
                    && @{ $effects[ $i + 1 ]{args} } == 1
                    && $effects[ $i + 1 ]{args}[0]{type} eq "imm"
                    )
                {
                    my $op_opcode = $effects[ $i + 1 ]{opcode};
                    my $imm_arg   = $effects[ $i + 1 ]{args}[0];

                    if (   $effects[ $i + 2 ]{type} eq "label"
                        && $effects[ $i + 2 ]{name} eq $label )
                    {
                        # combine into call not_cond, call_label
                        splice @effects, $i, 3 - 1,    # keep end label
                            {
                            type   => 'inst',
                            opcode => $op_opcode,
                            cond   => $not_cond,
                            args   => [$imm_arg],
                            };
                        $repeat = 1;
                    }
                }
            }
        }

        # jp z, LABEL: call|jp nc, %m: LABEL: -> call|jp gtu, %m
        for ( my $i = 0 ; $i <= $#effects - 2 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "jp"
                && defined $effects[$i]{cond}
                && $effects[$i]{cond} eq "z"
                && @{ $effects[$i]{args} } == 1
                && $effects[$i]{args}[0]{type} eq "labelref" )
            {
                my $label = $effects[$i]{args}[0]{name};

                if (
                    $effects[ $i + 1 ]{type} eq "inst"
                    && (   $effects[ $i + 1 ]{opcode} eq "call"
                        || $effects[ $i + 1 ]{opcode} eq "jp" )
                    && defined $effects[ $i + 1 ]{cond}
                    && $effects[ $i + 1 ]{cond} eq "nc"
                    && @{ $effects[ $i + 1 ]{args} } == 1
                    && $effects[ $i + 1 ]{args}[0]{type} eq "imm"
                    )
                {
                    my $op_opcode = $effects[ $i + 1 ]{opcode};
                    my $imm_arg   = $effects[ $i + 1 ]{args}[0];

                    if (   $effects[ $i + 2 ]{type} eq "label"
                        && $effects[ $i + 2 ]{name} eq $label )
                    {
                        # combine into call gtu, imm_arg
                        splice @effects, $i, 3 - 1,    # keep end label
                            {
                            type   => 'inst',
                            opcode => $op_opcode,
                            cond   => "gtu",
                            args   => [$imm_arg],
                            };
                        $repeat = 1;
                    }
                }
            }
        }

        # jp z, LABEL: ret nc: LABEL: -> ret gtu
        for ( my $i = 0 ; $i <= $#effects - 2 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "jp"
                && defined $effects[$i]{cond}
                && $effects[$i]{cond} eq "z"
                && @{ $effects[$i]{args} } == 1
                && $effects[$i]{args}[0]{type} eq "labelref" )
            {
                my $label = $effects[$i]{args}[0]{name};

                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "ret"
                    && defined $effects[ $i + 1 ]{cond}
                    && $effects[ $i + 1 ]{cond} eq "nc" )
                {
                    if (   $effects[ $i + 2 ]{type} eq "label"
                        && $effects[ $i + 2 ]{name} eq $label )
                    {
                        # combine into ret gtu
                        splice @effects, $i, 3 - 1,    # keep end label
                            {
                            type   => 'inst',
                            opcode => "ret",
                            cond   => "gtu",
                            args   => [],
                            };
                        $repeat = 1;
                    }
                }
            }
        }

        # jp z, TRUE: jp nc, FALSE: TRUE: call %m: FALSE: -> call leu, %m
        for ( my $i = 0 ; $i <= $#effects - 4 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "jp"
                && defined $effects[$i]{cond}
                && $effects[$i]{cond} eq "z"
                && @{ $effects[$i]{args} } == 1
                && $effects[$i]{args}[0]{type} eq "labelref" )
            {
                my $true_label = $effects[$i]{args}[0]{name};

                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "jp"
                    && defined $effects[ $i + 1 ]{cond}
                    && $effects[ $i + 1 ]{cond} eq "nc"
                    && @{ $effects[ $i + 1 ]{args} } == 1
                    && $effects[ $i + 1 ]{args}[0]{type} eq "labelref" )
                {
                    my $false_label = $effects[ $i + 1 ]{args}[0]{name};

                    if (   $effects[ $i + 2 ]{type} eq "label"
                        && $effects[ $i + 2 ]{name} eq $true_label )
                    {
                        if (   $effects[ $i + 3 ]{type} eq "inst"
                            && $effects[ $i + 3 ]{opcode} eq "call"
                            && !defined $effects[ $i + 3 ]{cond}
                            && @{ $effects[ $i + 3 ]{args} } == 1
                            && $effects[ $i + 3 ]{args}[0]{type} eq "imm" )
                        {
                            my $imm_arg = $effects[ $i + 3 ]{args}[0];

                            if (   $effects[ $i + 4 ]{type} eq "label"
                                && $effects[ $i + 4 ]{name} eq $false_label )
                            {
                                # combine into call leu, imm_arg
                                splice @effects, $i, 5 - 1,    # keep end label
                                    {
                                    type   => 'inst',
                                    opcode => "call",
                                    cond   => "leu",
                                    args   => [$imm_arg],
                                    };
                                $repeat = 1;
                            }
                        }
                    }
                }
            }
        }

        # jp z, TRUE: jp c, TRUE: jp FALSE: TRUE: jp %m: FALSE: -> jp leu, %m
        for ( my $i = 0 ; $i <= $#effects - 5 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "jp"
                && defined $effects[$i]{cond}
                && $effects[$i]{cond} eq "z"
                && @{ $effects[$i]{args} } == 1
                && $effects[$i]{args}[0]{type} eq "labelref" )
            {
                my $true_label = $effects[$i]{args}[0]{name};

                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "jp"
                    && defined $effects[ $i + 1 ]{cond}
                    && $effects[ $i + 1 ]{cond} eq "c"
                    && @{ $effects[ $i + 1 ]{args} } == 1
                    && $effects[ $i + 1 ]{args}[0]{type} eq "labelref" )
                {
                    my $true_label2 = $effects[ $i + 1 ]{args}[0]{name};

                    if ( $true_label eq $true_label2 ) {

                        if (   $effects[ $i + 2 ]{type} eq "inst"
                            && $effects[ $i + 2 ]{opcode} eq "jp"
                            && !defined $effects[ $i + 2 ]{cond}
                            && @{ $effects[ $i + 2 ]{args} } == 1
                            && $effects[ $i + 2 ]{args}[0]{type} eq "labelref" )
                        {
                            my $false_label = $effects[ $i + 2 ]{args}[0]{name};

                            if (   $effects[ $i + 3 ]{type} eq "label"
                                && $effects[ $i + 3 ]{name} eq $true_label )
                            {
                                if (   $effects[ $i + 4 ]{type} eq "inst"
                                    && !defined $effects[ $i + 4 ]{cond}
                                    && @{ $effects[ $i + 4 ]{args} } == 1
                                    && $effects[ $i + 4 ]{opcode} eq "jp"
                                    && $effects[ $i + 4 ]{args}[0]{type} eq "imm" )
                                {
                                    my $imm_arg = $effects[ $i + 4 ]{args}[0];

                                    if (   $effects[ $i + 5 ]{type} eq "label"
                                        && $effects[ $i + 5 ]{name} eq $false_label )
                                    {
                                        # combine into call leu, imm_arg
                                        splice @effects, $i, 6 - 1,    # keep end label
                                            {
                                            type   => 'inst',
                                            opcode => "jp",
                                            cond   => "leu",
                                            args   => [$imm_arg],
                                            };
                                        $repeat = 1;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        # jp z, %m: jp c, %m -> jp leu, %m
        for ( my $i = 0 ; $i <= $#effects - 1 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "jp"
                && defined $effects[$i]{cond}
                && $effects[$i]{cond} eq "z"
                && @{ $effects[$i]{args} } == 1
                && $effects[$i]{args}[0]{type} eq "imm" )
            {
                my $imm_arg = $effects[$i]{args}[0];

                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "jp"
                    && defined $effects[ $i + 1 ]{cond}
                    && $effects[ $i + 1 ]{cond} eq "c"
                    && @{ $effects[ $i + 1 ]{args} } == 1
                    && $effects[ $i + 1 ]{args}[0]{type} eq "imm" )
                {
                    my $imm_arg2 = $effects[ $i + 1 ]{args}[0];

                    if ( $imm_arg->{value} eq $imm_arg2->{value} ) {

                        # combine into jp leu, imm_arg
                        splice @effects, $i, 2,
                            {
                            type   => 'inst',
                            opcode => "jp",
                            cond   => "leu",
                            args   => [$imm_arg],
                            };
                        $repeat = 1;
                    }
                }
            }
        }

        # ret z: ret c -> ret leu
        for ( my $i = 0 ; $i <= $#effects - 1 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "ret"
                && defined $effects[$i]{cond}
                && $effects[$i]{cond} eq "z" )
            {
                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "ret"
                    && defined $effects[ $i + 1 ]{cond}
                    && $effects[ $i + 1 ]{cond} eq "c" )
                {
                    # combine into ret leu
                    splice @effects, $i, 2,
                        {
                        type   => 'inst',
                        opcode => "ret",
                        cond   => "leu",
                        args   => [],
                        };
                    $repeat = 1;
                }
            }
        }

        # jp z, TRUE; jp nc, FALSE; TRUE:; ret; FALSE: -> ret leu
        for ( my $i = 0 ; $i <= $#effects - 4 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "jp"
                && defined $effects[$i]{cond}
                && $effects[$i]{cond} eq "z"
                && @{ $effects[$i]{args} } == 1
                && $effects[$i]{args}[0]{type} eq "labelref" )
            {
                my $true_label = $effects[$i]{args}[0]{name};

                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "jp"
                    && defined $effects[ $i + 1 ]{cond}
                    && $effects[ $i + 1 ]{cond} eq "nc"
                    && @{ $effects[ $i + 1 ]{args} } == 1
                    && $effects[ $i + 1 ]{args}[0]{type} eq "labelref" )
                {
                    my $false_label = $effects[ $i + 1 ]{args}[0]{name};

                    if (   $effects[ $i + 2 ]{type} eq "label"
                        && $effects[ $i + 2 ]{name} eq $true_label )
                    {

                        if (   $effects[ $i + 3 ]{type} eq "inst"
                            && $effects[ $i + 3 ]{opcode} eq "ret"
                            && !defined $effects[ $i + 3 ]{cond} )
                        {
                            if (   $effects[ $i + 4 ]{type} eq "label"
                                && $effects[ $i + 4 ]{name} eq $false_label )
                            {
                                # combine into ret leu
                                splice @effects, $i, 5 - 1,    # keep end label
                                    {
                                    type   => 'inst',
                                    opcode => "ret",
                                    cond   => "leu",
                                    args   => [],
                                    };
                                $repeat = 1;
                            }
                        }
                    }
                }
            }
        }

        # jp F, TRUE: jp FALSE: TRUE: call|jp %m: FALSE: -> call|jp F, %m
        for ( my $i = 0 ; $i <= $#effects - 4 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "jp"
                && defined $effects[$i]{cond}
                && @{ $effects[$i]{args} } == 1
                && $effects[$i]{args}[0]{type} eq "labelref" )
            {
                my $true_label = $effects[$i]{args}[0]{name};
                my $cond       = $effects[$i]{cond};

                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "jp"
                    && !defined $effects[ $i + 1 ]{cond}
                    && @{ $effects[ $i + 1 ]{args} } == 1
                    && $effects[ $i + 1 ]{args}[0]{type} eq "labelref" )
                {
                    my $false_label = $effects[ $i + 1 ]{args}[0]{name};

                    if (   $effects[ $i + 2 ]{type} eq "label"
                        && $effects[ $i + 2 ]{name} eq $true_label )
                    {
                        if (
                            $effects[ $i + 3 ]{type} eq "inst"
                            && (   $effects[ $i + 3 ]{opcode} eq "call"
                                || $effects[ $i + 3 ]{opcode} eq "jp" )
                            && !defined $effects[ $i + 3 ]{cond}
                            && @{ $effects[ $i + 3 ]{args} } == 1
                            && $effects[ $i + 3 ]{args}[0]{type} eq "imm"
                            )
                        {
                            my $op_opcode = $effects[ $i + 3 ]{opcode};
                            my $imm_arg   = $effects[ $i + 3 ]{args}[0];

                            if (   $effects[ $i + 4 ]{type} eq "label"
                                && $effects[ $i + 4 ]{name} eq $false_label )
                            {
                                # combine into call cond, imm_arg
                                splice @effects, $i, 5 - 1,    # keep end label
                                    {
                                    type   => 'inst',
                                    opcode => $op_opcode,
                                    cond   => $cond,
                                    args   => [$imm_arg],
                                    };
                                $repeat = 1;
                            }
                        }
                    }
                }
            }
        }

        # jp F, LABEL: ret: LABEL: -> ret NF
        for ( my $i = 0 ; $i <= $#effects - 2 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "jp"
                && defined $effects[$i]{cond}
                && @{ $effects[$i]{args} } == 1
                && $effects[$i]{args}[0]{type} eq "labelref" )
            {
                my $cond     = $effects[$i]{cond};
                my $not_cond = invert_flag($cond);
                my $label    = $effects[$i]{args}[0]{name};

                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "ret"
                    && !defined $effects[ $i + 1 ]{cond} )
                {
                    if (   $effects[ $i + 2 ]{type} eq "label"
                        && $effects[ $i + 2 ]{name} eq $label )
                    {
                        # combine into ret NF
                        splice @effects, $i, 3 - 1,    # keep end label
                            {
                            type   => 'inst',
                            opcode => "ret",
                            cond   => $not_cond,
                            args   => [],
                            };
                        $repeat = 1;
                    }
                }
            }
        }

        # jp F, TRUE; jp FALSE; TRUE:; ret: FALSE: -> ret F
        for ( my $i = 0 ; $i <= $#effects - 4 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "jp"
                && defined $effects[$i]{cond}
                && @{ $effects[$i]{args} } == 1
                && $effects[$i]{args}[0]{type} eq "labelref" )
            {
                my $cond       = $effects[$i]{cond};
                my $true_label = $effects[$i]{args}[0]{name};

                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "jp"
                    && !defined $effects[ $i + 1 ]{cond}
                    && @{ $effects[ $i + 1 ]{args} } == 1
                    && $effects[ $i + 1 ]{args}[0]{type} eq "labelref" )
                {
                    my $false_label = $effects[ $i + 1 ]{args}[0]{name};

                    if (   $effects[ $i + 2 ]{type} eq "label"
                        && $effects[ $i + 2 ]{name} eq $true_label )
                    {

                        if (   $effects[ $i + 3 ]{type} eq "inst"
                            && $effects[ $i + 3 ]{opcode} eq "ret"
                            && !defined $effects[ $i + 3 ]{cond} )
                        {
                            if (   $effects[ $i + 4 ]{type} eq "label"
                                && $effects[ $i + 4 ]{name} eq $false_label )
                            {
                                # combine into ret F
                                splice @effects, $i, 5 - 1,    # keep end label
                                    {
                                    type   => 'inst',
                                    opcode => "ret",
                                    cond   => $cond,
                                    args   => [],
                                    };
                                $repeat = 1;
                            }
                        }
                    }
                }
            }
        }

        # dec b: jp nz, %m -> djnz %m
        for ( my $i = 0 ; $i <= $#effects - 1 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "dec"
                && @{ $effects[$i]{args} } == 1
                && $effects[$i]{args}[0]{type} eq "reg"
                && $effects[$i]{args}[0]{name} eq "b" )
            {
                my $b_reg = $effects[$i]{args}[0];

                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "jp"
                    && defined $effects[ $i + 1 ]{cond}
                    && $effects[ $i + 1 ]{cond} eq "nz"
                    && @{ $effects[ $i + 1 ]{args} } == 1
                    && $effects[ $i + 1 ]{args}[0]{type} eq "imm" )
                {
                    my $imm_arg = $effects[ $i + 1 ]{args}[0];

                    splice @effects, $i, 2,
                        {
                        type   => 'inst',
                        opcode => "djnz",
                        args   => [ $b_reg, $imm_arg ],
                        };
                    $repeat = 1;
                }
            }
        }

        # push REG: ret -> jp (REG)
        for ( my $i = 0 ; $i <= $#effects - 1 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "push"
                && @{ $effects[$i]{args} } == 1
                && $effects[$i]{args}[0]{type} eq "regpair"
                && $effects[$i]{args}[0]{name} ne "af"
                && $effects[$i]{args}[0]{alt} == 0 )
            {
                my $regpair = $effects[$i]{args}[0]{name};

                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "ret"
                    && !defined $effects[ $i + 1 ]{cond}
                    && @{ $effects[ $i + 1 ]{args} } == 0 )
                {
                    splice @effects, $i, 2,
                        {
                        type   => 'inst',
                        opcode => "jp",
                        args   => [
                            {
                                type  => 'mem',
                                base  => $regpair,
                                disp  => undef,
                                post  => 0,
                                space => 'mem',
                                width => undef
                            }
                        ],
                        };
                    $repeat = 1;
                }
            }
        }

        # push hl: ld hl, REG: ld (%m), hl: pop hl -> ld (%m), REG
        for ( my $i = 0 ; $i <= $#effects - 3 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "push"
                && @{ $effects[$i]{args} } == 1
                && $effects[$i]{args}[0]{type} eq "regpair"
                && $effects[$i]{args}[0]{name} eq "hl" )
            {
                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "ld"
                    && @{ $effects[ $i + 1 ]{args} } == 2
                    && $effects[ $i + 1 ]{args}[0]{type} eq "regpair"
                    && $effects[ $i + 1 ]{args}[0]{name} eq "hl"
                    && $effects[ $i + 1 ]{args}[1]{type} eq "regpair" )
                {
                    my $reg_pair = $effects[ $i + 1 ]{args}[1]{name};

                    if (   $effects[ $i + 2 ]{type} eq "inst"
                        && $effects[ $i + 2 ]{opcode} eq "ld"
                        && @{ $effects[ $i + 2 ]{args} } == 2
                        && $effects[ $i + 2 ]{args}[0]{type} eq "mem"
                        && $effects[ $i + 2 ]{args}[0]{space} eq "mem"
                        && defined $effects[ $i + 2 ]{args}[0]{addr}
                        && $effects[ $i + 2 ]{args}[1]{type} eq "regpair"
                        && $effects[ $i + 2 ]{args}[1]{name} eq "hl" )
                    {
                        my $addr_arg = $effects[ $i + 2 ]{args}[0]{addr};

                        if (   $effects[ $i + 3 ]{type} eq "inst"
                            && $effects[ $i + 3 ]{opcode} eq "pop"
                            && @{ $effects[ $i + 3 ]{args} } == 1
                            && $effects[ $i + 3 ]{args}[0]{type} eq "regpair"
                            && $effects[ $i + 3 ]{args}[0]{name} eq "hl" )
                        {
                            splice @effects, $i, 4,
                                {
                                type   => 'inst',
                                opcode => "ld",
                                args   => [
                                    {
                                        type        => 'mem',
                                        space       => 'mem',
                                        addr        => $addr_arg,
                                        base        => undef,
                                        disp        => undef,
                                        disp_offset => 0,
                                        width       => undef
                                    },
                                    {
                                        type  => 'regpair',
                                        name  => $reg_pair,
                                        alt   => 0,
                                        width => undef
                                    }
                                ],
                                };
                            $repeat = 1;
                        }
                    }
                }
            }
        }

        # push af: ld a, REG_L: ld (%m), a: ld a, REG_H: ld (%m+1), a: pop af -> ld (%m), REG
        for ( my $i = 0 ; $i <= $#effects - 5 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "push"
                && @{ $effects[$i]{args} } == 1
                && $effects[$i]{args}[0]{type} eq "regpair"
                && $effects[$i]{args}[0]{name} eq "af" )
            {
                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "ld"
                    && @{ $effects[ $i + 1 ]{args} } == 2
                    && $effects[ $i + 1 ]{args}[0]{type} eq "reg"
                    && $effects[ $i + 1 ]{args}[0]{name} eq "a"
                    && $effects[ $i + 1 ]{args}[1]{type} eq "reg" )
                {
                    my $reg_l = $effects[ $i + 1 ]{args}[1]{name};

                    if (   $effects[ $i + 2 ]{type} eq "inst"
                        && $effects[ $i + 2 ]{opcode} eq "ld"
                        && @{ $effects[ $i + 2 ]{args} } == 2
                        && $effects[ $i + 2 ]{args}[0]{type} eq "mem"
                        && defined $effects[ $i + 2 ]{args}[0]{addr}
                        && ( $effects[ $i + 2 ]{args}[0]{disp_offset} // 0 ) == 0
                        && $effects[ $i + 2 ]{args}[1]{type} eq "reg"
                        && $effects[ $i + 2 ]{args}[1]{name} eq "a" )
                    {
                        my $addr_arg = $effects[ $i + 2 ]{args}[0]{addr};

                        if (   $effects[ $i + 3 ]{type} eq "inst"
                            && $effects[ $i + 3 ]{opcode} eq "ld"
                            && @{ $effects[ $i + 3 ]{args} } == 2
                            && $effects[ $i + 3 ]{args}[0]{type} eq "reg"
                            && $effects[ $i + 3 ]{args}[0]{name} eq "a"
                            && $effects[ $i + 3 ]{args}[1]{type} eq "reg" )
                        {
                            my $reg_h = $effects[ $i + 3 ]{args}[1]{name};
                            if ( $reg_h ne "a" && $reg_l ne "a" ) {
                                my $reg_pair = reg_pair( $reg_h, $reg_l );

                                if (   $effects[ $i + 4 ]{type} eq "inst"
                                    && $effects[ $i + 4 ]{opcode} eq "ld"
                                    && @{ $effects[ $i + 4 ]{args} } == 2
                                    && $effects[ $i + 4 ]{args}[0]{type} eq "mem"
                                    && defined $effects[ $i + 4 ]{args}[0]{addr}
                                    && ( $effects[ $i + 4 ]{args}[0]{disp_offset} // 0 ) == 1
                                    && $effects[ $i + 4 ]{args}[1]{type} eq "reg"
                                    && $effects[ $i + 4 ]{args}[1]{name} eq "a" )
                                {
                                    my $addr_arg2 =
                                        $effects[ $i + 4 ]{args}[0]{addr};

                                    if ( $addr_arg eq $addr_arg2 ) {
                                        if (   $effects[ $i + 5 ]{type} eq "inst"
                                            && $effects[ $i + 5 ]{opcode} eq "pop"
                                            && @{ $effects[ $i + 5 ]{args} } == 1
                                            && $effects[ $i + 5 ]{args}[0]{type} eq "regpair"
                                            && $effects[ $i + 5 ]{args}[0]{name} eq "af" )
                                        {
                                            splice @effects, $i, 6,
                                                {
                                                type   => 'inst',
                                                opcode => "ld",
                                                args   => [
                                                    {
                                                        type        => 'mem',
                                                        space       => 'mem',
                                                        addr        => $addr_arg,
                                                        base        => undef,
                                                        disp        => undef,
                                                        disp_offset => 0,
                                                        width       => undef
                                                    },
                                                    {
                                                        type  => 'regpair',
                                                        name  => $reg_pair,
                                                        alt   => 0,
                                                        width => undef
                                                    }
                                                ],
                                                };
                                            $repeat = 1;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        # ex de, hl: ld (%m), hl: ex de, hl -> ld (%m), de
        for ( my $i = 0 ; $i <= $#effects - 2 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "ex"
                && @{ $effects[$i]{args} } == 2
                && $effects[$i]{args}[0]{type} eq "regpair"
                && $effects[$i]{args}[0]{name} eq "de"
                && $effects[$i]{args}[1]{type} eq "regpair"
                && $effects[$i]{args}[1]{name} eq "hl" )
            {
                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "ld"
                    && @{ $effects[ $i + 1 ]{args} } == 2
                    && $effects[ $i + 1 ]{args}[0]{type} eq "mem"
                    && defined $effects[ $i + 1 ]{args}[0]{addr}
                    && ( $effects[ $i + 1 ]{args}[0]{disp_offset} // 0 ) == 0
                    && $effects[ $i + 1 ]{args}[1]{type} eq "regpair"
                    && $effects[ $i + 1 ]{args}[1]{name} eq "hl" )
                {
                    my $addr_arg = $effects[ $i + 1 ]{args}[0]{addr};

                    if (   $effects[ $i + 2 ]{type} eq "inst"
                        && $effects[ $i + 2 ]{opcode} eq "ex"
                        && @{ $effects[ $i + 2 ]{args} } == 2
                        && $effects[ $i + 2 ]{args}[0]{type} eq "regpair"
                        && $effects[ $i + 2 ]{args}[0]{name} eq "de"
                        && $effects[ $i + 2 ]{args}[1]{type} eq "regpair"
                        && $effects[ $i + 2 ]{args}[1]{name} eq "hl" )
                    {
                        splice @effects, $i, 3,
                            {
                            type   => 'inst',
                            opcode => "ld",
                            args   => [
                                {
                                    type        => 'mem',
                                    space       => 'mem',
                                    addr        => $addr_arg,
                                    base        => undef,
                                    disp        => undef,
                                    disp_offset => 0,
                                    width       => undef
                                },
                                {
                                    type  => 'regpair',
                                    name  => "de",
                                    alt   => 0,
                                    width => undef
                                }
                            ],
                            };
                        $repeat = 1;
                    }
                }
            }
        }

        # ex de, hl: ld hl, (%m): ex de, hl -> ld de, (%m)
        for ( my $i = 0 ; $i <= $#effects - 2 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "ex"
                && @{ $effects[$i]{args} } == 2
                && $effects[$i]{args}[0]{type} eq "regpair"
                && $effects[$i]{args}[0]{name} eq "de"
                && $effects[$i]{args}[1]{type} eq "regpair"
                && $effects[$i]{args}[1]{name} eq "hl" )
            {
                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "ld"
                    && @{ $effects[ $i + 1 ]{args} } == 2
                    && $effects[ $i + 1 ]{args}[0]{type} eq "regpair"
                    && $effects[ $i + 1 ]{args}[0]{name} eq "hl"
                    && $effects[ $i + 1 ]{args}[1]{type} eq "mem"
                    && defined $effects[ $i + 1 ]{args}[1]{addr}
                    && ( $effects[ $i + 1 ]{args}[1]{disp_offset} // 0 ) == 0 )
                {
                    my $addr_arg = $effects[ $i + 1 ]{args}[1]{addr};

                    if (   $effects[ $i + 2 ]{type} eq "inst"
                        && $effects[ $i + 2 ]{opcode} eq "ex"
                        && @{ $effects[ $i + 2 ]{args} } == 2
                        && $effects[ $i + 2 ]{args}[0]{type} eq "regpair"
                        && $effects[ $i + 2 ]{args}[0]{name} eq "de"
                        && $effects[ $i + 2 ]{args}[1]{type} eq "regpair"
                        && $effects[ $i + 2 ]{args}[1]{name} eq "hl" )
                    {
                        splice @effects, $i, 3,
                            {
                            type   => 'inst',
                            opcode => "ld",
                            args   => [
                                {
                                    type  => 'regpair',
                                    name  => "de",
                                    alt   => 0,
                                    width => undef
                                },
                                {
                                    type        => 'mem',
                                    space       => 'mem',
                                    addr        => $addr_arg,
                                    base        => undef,
                                    disp        => undef,
                                    disp_offset => 0,
                                    width       => undef
                                }
                            ],
                            };
                        $repeat = 1;
                    }
                }
            }
        }

        # push hl: ld hl, 2: add hl, sp: ld (%m), hl: pop hl -> ld (%m), sp
        for ( my $i = 0 ; $i <= $#effects - 4 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "push"
                && @{ $effects[$i]{args} } == 1
                && $effects[$i]{args}[0]{type} eq "regpair"
                && $effects[$i]{args}[0]{name} eq "hl" )
            {
                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "ld"
                    && @{ $effects[ $i + 1 ]{args} } == 2
                    && $effects[ $i + 1 ]{args}[0]{type} eq "regpair"
                    && $effects[ $i + 1 ]{args}[0]{name} eq "hl"
                    && $effects[ $i + 1 ]{args}[1]{type} eq "imm"
                    && defined $effects[ $i + 1 ]{args}[1]{value}
                    && $effects[ $i + 1 ]{args}[1]{value} == 2 )
                {
                    if (   $effects[ $i + 2 ]{type} eq "inst"
                        && $effects[ $i + 2 ]{opcode} eq "add"
                        && @{ $effects[ $i + 2 ]{args} } == 2
                        && $effects[ $i + 2 ]{args}[0]{type} eq "regpair"
                        && $effects[ $i + 2 ]{args}[0]{name} eq "hl"
                        && $effects[ $i + 2 ]{args}[1]{type} eq "regpair"
                        && $effects[ $i + 2 ]{args}[1]{name} eq "sp" )
                    {
                        if (   $effects[ $i + 3 ]{type} eq "inst"
                            && $effects[ $i + 3 ]{opcode} eq "ld"
                            && @{ $effects[ $i + 3 ]{args} } == 2
                            && $effects[ $i + 3 ]{args}[0]{type} eq "mem"
                            && defined $effects[ $i + 3 ]{args}[0]{addr}
                            && !defined $effects[ $i + 3 ]{args}[0]{disp}
                            && $effects[ $i + 3 ]{args}[1]{type} eq "regpair"
                            && $effects[ $i + 3 ]{args}[1]{name} eq "hl" )
                        {
                            my $mem_arg = $effects[ $i + 3 ]{args}[0];

                            if (   $effects[ $i + 4 ]{type} eq "inst"
                                && $effects[ $i + 4 ]{opcode} eq "pop"
                                && @{ $effects[ $i + 4 ]{args} } == 1
                                && $effects[ $i + 4 ]{args}[0]{type} eq "regpair"
                                && $effects[ $i + 4 ]{args}[0]{name} eq "hl" )
                            {
                                splice @effects, $i, 5,
                                    {
                                    type   => 'inst',
                                    opcode => "ld",
                                    args   => [
                                        $mem_arg,
                                        {
                                            type  => 'regpair',
                                            name  => "sp",
                                            alt   => 0,
                                            width => undef
                                        }
                                    ],
                                    };
                                $repeat = 1;
                            }
                        }
                    }
                }
            }
        }

        # ex de, hl: ld (hl), %n: ex de, hl -> ld (de), %n
        for ( my $i = 0 ; $i <= $#effects - 2 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "ex"
                && @{ $effects[$i]{args} } == 2
                && $effects[$i]{args}[0]{type} eq "regpair"
                && $effects[$i]{args}[0]{name} eq "de"
                && $effects[$i]{args}[1]{type} eq "regpair"
                && $effects[$i]{args}[1]{name} eq "hl" )
            {
                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "ld"
                    && @{ $effects[ $i + 1 ]{args} } == 2
                    && $effects[ $i + 1 ]{args}[0]{type} eq "mem"
                    && defined $effects[ $i + 1 ]{args}[0]{base}
                    && $effects[ $i + 1 ]{args}[0]{base} eq "hl"
                    && $effects[ $i + 1 ]{args}[1]{type} eq "imm" )
                {
                    my $imm_arg   = $effects[ $i + 1 ]{args}[1];
                    my $imm_width = $imm_arg->{width};

                    if (   $effects[ $i + 2 ]{type} eq "inst"
                        && $effects[ $i + 2 ]{opcode} eq "ex"
                        && @{ $effects[ $i + 2 ]{args} } == 2
                        && $effects[ $i + 2 ]{args}[0]{type} eq "regpair"
                        && $effects[ $i + 2 ]{args}[0]{name} eq "de"
                        && $effects[ $i + 2 ]{args}[1]{type} eq "regpair"
                        && $effects[ $i + 2 ]{args}[1]{name} eq "hl" )
                    {
                        splice @effects, $i, 3,
                            {
                            type   => 'inst',
                            opcode => "ld",
                            args   => [
                                {
                                    type  => 'mem',
                                    space => 'mem',
                                    base  => "de",
                                    disp  => undef,
                                    post  => 0,
                                    width => $imm_width
                                },
                                $imm_arg
                            ],
                            };
                        $repeat = 1;
                    }
                }
            }
        }

        # ex de, hl: ld (hl), REG: ex de, hl -> ld (de), REG
        for ( my $i = 0 ; $i <= $#effects - 2 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "ex"
                && @{ $effects[$i]{args} } == 2
                && $effects[$i]{args}[0]{type} eq "regpair"
                && $effects[$i]{args}[0]{name} eq "de"
                && $effects[$i]{args}[1]{type} eq "regpair"
                && $effects[$i]{args}[1]{name} eq "hl" )
            {
                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "ld"
                    && @{ $effects[ $i + 1 ]{args} } == 2
                    && $effects[ $i + 1 ]{args}[0]{type} eq "mem"
                    && defined $effects[ $i + 1 ]{args}[0]{base}
                    && $effects[ $i + 1 ]{args}[0]{base} eq "hl"
                    && $effects[ $i + 1 ]{args}[1]{type} eq "reg" )
                {
                    my $mem_width = $effects[ $i + 1 ]{args}[0]{width};
                    my $reg_arg   = $effects[ $i + 1 ]{args}[1]{name};
                    $reg_arg =~ tr/dehl/hlde/;    # swap de and hl

                    if (   $effects[ $i + 2 ]{type} eq "inst"
                        && $effects[ $i + 2 ]{opcode} eq "ex"
                        && @{ $effects[ $i + 2 ]{args} } == 2
                        && $effects[ $i + 2 ]{args}[0]{type} eq "regpair"
                        && $effects[ $i + 2 ]{args}[0]{name} eq "de"
                        && $effects[ $i + 2 ]{args}[1]{type} eq "regpair"
                        && $effects[ $i + 2 ]{args}[1]{name} eq "hl" )
                    {
                        splice @effects, $i, 3,
                            {
                            type   => 'inst',
                            opcode => "ld",
                            args   => [
                                {
                                    type  => 'mem',
                                    space => 'mem',
                                    base  => "de",
                                    disp  => undef,
                                    post  => 0,
                                    width => $mem_width
                                },
                                {
                                    type  => 'reg',
                                    name  => $reg_arg,
                                    alt   => 0,
                                    width => undef
                                }
                            ],
                            };
                        $repeat = 1;
                    }
                }
            }
        }

        # ex de, hl: ld REG, (hl): ex de, hl -> ld REG, (de)
        for ( my $i = 0 ; $i <= $#effects - 2 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "ex"
                && @{ $effects[$i]{args} } == 2
                && $effects[$i]{args}[0]{type} eq "regpair"
                && $effects[$i]{args}[0]{name} eq "de"
                && $effects[$i]{args}[1]{type} eq "regpair"
                && $effects[$i]{args}[1]{name} eq "hl" )
            {
                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "ld"
                    && @{ $effects[ $i + 1 ]{args} } == 2
                    && $effects[ $i + 1 ]{args}[0]{type} eq "reg"
                    && defined $effects[ $i + 1 ]{args}[0]{name}
                    && $effects[ $i + 1 ]{args}[1]{type} eq "mem"
                    && defined $effects[ $i + 1 ]{args}[1]{base}
                    && $effects[ $i + 1 ]{args}[1]{base} eq "hl" )
                {
                    my $reg_arg = $effects[ $i + 1 ]{args}[0]{name};
                    $reg_arg =~ tr/dehl/hlde/;    # swap de and hl
                    my $mem_width = $effects[ $i + 1 ]{args}[1]{width};

                    if (   $effects[ $i + 2 ]{type} eq "inst"
                        && $effects[ $i + 2 ]{opcode} eq "ex"
                        && @{ $effects[ $i + 2 ]{args} } == 2
                        && $effects[ $i + 2 ]{args}[0]{type} eq "regpair"
                        && $effects[ $i + 2 ]{args}[0]{name} eq "de"
                        && $effects[ $i + 2 ]{args}[1]{type} eq "regpair"
                        && $effects[ $i + 2 ]{args}[1]{name} eq "hl" )
                    {
                        splice @effects, $i, 3, {
                            type   => 'inst',
                            opcode => "ld",
                            args   => [
                                {
                                    type  => 'reg',
                                    name  => $reg_arg,
                                    alt   => 0,
                                    width => undef
                                },
                                {
                                    type  => 'mem',
                                    space => 'mem',
                                    base  => "de",
                                    disp  => undef,
                                    post  => 0,
                                    width => $mem_width
                                },

                            ],
                        };
                        $repeat = 1;
                    }
                }
            }
        }

        # ex de, hl: ld (hl), e: inc hl: ld (hl), d: dec hl: ex de, hl -> ld (de), hl
        for ( my $i = 0 ; $i <= $#effects - 5 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "ex"
                && @{ $effects[$i]{args} } == 2
                && $effects[$i]{args}[0]{type} eq "regpair"
                && $effects[$i]{args}[0]{name} eq "de"
                && $effects[$i]{args}[1]{type} eq "regpair"
                && $effects[$i]{args}[1]{name} eq "hl" )
            {
                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "ld"
                    && @{ $effects[ $i + 1 ]{args} } == 2
                    && $effects[ $i + 1 ]{args}[0]{type} eq "mem"
                    && defined $effects[ $i + 1 ]{args}[0]{base}
                    && $effects[ $i + 1 ]{args}[0]{base} eq "hl"
                    && $effects[ $i + 1 ]{args}[1]{type} eq "reg"
                    && $effects[ $i + 1 ]{args}[1]{name} eq "e" )
                {
                    if (   $effects[ $i + 2 ]{type} eq "inst"
                        && $effects[ $i + 2 ]{opcode} eq "inc"
                        && @{ $effects[ $i + 2 ]{args} } == 1
                        && $effects[ $i + 2 ]{args}[0]{type} eq "regpair"
                        && $effects[ $i + 2 ]{args}[0]{name} eq "hl" )
                    {
                        if (   $effects[ $i + 3 ]{type} eq "inst"
                            && $effects[ $i + 3 ]{opcode} eq "ld"
                            && @{ $effects[ $i + 3 ]{args} } == 2
                            && $effects[ $i + 3 ]{args}[0]{type} eq "mem"
                            && defined $effects[ $i + 3 ]{args}[0]{base}
                            && $effects[ $i + 3 ]{args}[0]{base} eq "hl"
                            && $effects[ $i + 3 ]{args}[1]{type} eq "reg"
                            && $effects[ $i + 3 ]{args}[1]{name} eq "d" )
                        {
                            if (   $effects[ $i + 4 ]{type} eq "inst"
                                && $effects[ $i + 4 ]{opcode} eq "dec"
                                && @{ $effects[ $i + 4 ]{args} } == 1
                                && $effects[ $i + 4 ]{args}[0]{type} eq "regpair"
                                && $effects[ $i + 4 ]{args}[0]{name} eq "hl" )
                            {
                                if (   $effects[ $i + 5 ]{type} eq "inst"
                                    && $effects[ $i + 5 ]{opcode} eq "ex"
                                    && @{ $effects[ $i + 5 ]{args} } == 2
                                    && $effects[ $i + 5 ]{args}[0]{type} eq "regpair"
                                    && $effects[ $i + 5 ]{args}[0]{name} eq "de"
                                    && $effects[ $i + 5 ]{args}[1]{type} eq "regpair"
                                    && $effects[ $i + 5 ]{args}[1]{name} eq "hl" )
                                {
                                    splice @effects, $i, 6,
                                        {
                                        type   => 'inst',
                                        opcode => "ld",
                                        args   => [
                                            {
                                                type  => 'mem',
                                                space => 'mem',
                                                base  => "de",
                                                disp  => undef,
                                                post  => 0,
                                                width => undef
                                            },
                                            {
                                                type  => 'regpair',
                                                name  => "hl",
                                                alt   => 0,
                                                width => undef
                                            }
                                        ],
                                        };
                                    $repeat = 1;
                                }
                            }
                        }
                    }
                }
            }
        }

        # ex de, hl: ld e, (hl): inc hl: ld d, (hl): dec hl: ex de, hl -> ld hl, (de)
        for ( my $i = 0 ; $i <= $#effects - 5 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "ex"
                && @{ $effects[$i]{args} } == 2
                && $effects[$i]{args}[0]{type} eq "regpair"
                && $effects[$i]{args}[0]{name} eq "de"
                && $effects[$i]{args}[1]{type} eq "regpair"
                && $effects[$i]{args}[1]{name} eq "hl" )
            {
                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "ld"
                    && @{ $effects[ $i + 1 ]{args} } == 2
                    && $effects[ $i + 1 ]{args}[0]{type} eq "reg"
                    && $effects[ $i + 1 ]{args}[0]{name} eq "e"
                    && $effects[ $i + 1 ]{args}[1]{type} eq "mem"
                    && defined $effects[ $i + 1 ]{args}[1]{base}
                    && $effects[ $i + 1 ]{args}[1]{base} eq "hl" )
                {
                    if (   $effects[ $i + 2 ]{type} eq "inst"
                        && $effects[ $i + 2 ]{opcode} eq "inc"
                        && @{ $effects[ $i + 2 ]{args} } == 1
                        && $effects[ $i + 2 ]{args}[0]{type} eq "regpair"
                        && $effects[ $i + 2 ]{args}[0]{name} eq "hl" )
                    {
                        if (   $effects[ $i + 3 ]{type} eq "inst"
                            && $effects[ $i + 3 ]{opcode} eq "ld"
                            && @{ $effects[ $i + 3 ]{args} } == 2
                            && $effects[ $i + 3 ]{args}[0]{type} eq "reg"
                            && $effects[ $i + 3 ]{args}[0]{name} eq "d"
                            && $effects[ $i + 3 ]{args}[1]{type} eq "mem"
                            && defined $effects[ $i + 3 ]{args}[1]{base}
                            && $effects[ $i + 3 ]{args}[1]{base} eq "hl" )
                        {
                            if (   $effects[ $i + 4 ]{type} eq "inst"
                                && $effects[ $i + 4 ]{opcode} eq "dec"
                                && @{ $effects[ $i + 4 ]{args} } == 1
                                && $effects[ $i + 4 ]{args}[0]{type} eq "regpair"
                                && $effects[ $i + 4 ]{args}[0]{name} eq "hl" )
                            {
                                if (   $effects[ $i + 5 ]{type} eq "inst"
                                    && $effects[ $i + 5 ]{opcode} eq "ex"
                                    && @{ $effects[ $i + 5 ]{args} } == 2
                                    && $effects[ $i + 5 ]{args}[0]{type} eq "regpair"
                                    && $effects[ $i + 5 ]{args}[0]{name} eq "de"
                                    && $effects[ $i + 5 ]{args}[1]{type} eq "regpair"
                                    && $effects[ $i + 5 ]{args}[1]{name} eq "hl" )
                                {
                                    splice @effects, $i, 6,
                                        {
                                        type   => 'inst',
                                        opcode => "ld",
                                        args   => [
                                            {
                                                type  => 'regpair',
                                                name  => "hl",
                                                alt   => 0,
                                                width => undef
                                            },
                                            {
                                                type  => 'mem',
                                                space => 'mem',
                                                base  => "de",
                                                disp  => undef,
                                                post  => 0,
                                                width => undef
                                            }
                                        ],
                                        };
                                    $repeat = 1;
                                }
                            }
                        }
                    }
                }
            }
        }

        # ld (hl), REG_L: inc hl: ld (hl), REG_H: dec hl -> ld (hl), REG
        for ( my $i = 0 ; $i <= $#effects - 3 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "ld"
                && @{ $effects[$i]{args} } == 2
                && $effects[$i]{args}[0]{type} eq "mem"
                && defined $effects[$i]{args}[0]{base}
                && $effects[$i]{args}[0]{base} eq "hl"
                && $effects[$i]{args}[1]{type} eq "reg" )
            {
                my $reg_l = $effects[$i]{args}[1]{name};

                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "inc"
                    && @{ $effects[ $i + 1 ]{args} } == 1
                    && $effects[ $i + 1 ]{args}[0]{type} eq "regpair"
                    && $effects[ $i + 1 ]{args}[0]{name} eq "hl" )
                {
                    if (   $effects[ $i + 2 ]{type} eq "inst"
                        && $effects[ $i + 2 ]{opcode} eq "ld"
                        && @{ $effects[ $i + 2 ]{args} } == 2
                        && $effects[ $i + 2 ]{args}[0]{type} eq "mem"
                        && defined $effects[ $i + 2 ]{args}[0]{base}
                        && $effects[ $i + 2 ]{args}[0]{base} eq "hl"
                        && $effects[ $i + 2 ]{args}[1]{type} eq "reg" )
                    {
                        my $reg_h = $effects[ $i + 2 ]{args}[1]{name};
                        if ( $reg_h ne "a" && $reg_l ne "a" ) {
                            my $reg_pair = reg_pair( $reg_h, $reg_l );

                            if (   $effects[ $i + 3 ]{type} eq "inst"
                                && $effects[ $i + 3 ]{opcode} eq "dec"
                                && @{ $effects[ $i + 3 ]{args} } == 1
                                && $effects[ $i + 3 ]{args}[0]{type} eq "regpair"
                                && $effects[ $i + 3 ]{args}[0]{name} eq "hl" )
                            {
                                splice @effects, $i, 4,
                                    {
                                    type   => 'inst',
                                    opcode => "ld",
                                    args   => [
                                        {
                                            type  => 'mem',
                                            space => 'mem',
                                            base  => "hl",
                                            disp  => undef,
                                            post  => 0,
                                            width => undef
                                        },
                                        {
                                            type  => 'regpair',
                                            name  => $reg_pair,
                                            alt   => 0,
                                            width => undef
                                        }
                                    ],
                                    };
                                $repeat = 1;
                            }
                        }
                    }
                }
            }
        }

        # ld (hl), REG_L: inc hl: ld (hl), REG_H: inc hl -> ld (hl+), REG
        for ( my $i = 0 ; $i <= $#effects - 3 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "ld"
                && @{ $effects[$i]{args} } == 2
                && $effects[$i]{args}[0]{type} eq "mem"
                && defined $effects[$i]{args}[0]{base}
                && $effects[$i]{args}[0]{base} eq "hl"
                && $effects[$i]{args}[1]{type} eq "reg" )
            {
                my $reg_l = $effects[$i]{args}[1]{name};

                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "inc"
                    && @{ $effects[ $i + 1 ]{args} } == 1
                    && $effects[ $i + 1 ]{args}[0]{type} eq "regpair"
                    && $effects[ $i + 1 ]{args}[0]{name} eq "hl" )
                {
                    if (   $effects[ $i + 2 ]{type} eq "inst"
                        && $effects[ $i + 2 ]{opcode} eq "ld"
                        && @{ $effects[ $i + 2 ]{args} } == 2
                        && $effects[ $i + 2 ]{args}[0]{type} eq "mem"
                        && defined $effects[ $i + 2 ]{args}[0]{base}
                        && $effects[ $i + 2 ]{args}[0]{base} eq "hl"
                        && $effects[ $i + 2 ]{args}[1]{type} eq "reg" )
                    {
                        my $reg_h = $effects[ $i + 2 ]{args}[1]{name};
                        if ( $reg_h ne "a" && $reg_l ne "a" ) {
                            my $reg_pair = reg_pair( $reg_h, $reg_l );

                            if (   $effects[ $i + 3 ]{type} eq "inst"
                                && $effects[ $i + 3 ]{opcode} eq "inc"
                                && @{ $effects[ $i + 3 ]{args} } == 1
                                && $effects[ $i + 3 ]{args}[0]{type} eq "regpair"
                                && $effects[ $i + 3 ]{args}[0]{name} eq "hl" )
                            {
                                splice @effects, $i, 4,
                                    {
                                    type   => 'inst',
                                    opcode => "ld",
                                    args   => [
                                        {
                                            type  => 'mem',
                                            space => 'mem',
                                            base  => "hl",
                                            disp  => undef,
                                            post  => 0,
                                            width => undef
                                        },
                                        {
                                            type  => 'regpair',
                                            name  => $reg_pair,
                                            alt   => 0,
                                            width => undef
                                        }
                                    ],
                                    },
                                    {
                                    type   => 'inst',
                                    opcode => "inc",
                                    args   => [
                                        {
                                            type  => 'regpair',
                                            name  => "hl",
                                            alt   => 0,
                                            width => undef
                                        }
                                    ]
                                    },
                                    {
                                    type   => 'inst',
                                    opcode => "inc",
                                    args   => [
                                        {
                                            type  => 'regpair',
                                            name  => "hl",
                                            alt   => 0,
                                            width => undef
                                        }
                                    ]
                                    };
                                $repeat = 1;
                            }
                        }
                    }
                }
            }
        }

        # ld REG_L, (hl): inc hl: ld REG_H, (hl): dec hl -> ld REG, (hl)
        for ( my $i = 0 ; $i <= $#effects - 3 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "ld"
                && @{ $effects[$i]{args} } == 2
                && $effects[$i]{args}[0]{type} eq "reg"
                && $effects[$i]{args}[1]{type} eq "mem"
                && defined $effects[$i]{args}[1]{base}
                && $effects[$i]{args}[1]{base} eq "hl" )
            {
                my $reg_l = $effects[$i]{args}[0]{name};

                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "inc"
                    && @{ $effects[ $i + 1 ]{args} } == 1
                    && $effects[ $i + 1 ]{args}[0]{type} eq "regpair"
                    && $effects[ $i + 1 ]{args}[0]{name} eq "hl" )
                {
                    if (   $effects[ $i + 2 ]{type} eq "inst"
                        && $effects[ $i + 2 ]{opcode} eq "ld"
                        && @{ $effects[ $i + 2 ]{args} } == 2
                        && $effects[ $i + 2 ]{args}[0]{type} eq "reg"
                        && $effects[ $i + 2 ]{args}[1]{type} eq "mem"
                        && defined $effects[ $i + 2 ]{args}[1]{base}
                        && $effects[ $i + 2 ]{args}[1]{base} eq "hl" )
                    {
                        my $reg_h = $effects[ $i + 2 ]{args}[0]{name};
                        if ( $reg_h ne "a" && $reg_l ne "a" ) {
                            my $reg_pair = reg_pair( $reg_h, $reg_l );

                            if (   $effects[ $i + 3 ]{type} eq "inst"
                                && $effects[ $i + 3 ]{opcode} eq "dec"
                                && @{ $effects[ $i + 3 ]{args} } == 1
                                && $effects[ $i + 3 ]{args}[0]{type} eq "regpair"
                                && $effects[ $i + 3 ]{args}[0]{name} eq "hl" )
                            {
                                splice @effects, $i, 4,
                                    {
                                    type   => 'inst',
                                    opcode => "ld",
                                    args   => [
                                        {
                                            type  => 'regpair',
                                            name  => $reg_pair,
                                            alt   => 0,
                                            width => undef
                                        },
                                        {
                                            type  => 'mem',
                                            space => 'mem',
                                            base  => "hl",
                                            disp  => undef,
                                            post  => 0,
                                            width => undef
                                        }
                                    ],
                                    };
                                $repeat = 1;
                            }
                        }
                    }
                }
            }
        }

        # ld REG_L, (hl): inc hl: ld REG_H, (hl): inc hl -> ld REG, (hl+)
        for ( my $i = 0 ; $i <= $#effects - 3 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "ld"
                && @{ $effects[$i]{args} } == 2
                && $effects[$i]{args}[0]{type} eq "reg"
                && $effects[$i]{args}[1]{type} eq "mem"
                && defined $effects[$i]{args}[1]{base}
                && $effects[$i]{args}[1]{base} eq "hl" )
            {
                my $reg_l = $effects[$i]{args}[0]{name};

                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "inc"
                    && @{ $effects[ $i + 1 ]{args} } == 1
                    && $effects[ $i + 1 ]{args}[0]{type} eq "regpair"
                    && $effects[ $i + 1 ]{args}[0]{name} eq "hl" )
                {
                    if (   $effects[ $i + 2 ]{type} eq "inst"
                        && $effects[ $i + 2 ]{opcode} eq "ld"
                        && @{ $effects[ $i + 2 ]{args} } == 2
                        && $effects[ $i + 2 ]{args}[0]{type} eq "reg"
                        && $effects[ $i + 2 ]{args}[1]{type} eq "mem"
                        && defined $effects[ $i + 2 ]{args}[1]{base}
                        && $effects[ $i + 2 ]{args}[1]{base} eq "hl" )
                    {
                        my $reg_h = $effects[ $i + 2 ]{args}[0]{name};
                        if ( $reg_h ne "a" && $reg_l ne "a" ) {
                            my $reg_pair = reg_pair( $reg_h, $reg_l );

                            if (   $effects[ $i + 3 ]{type} eq "inst"
                                && $effects[ $i + 3 ]{opcode} eq "inc"
                                && @{ $effects[ $i + 3 ]{args} } == 1
                                && $effects[ $i + 3 ]{args}[0]{type} eq "regpair"
                                && $effects[ $i + 3 ]{args}[0]{name} eq "hl" )
                            {
                                splice @effects, $i, 4,
                                    {
                                    type   => 'inst',
                                    opcode => "ld",
                                    args   => [
                                        {
                                            type  => 'regpair',
                                            name  => $reg_pair,
                                            alt   => 0,
                                            width => undef
                                        },
                                        {
                                            type  => 'mem',
                                            space => 'mem',
                                            base  => "hl",
                                            disp  => undef,
                                            post  => 0,
                                            width => undef
                                        }
                                    ],
                                    },
                                    {
                                    type   => 'inst',
                                    opcode => "inc",
                                    args   => [
                                        {
                                            type  => 'regpair',
                                            name  => "hl",
                                            alt   => 0,
                                            width => undef
                                        }
                                    ]
                                    },
                                    {
                                    type   => 'inst',
                                    opcode => "inc",
                                    args   => [
                                        {
                                            type  => 'regpair',
                                            name  => "hl",
                                            alt   => 0,
                                            width => undef
                                        }
                                    ]
                                    };
                                $repeat = 1;
                            }
                        }
                    }
                }
            }
        }

        # push af;ld a, h;ld (hl), l;inc hl;ld (hl), a;pop af;dec hl -> ld (hl), hl
        for ( my $i = 0 ; $i <= $#effects - 6 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "push"
                && @{ $effects[$i]{args} } == 1
                && $effects[$i]{args}[0]{type} eq "regpair"
                && $effects[$i]{args}[0]{name} eq "af" )
            {
                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "ld"
                    && @{ $effects[ $i + 1 ]{args} } == 2
                    && $effects[ $i + 1 ]{args}[0]{type} eq "reg"
                    && $effects[ $i + 1 ]{args}[0]{name} eq "a"
                    && $effects[ $i + 1 ]{args}[1]{type} eq "reg"
                    && $effects[ $i + 1 ]{args}[1]{name} eq "h" )
                {
                    if (   $effects[ $i + 2 ]{type} eq "inst"
                        && $effects[ $i + 2 ]{opcode} eq "ld"
                        && @{ $effects[ $i + 2 ]{args} } == 2
                        && $effects[ $i + 2 ]{args}[0]{type} eq "mem"
                        && defined $effects[ $i + 2 ]{args}[0]{base}
                        && $effects[ $i + 2 ]{args}[0]{base} eq "hl"
                        && $effects[ $i + 2 ]{args}[1]{type} eq "reg"
                        && $effects[ $i + 2 ]{args}[1]{name} eq "l" )
                    {
                        if (   $effects[ $i + 3 ]{type} eq "inst"
                            && $effects[ $i + 3 ]{opcode} eq "inc"
                            && @{ $effects[ $i + 3 ]{args} } == 1
                            && $effects[ $i + 3 ]{args}[0]{type} eq "regpair"
                            && $effects[ $i + 3 ]{args}[0]{name} eq "hl" )
                        {
                            if (   $effects[ $i + 4 ]{type} eq "inst"
                                && $effects[ $i + 4 ]{opcode} eq "ld"
                                && @{ $effects[ $i + 4 ]{args} } == 2
                                && $effects[ $i + 4 ]{args}[0]{type} eq "mem"
                                && defined $effects[ $i + 4 ]{args}[0]{base}
                                && $effects[ $i + 4 ]{args}[0]{base} eq "hl"
                                && $effects[ $i + 4 ]{args}[1]{type} eq "reg"
                                && $effects[ $i + 4 ]{args}[1]{name} eq "a" )
                            {
                                if (   $effects[ $i + 5 ]{type} eq "inst"
                                    && $effects[ $i + 5 ]{opcode} eq "pop"
                                    && @{ $effects[ $i + 5 ]{args} } == 1
                                    && $effects[ $i + 5 ]{args}[0]{type} eq "regpair"
                                    && $effects[ $i + 5 ]{args}[0]{name} eq "af" )
                                {
                                    if (   $effects[ $i + 6 ]{type} eq "inst"
                                        && $effects[ $i + 6 ]{opcode} eq "dec"
                                        && @{ $effects[ $i + 6 ]{args} } == 1
                                        && $effects[ $i + 6 ]{args}[0]{type} eq "regpair"
                                        && $effects[ $i + 6 ]{args}[0]{name} eq "hl" )
                                    {
                                        splice @effects, $i, 7,
                                            {
                                            type   => 'inst',
                                            opcode => "ld",
                                            args   => [
                                                {
                                                    type  => 'mem',
                                                    space => 'mem',
                                                    base  => "hl",
                                                    disp  => undef,
                                                    post  => 0,
                                                    width => undef
                                                },
                                                {
                                                    type  => 'regpair',
                                                    name  => "hl",
                                                    alt   => 0,
                                                    width => undef
                                                }
                                            ],
                                            };
                                        $repeat = 1;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        # push af;ld a, (hl);inc hl;ld h, (hl);ld l, a;pop af -> ld hl, (hl)
        for ( my $i = 0 ; $i <= $#effects - 5 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "push"
                && @{ $effects[$i]{args} } == 1
                && $effects[$i]{args}[0]{type} eq "regpair"
                && $effects[$i]{args}[0]{name} eq "af" )
            {
                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "ld"
                    && @{ $effects[ $i + 1 ]{args} } == 2
                    && $effects[ $i + 1 ]{args}[0]{type} eq "reg"
                    && $effects[ $i + 1 ]{args}[0]{name} eq "a"
                    && $effects[ $i + 1 ]{args}[1]{type} eq "mem"
                    && defined $effects[ $i + 1 ]{args}[1]{base}
                    && $effects[ $i + 1 ]{args}[1]{base} eq "hl" )
                {
                    if (   $effects[ $i + 2 ]{type} eq "inst"
                        && $effects[ $i + 2 ]{opcode} eq "inc"
                        && @{ $effects[ $i + 2 ]{args} } == 1
                        && $effects[ $i + 2 ]{args}[0]{type} eq "regpair"
                        && $effects[ $i + 2 ]{args}[0]{name} eq "hl" )
                    {
                        if (   $effects[ $i + 3 ]{type} eq "inst"
                            && $effects[ $i + 3 ]{opcode} eq "ld"
                            && @{ $effects[ $i + 3 ]{args} } == 2
                            && $effects[ $i + 3 ]{args}[0]{type} eq "reg"
                            && $effects[ $i + 3 ]{args}[0]{name} eq "h"
                            && $effects[ $i + 3 ]{args}[1]{type} eq "mem"
                            && defined $effects[ $i + 3 ]{args}[1]{base}
                            && $effects[ $i + 3 ]{args}[1]{base} eq "hl" )
                        {
                            if (   $effects[ $i + 4 ]{type} eq "inst"
                                && $effects[ $i + 4 ]{opcode} eq "ld"
                                && @{ $effects[ $i + 4 ]{args} } == 2
                                && $effects[ $i + 4 ]{args}[0]{type} eq "reg"
                                && $effects[ $i + 4 ]{args}[0]{name} eq "l"
                                && $effects[ $i + 4 ]{args}[1]{type} eq "reg"
                                && $effects[ $i + 4 ]{args}[1]{name} eq "a" )
                            {
                                if (   $effects[ $i + 5 ]{type} eq "inst"
                                    && $effects[ $i + 5 ]{opcode} eq "pop"
                                    && @{ $effects[ $i + 5 ]{args} } == 1
                                    && $effects[ $i + 5 ]{args}[0]{type} eq "regpair"
                                    && $effects[ $i + 5 ]{args}[0]{name} eq "af" )
                                {
                                    splice @effects, $i, 6,
                                        {
                                        type   => 'inst',
                                        opcode => "ld",
                                        args   => [
                                            {
                                                type  => 'regpair',
                                                name  => "hl",
                                                alt   => 0,
                                                width => undef
                                            },
                                            {
                                                type  => 'mem',
                                                space => 'mem',
                                                base  => "hl",
                                                disp  => undef,
                                                post  => 0,
                                                width => undef
                                            }
                                        ],
                                        };
                                    $repeat = 1;
                                }
                            }
                        }
                    }
                }
            }
        }

        # push af;ld a, h;ld (hl), l;inc hl;ld (hl), a;pop af;inc hl -> ld (hl+), hl
        for ( my $i = 0 ; $i <= $#effects - 6 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "push"
                && @{ $effects[$i]{args} } == 1
                && $effects[$i]{args}[0]{type} eq "regpair"
                && $effects[$i]{args}[0]{name} eq "af" )
            {
                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "ld"
                    && @{ $effects[ $i + 1 ]{args} } == 2
                    && $effects[ $i + 1 ]{args}[0]{type} eq "reg"
                    && $effects[ $i + 1 ]{args}[0]{name} eq "a"
                    && $effects[ $i + 1 ]{args}[1]{type} eq "reg"
                    && $effects[ $i + 1 ]{args}[1]{name} eq "h" )
                {
                    if (   $effects[ $i + 2 ]{type} eq "inst"
                        && $effects[ $i + 2 ]{opcode} eq "ld"
                        && @{ $effects[ $i + 2 ]{args} } == 2
                        && $effects[ $i + 2 ]{args}[0]{type} eq "mem"
                        && defined $effects[ $i + 2 ]{args}[0]{base}
                        && $effects[ $i + 2 ]{args}[0]{base} eq "hl"
                        && $effects[ $i + 2 ]{args}[1]{type} eq "reg"
                        && $effects[ $i + 2 ]{args}[1]{name} eq "l" )
                    {
                        if (   $effects[ $i + 3 ]{type} eq "inst"
                            && $effects[ $i + 3 ]{opcode} eq "inc"
                            && @{ $effects[ $i + 3 ]{args} } == 1
                            && $effects[ $i + 3 ]{args}[0]{type} eq "regpair"
                            && $effects[ $i + 3 ]{args}[0]{name} eq "hl" )
                        {
                            if (   $effects[ $i + 4 ]{type} eq "inst"
                                && $effects[ $i + 4 ]{opcode} eq "ld"
                                && @{ $effects[ $i + 4 ]{args} } == 2
                                && $effects[ $i + 4 ]{args}[0]{type} eq "mem"
                                && defined $effects[ $i + 4 ]{args}[0]{base}
                                && $effects[ $i + 4 ]{args}[0]{base} eq "hl"
                                && $effects[ $i + 4 ]{args}[1]{type} eq "reg"
                                && $effects[ $i + 4 ]{args}[1]{name} eq "a" )
                            {
                                if (   $effects[ $i + 5 ]{type} eq "inst"
                                    && $effects[ $i + 5 ]{opcode} eq "pop"
                                    && @{ $effects[ $i + 5 ]{args} } == 1
                                    && $effects[ $i + 5 ]{args}[0]{type} eq "regpair"
                                    && $effects[ $i + 5 ]{args}[0]{name} eq "af" )
                                {
                                    if (   $effects[ $i + 6 ]{type} eq "inst"
                                        && $effects[ $i + 6 ]{opcode} eq "inc"
                                        && @{ $effects[ $i + 6 ]{args} } == 1
                                        && $effects[ $i + 6 ]{args}[0]{type} eq "regpair"
                                        && $effects[ $i + 6 ]{args}[0]{name} eq "hl" )
                                    {
                                        splice @effects, $i, 7,
                                            {
                                            type   => 'inst',
                                            opcode => "ld",
                                            args   => [
                                                {
                                                    type  => 'mem',
                                                    space => 'mem',
                                                    base  => "hl",
                                                    disp  => undef,
                                                    post  => 0,
                                                    width => undef
                                                },
                                                {
                                                    type  => 'regpair',
                                                    name  => "hl",
                                                    alt   => 0,
                                                    width => undef
                                                }
                                            ],
                                            },
                                            {
                                            type   => 'inst',
                                            opcode => "inc",
                                            args   => [
                                                {
                                                    type  => 'regpair',
                                                    name  => "hl",
                                                    alt   => 0,
                                                    width => undef
                                                }
                                            ]
                                            },
                                            {
                                            type   => 'inst',
                                            opcode => "inc",
                                            args   => [
                                                {
                                                    type  => 'regpair',
                                                    name  => "hl",
                                                    alt   => 0,
                                                    width => undef
                                                }
                                            ]
                                            };
                                        $repeat = 1;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        # push de;push ix;pop de;ld (hl), e;inc hl;ld (hl), d;dec hl;pop de -> ld (hl), ix
        for ( my $i = 0 ; $i <= $#effects - 3 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "push"
                && @{ $effects[$i]{args} } == 1
                && $effects[$i]{args}[0]{type} eq "regpair"
                && $effects[$i]{args}[0]{name} eq "de" )
            {
                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "ld"
                    && @{ $effects[ $i + 1 ]{args} } == 2
                    && $effects[ $i + 1 ]{args}[0]{type} eq "regpair"
                    && $effects[ $i + 1 ]{args}[0]{name} eq "de"
                    && $effects[ $i + 1 ]{args}[1]{type} eq "regpair" )
                {
                    my $x_reg = $effects[ $i + 1 ]{args}[1]{name};

                    if (   $effects[ $i + 2 ]{type} eq "inst"
                        && $effects[ $i + 2 ]{opcode} eq "ld"
                        && @{ $effects[ $i + 2 ]{args} } == 2
                        && $effects[ $i + 2 ]{args}[0]{type} eq "mem"
                        && defined $effects[ $i + 2 ]{args}[0]{base}
                        && $effects[ $i + 2 ]{args}[0]{base} eq "hl"
                        && $effects[ $i + 2 ]{args}[1]{type} eq "regpair"
                        && $effects[ $i + 2 ]{args}[1]{name} eq "de" )
                    {
                        if (   $effects[ $i + 3 ]{type} eq "inst"
                            && $effects[ $i + 3 ]{opcode} eq "pop"
                            && @{ $effects[ $i + 3 ]{args} } == 1
                            && $effects[ $i + 3 ]{args}[0]{type} eq "regpair"
                            && $effects[ $i + 3 ]{args}[0]{name} eq "de" )
                        {
                            splice @effects, $i, 4,
                                {
                                type   => 'inst',
                                opcode => "ld",
                                args   => [
                                    {
                                        type  => 'mem',
                                        space => 'mem',
                                        base  => "hl",
                                        disp  => undef,
                                        post  => 0,
                                        width => undef
                                    },
                                    {
                                        type  => 'regpair',
                                        name  => $x_reg,
                                        alt   => 0,
                                        width => undef
                                    }
                                ],
                                };
                            $repeat = 1;
                        }
                    }
                }
            }
        }

        # push de;push ix;pop de;ld (hl), e;inc hl;ld (hl), d;inc hl;pop de -> ld (hl+), ix
        for ( my $i = 0 ; $i <= $#effects - 5 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "push"
                && @{ $effects[$i]{args} } == 1
                && $effects[$i]{args}[0]{type} eq "regpair"
                && $effects[$i]{args}[0]{name} eq "de" )
            {
                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "ld"
                    && @{ $effects[ $i + 1 ]{args} } == 2
                    && $effects[ $i + 1 ]{args}[0]{type} eq "regpair"
                    && $effects[ $i + 1 ]{args}[0]{name} eq "de"
                    && $effects[ $i + 1 ]{args}[1]{type} eq "regpair" )
                {
                    my $x_reg = $effects[ $i + 1 ]{args}[1]{name};

                    if (   $effects[ $i + 2 ]{type} eq "inst"
                        && $effects[ $i + 2 ]{opcode} eq "ld"
                        && @{ $effects[ $i + 2 ]{args} } == 2
                        && $effects[ $i + 2 ]{args}[0]{type} eq "mem"
                        && defined $effects[ $i + 2 ]{args}[0]{base}
                        && $effects[ $i + 2 ]{args}[0]{base} eq "hl"
                        && $effects[ $i + 2 ]{args}[1]{type} eq "regpair"
                        && $effects[ $i + 2 ]{args}[1]{name} eq "de" )
                    {
                        if (   $effects[ $i + 3 ]{type} eq "inst"
                            && $effects[ $i + 3 ]{opcode} eq "inc"
                            && @{ $effects[ $i + 3 ]{args} } == 1
                            && $effects[ $i + 3 ]{args}[0]{type} eq "regpair"
                            && $effects[ $i + 3 ]{args}[0]{name} eq "hl" )
                        {
                            if (   $effects[ $i + 4 ]{type} eq "inst"
                                && $effects[ $i + 4 ]{opcode} eq "inc"
                                && @{ $effects[ $i + 4 ]{args} } == 1
                                && $effects[ $i + 4 ]{args}[0]{type} eq "regpair"
                                && $effects[ $i + 4 ]{args}[0]{name} eq "hl" )
                            {
                                if (   $effects[ $i + 5 ]{type} eq "inst"
                                    && $effects[ $i + 5 ]{opcode} eq "pop"
                                    && @{ $effects[ $i + 5 ]{args} } == 1
                                    && $effects[ $i + 5 ]{args}[0]{type} eq "regpair"
                                    && $effects[ $i + 5 ]{args}[0]{name} eq "de" )
                                {
                                    splice @effects, $i, 6,
                                        {
                                        type   => 'inst',
                                        opcode => "ld",
                                        args   => [
                                            {
                                                type  => 'mem',
                                                space => 'mem',
                                                base  => "hl",
                                                disp  => undef,
                                                post  => 0,
                                                width => undef
                                            },
                                            {
                                                type  => 'regpair',
                                                name  => $x_reg,
                                                alt   => 0,
                                                width => undef
                                            }
                                        ],
                                        },
                                        {
                                        type   => 'inst',
                                        opcode => "inc",
                                        args   => [
                                            {
                                                type  => 'regpair',
                                                name  => "hl",
                                                alt   => 0,
                                                width => undef
                                            }
                                        ]
                                        },
                                        {
                                        type   => 'inst',
                                        opcode => "inc",
                                        args   => [
                                            {
                                                type  => 'regpair',
                                                name  => "hl",
                                                alt   => 0,
                                                width => undef
                                            }
                                        ]
                                        };
                                    $repeat = 1;
                                }
                            }
                        }
                    }
                }
            }
        }

        # push de;ld de, (hl);ld ix, de;pop de -> ld ix, (hl)
        for ( my $i = 0 ; $i <= $#effects - 3 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "push"
                && @{ $effects[$i]{args} } == 1
                && $effects[$i]{args}[0]{type} eq "regpair"
                && $effects[$i]{args}[0]{name} eq "de" )
            {
                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "ld"
                    && @{ $effects[ $i + 1 ]{args} } == 2
                    && $effects[ $i + 1 ]{args}[0]{type} eq "regpair"
                    && $effects[ $i + 1 ]{args}[0]{name} eq "de"
                    && $effects[ $i + 1 ]{args}[1]{type} eq "mem"
                    && defined $effects[ $i + 1 ]{args}[1]{base}
                    && $effects[ $i + 1 ]{args}[1]{base} eq "hl" )
                {
                    if (   $effects[ $i + 2 ]{type} eq "inst"
                        && $effects[ $i + 2 ]{opcode} eq "ld"
                        && @{ $effects[ $i + 2 ]{args} } == 2
                        && $effects[ $i + 2 ]{args}[0]{type} eq "regpair"
                        && $effects[ $i + 2 ]{args}[1]{type} eq "regpair"
                        && $effects[ $i + 2 ]{args}[1]{name} eq "de" )
                    {
                        my $x_reg = $effects[ $i + 2 ]{args}[0]{name};

                        if (   $effects[ $i + 3 ]{type} eq "inst"
                            && $effects[ $i + 3 ]{opcode} eq "pop"
                            && @{ $effects[ $i + 3 ]{args} } == 1
                            && $effects[ $i + 3 ]{args}[0]{type} eq "regpair"
                            && $effects[ $i + 3 ]{args}[0]{name} eq "de" )
                        {
                            splice @effects, $i, 4,
                                {
                                type   => 'inst',
                                opcode => "ld",
                                args   => [
                                    {
                                        type  => 'regpair',
                                        name  => $x_reg,
                                        alt   => 0,
                                        width => undef
                                    },
                                    {
                                        type  => 'mem',
                                        space => 'mem',
                                        base  => "hl",
                                        disp  => undef,
                                        post  => 0,
                                        width => undef
                                    }
                                ],
                                };
                            $repeat = 1;
                        }
                    }
                }
            }
        }

        # push de;ld de, (hl);inc hl; inc hl; ld ix, de;pop de -> ld ix, (hl+)
        for ( my $i = 0 ; $i <= $#effects - 5 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "push"
                && @{ $effects[$i]{args} } == 1
                && $effects[$i]{args}[0]{type} eq "regpair"
                && $effects[$i]{args}[0]{name} eq "de" )
            {
                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "ld"
                    && @{ $effects[ $i + 1 ]{args} } == 2
                    && $effects[ $i + 1 ]{args}[0]{type} eq "regpair"
                    && $effects[ $i + 1 ]{args}[0]{name} eq "de"
                    && $effects[ $i + 1 ]{args}[1]{type} eq "mem"
                    && defined $effects[ $i + 1 ]{args}[1]{base}
                    && $effects[ $i + 1 ]{args}[1]{base} eq "hl" )
                {
                    if (   $effects[ $i + 2 ]{type} eq "inst"
                        && $effects[ $i + 2 ]{opcode} eq "inc"
                        && @{ $effects[ $i + 2 ]{args} } == 1
                        && $effects[ $i + 2 ]{args}[0]{type} eq "regpair"
                        && $effects[ $i + 2 ]{args}[0]{name} eq "hl" )
                    {
                        if (   $effects[ $i + 3 ]{type} eq "inst"
                            && $effects[ $i + 3 ]{opcode} eq "inc"
                            && @{ $effects[ $i + 3 ]{args} } == 1
                            && $effects[ $i + 3 ]{args}[0]{type} eq "regpair"
                            && $effects[ $i + 3 ]{args}[0]{name} eq "hl" )
                        {
                            if (   $effects[ $i + 4 ]{type} eq "inst"
                                && $effects[ $i + 4 ]{opcode} eq "ld"
                                && @{ $effects[ $i + 4 ]{args} } == 2
                                && $effects[ $i + 4 ]{args}[0]{type} eq "regpair"
                                && $effects[ $i + 4 ]{args}[1]{type} eq "regpair"
                                && $effects[ $i + 4 ]{args}[1]{name} eq "de" )
                            {
                                my $x_reg = $effects[ $i + 4 ]{args}[0]{name};

                                if (   $effects[ $i + 5 ]{type} eq "inst"
                                    && $effects[ $i + 5 ]{opcode} eq "pop"
                                    && @{ $effects[ $i + 5 ]{args} } == 1
                                    && $effects[ $i + 5 ]{args}[0]{type} eq "regpair"
                                    && $effects[ $i + 5 ]{args}[0]{name} eq "de" )
                                {
                                    splice @effects, $i, 6,
                                        {
                                        type   => 'inst',
                                        opcode => "ld",
                                        args   => [
                                            {
                                                type  => 'regpair',
                                                name  => $x_reg,
                                                alt   => 0,
                                                width => undef
                                            },
                                            {
                                                type  => 'mem',
                                                space => 'mem',
                                                base  => "hl",
                                                disp  => undef,
                                                post  => 0,
                                                width => undef
                                            }
                                        ],
                                        },
                                        {
                                        args => [
                                            {
                                                alt   => 0,
                                                name  => "hl",
                                                type  => "regpair",
                                                width => undef
                                            },
                                        ],
                                        opcode => "inc",
                                        type   => "inst",
                                        },
                                        {
                                        args => [
                                            {
                                                alt   => 0,
                                                name  => "hl",
                                                type  => "regpair",
                                                width => undef
                                            },
                                        ],
                                        opcode => "inc",
                                        type   => "inst",
                                        };
                                    $repeat = 1;
                                }
                            }
                        }
                    }
                }
            }
        }

        # ld (ix+%d), c;ld (ix+%d+1), b -> ld (ix+%d), bc
        for ( my $i = 0 ; $i <= $#effects - 1 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "ld"
                && @{ $effects[$i]{args} } == 2
                && $effects[$i]{args}[0]{type} eq "mem"
                && defined $effects[$i]{args}[0]{base}
                && ( $effects[$i]{args}[0]{disp_offset} // 0 ) == 0
                && $effects[$i]{args}[1]{type} eq "reg" )
            {
                my $x_reg       = $effects[$i]{args}[0]{base};
                my $disp        = $effects[$i]{args}[0]{disp};
                my $disp_offset = $effects[$i]{args}[0]{disp_offset};
                my $reg_l       = $effects[$i]{args}[1]{name};

                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "ld"
                    && @{ $effects[ $i + 1 ]{args} } == 2
                    && $effects[ $i + 1 ]{args}[0]{type} eq "mem"
                    && defined $effects[ $i + 1 ]{args}[0]{base}
                    && $effects[ $i + 1 ]{args}[0]{base} eq $x_reg
                    && $effects[ $i + 1 ]{args}[0]{disp_offset} == 1
                    && $effects[ $i + 1 ]{args}[1]{type} eq "reg" )
                {
                    my $disp2    = $effects[ $i + 1 ]{args}[0]{disp};
                    my $reg_h    = $effects[ $i + 1 ]{args}[1]{name};
                    my $reg_pair = reg_pair( $reg_h, $reg_l );

                    if ( ( $disp // "" ) eq ( $disp2 // "" ) ) {
                        splice @effects, $i, 2,
                            {
                            type   => 'inst',
                            opcode => "ld",
                            args   => [
                                {
                                    type  => 'mem',
                                    space => 'mem',
                                    base  => $x_reg,
                                    disp  => $disp,
                                    ( defined $disp_offset ? ( disp_offset => $disp_offset ) : () ),
                                    post  => 0,
                                    width => undef
                                },
                                {
                                    type  => 'regpair',
                                    name  => $reg_pair,
                                    alt   => 0,
                                    width => undef
                                }
                            ],
                            };
                        $repeat = 1;
                    }
                }
            }
        }

        # ld c, (ix+%d);ld b, (ix+%d+1) -> ld bc, (ix+%d)
        for ( my $i = 0 ; $i <= $#effects - 1 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "ld"
                && @{ $effects[$i]{args} } == 2
                && $effects[$i]{args}[0]{type} eq "reg"
                && $effects[$i]{args}[1]{type} eq "mem"
                && defined $effects[$i]{args}[1]{base}
                && ( $effects[$i]{args}[1]{disp_offset} // 0 ) == 0 )
            {
                my $reg_l       = $effects[$i]{args}[0]{name};
                my $x_reg       = $effects[$i]{args}[1]{base};
                my $disp        = $effects[$i]{args}[1]{disp};
                my $disp_offset = $effects[$i]{args}[1]{disp_offset};

                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "ld"
                    && @{ $effects[ $i + 1 ]{args} } == 2
                    && $effects[ $i + 1 ]{args}[0]{type} eq "reg"
                    && $effects[ $i + 1 ]{args}[1]{type} eq "mem"
                    && defined $effects[ $i + 1 ]{args}[1]{base}
                    && $effects[ $i + 1 ]{args}[1]{base} eq $x_reg
                    && $effects[ $i + 1 ]{args}[1]{disp_offset} == 1 )
                {
                    my $reg_h    = $effects[ $i + 1 ]{args}[0]{name};
                    my $disp2    = $effects[ $i + 1 ]{args}[1]{disp};
                    my $reg_pair = reg_pair( $reg_h, $reg_l );

                    if ( ( $disp // "" ) eq ( $disp2 // "" ) ) {
                        splice @effects, $i, 2,
                            {
                            type   => 'inst',
                            opcode => "ld",
                            args   => [
                                {
                                    type  => 'regpair',
                                    name  => $reg_pair,
                                    alt   => 0,
                                    width => undef
                                },
                                {
                                    type  => 'mem',
                                    space => 'mem',
                                    base  => $x_reg,
                                    disp  => $disp,
                                    (
                                        defined $disp_offset
                                        ? ( disp_offset => $disp_offset )
                                        : ()
                                    ),
                                    post  => 0,
                                    width => undef
                                }
                            ],
                            };
                        $repeat = 1;
                    }
                }
            }
        }

        # push iy;ex (sp), hl;ld (ix+%d), l;ld (ix+%d+1), h;ex (sp), hl;pop iy -> ld (ix), iy
        for ( my $i = 0 ; $i <= $#effects - 4 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "push"
                && @{ $effects[$i]{args} } == 1
                && $effects[$i]{args}[0]{type} eq "regpair" )
            {
                my $x1_reg = $effects[$i]{args}[0]{name};

                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "ex"
                    && @{ $effects[ $i + 1 ]{args} } == 2
                    && $effects[ $i + 1 ]{args}[0]{type} eq "mem"
                    && defined $effects[ $i + 1 ]{args}[0]{base}
                    && $effects[ $i + 1 ]{args}[0]{base} eq "sp"
                    && $effects[ $i + 1 ]{args}[1]{type} eq "regpair"
                    && $effects[ $i + 1 ]{args}[1]{name} eq "hl" )
                {
                    if (   $effects[ $i + 2 ]{type} eq "inst"
                        && $effects[ $i + 2 ]{opcode} eq "ld"
                        && @{ $effects[ $i + 2 ]{args} } == 2
                        && $effects[ $i + 2 ]{args}[0]{type} eq "mem"
                        && defined $effects[ $i + 2 ]{args}[0]{base}
                        && ( $effects[ $i + 2 ]{args}[0]{disp_offset} // 0 ) == 0
                        && $effects[ $i + 2 ]{args}[1]{type} eq "regpair"
                        && $effects[ $i + 2 ]{args}[1]{name} eq "hl" )
                    {
                        my $x2_reg      = $effects[ $i + 2 ]{args}[0]{base};
                        my $disp        = $effects[ $i + 2 ]{args}[0]{disp};
                        my $disp_offset = $effects[ $i + 2 ]{args}[0]{disp_offset};

                        if (   $effects[ $i + 3 ]{type} eq "inst"
                            && $effects[ $i + 3 ]{opcode} eq "ex"
                            && @{ $effects[ $i + 3 ]{args} } == 2
                            && $effects[ $i + 3 ]{args}[0]{type} eq "mem"
                            && defined $effects[ $i + 3 ]{args}[0]{base}
                            && $effects[ $i + 3 ]{args}[0]{base} eq "sp"
                            && $effects[ $i + 3 ]{args}[1]{type} eq "regpair"
                            && $effects[ $i + 3 ]{args}[1]{name} eq "hl" )
                        {
                            if (   $effects[ $i + 4 ]{type} eq "inst"
                                && $effects[ $i + 4 ]{opcode} eq "pop"
                                && @{ $effects[ $i + 4 ]{args} } == 1
                                && $effects[ $i + 4 ]{args}[0]{type} eq "regpair"
                                && $effects[ $i + 4 ]{args}[0]{name} eq $x1_reg )
                            {
                                splice @effects, $i, 5,
                                    {
                                    type   => 'inst',
                                    opcode => "ld",
                                    args   => [
                                        {
                                            type  => 'mem',
                                            space => 'mem',
                                            base  => $x2_reg,
                                            disp  => $disp,
                                            (
                                                defined $disp_offset
                                                ? ( disp_offset => $disp_offset )
                                                : ()
                                            ),
                                            post  => 0,
                                            width => undef
                                        },
                                        {
                                            type  => 'regpair',
                                            name  => $x1_reg,
                                            alt   => 0,
                                            width => undef
                                        }
                                    ],
                                    };
                                $repeat = 1;
                            }
                        }
                    }
                }
            }
        }

        # push iy;ex (sp), hl;ld hl, (ix+%d);ex (sp), hl;pop iy -> ld (ix), iy
        for ( my $i = 0 ; $i <= $#effects - 4 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "push"
                && @{ $effects[$i]{args} } == 1
                && $effects[$i]{args}[0]{type} eq "regpair" )
            {
                my $x1_reg = $effects[$i]{args}[0]{name};

                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "ex"
                    && @{ $effects[ $i + 1 ]{args} } == 2
                    && $effects[ $i + 1 ]{args}[0]{type} eq "mem"
                    && defined $effects[ $i + 1 ]{args}[0]{base}
                    && $effects[ $i + 1 ]{args}[0]{base} eq "sp"
                    && $effects[ $i + 1 ]{args}[1]{type} eq "regpair"
                    && $effects[ $i + 1 ]{args}[1]{name} eq "hl" )
                {
                    if (   $effects[ $i + 2 ]{type} eq "inst"
                        && $effects[ $i + 2 ]{opcode} eq "ld"
                        && @{ $effects[ $i + 2 ]{args} } == 2
                        && $effects[ $i + 2 ]{args}[0]{type} eq "regpair"
                        && $effects[ $i + 2 ]{args}[0]{name} eq "hl"
                        && $effects[ $i + 2 ]{args}[1]{type} eq "mem"
                        && defined $effects[ $i + 2 ]{args}[1]{base}
                        && ( $effects[ $i + 2 ]{args}[1]{disp_offset} // 0 ) == 0 )
                    {
                        my $x2_reg = $effects[ $i + 2 ]{args}[1]{base};
                        my $disp   = $effects[ $i + 2 ]{args}[1]{disp};
                        my $disp_offset =
                            $effects[ $i + 2 ]{args}[1]{disp_offset};

                        if (   $effects[ $i + 3 ]{type} eq "inst"
                            && $effects[ $i + 3 ]{opcode} eq "ex"
                            && @{ $effects[ $i + 3 ]{args} } == 2
                            && $effects[ $i + 3 ]{args}[0]{type} eq "mem"
                            && defined $effects[ $i + 3 ]{args}[0]{base}
                            && $effects[ $i + 3 ]{args}[0]{base} eq "sp"
                            && $effects[ $i + 3 ]{args}[1]{type} eq "regpair"
                            && $effects[ $i + 3 ]{args}[1]{name} eq "hl" )
                        {
                            if (   $effects[ $i + 4 ]{type} eq "inst"
                                && $effects[ $i + 4 ]{opcode} eq "pop"
                                && @{ $effects[ $i + 4 ]{args} } == 1
                                && $effects[ $i + 4 ]{args}[0]{type} eq "regpair"
                                && $effects[ $i + 4 ]{args}[0]{name} eq $x1_reg )
                            {
                                splice @effects, $i, 5,
                                    {
                                    type   => 'inst',
                                    opcode => "ld",
                                    args   => [
                                        {
                                            type  => 'regpair',
                                            name  => $x1_reg,
                                            alt   => 0,
                                            width => undef
                                        },
                                        {
                                            type  => 'mem',
                                            space => 'mem',
                                            base  => $x2_reg,
                                            disp  => $disp,
                                            (
                                                defined $disp_offset
                                                ? ( disp_offset => $disp_offset )
                                                : ()
                                            ),
                                            post  => 0,
                                            width => undef
                                        }
                                    ],
                                    };
                                $repeat = 1;
                            }
                        }
                    }
                }
            }
        }

        # exx;ld bc, de;exx -> ld bc', de'
        for ( my $i = 0 ; $i <= $#effects - 2 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "exx" )
            {
                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "ld"
                    && @{ $effects[ $i + 1 ]{args} } == 2
                    && $effects[ $i + 1 ]{args}[0]{type} eq "regpair"
                    && $effects[ $i + 1 ]{args}[1]{type} eq "regpair" )
                {
                    my $regpair1 = $effects[ $i + 1 ]{args}[0];
                    my $regpair2 = $effects[ $i + 1 ]{args}[1];

                    if (   $effects[ $i + 2 ]{type} eq "inst"
                        && $effects[ $i + 2 ]{opcode} eq "exx" )
                    {
                        $regpair1->{alt} = !$regpair1->{alt};
                        $regpair2->{alt} = !$regpair2->{alt};

                        splice @effects, $i, 3,
                            {
                            type   => 'inst',
                            opcode => "ld",
                            args   => [ $regpair1, $regpair2 ],
                            };
                        $repeat = 1;
                    }
                }
            }
        }

        # exx; push RP; exx -> push RP1'
        for ( my $i = 0 ; $i <= $#effects - 2 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "exx" )
            {
                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "push"
                    && @{ $effects[ $i + 1 ]{args} } == 1
                    && $effects[ $i + 1 ]{args}[0]{type} eq "regpair" )
                {
                    my $rp     = $effects[ $i + 1 ]{args}[0];
                    my $rp_alt = { %$rp, alt => !$rp->{alt} };

                    if (   $effects[ $i + 2 ]{type} eq "inst"
                        && $effects[ $i + 2 ]{opcode} eq "exx" )
                    {
                        splice @effects, $i, 3,
                            {
                            type   => 'inst',
                            opcode => "push",
                            args   => [$rp_alt],
                            };
                        $repeat = 1;
                    }
                }
            }
        }

        # exx; push RP1; exx; pop RP2 -> ld RP2, RP1'
        for ( my $i = 0 ; $i <= $#effects - 1 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "push"
                && @{ $effects[$i]{args} } == 1
                && $effects[$i]{args}[0]{type} eq "regpair"
                && $effects[$i]{args}[0]{alt} == 1 )
            {
                my $rp1 = $effects[$i]{args}[0];

                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "pop"
                    && @{ $effects[ $i + 1 ]{args} } == 1
                    && $effects[ $i + 1 ]{args}[0]{type} eq "regpair" )
                {
                    my $rp2 = $effects[ $i + 1 ]{args}[0];

                    splice @effects, $i, 2,
                        {
                        type   => 'inst',
                        opcode => "ld",
                        args   => [ $rp2, $rp1 ],
                        };
                    $repeat = 1;
                }
            }
        }

        # push hl; ld hl, (%m); ld bc, hl; pop hl -> ld bc, (%m)
        for ( my $i = 0 ; $i <= $#effects - 3 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "push"
                && @{ $effects[$i]{args} } == 1
                && $effects[$i]{args}[0]{type} eq "regpair"
                && $effects[$i]{args}[0]{name} eq "hl" )
            {
                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "ld"
                    && @{ $effects[ $i + 1 ]{args} } == 2
                    && $effects[ $i + 1 ]{args}[0]{type} eq "regpair"
                    && $effects[ $i + 1 ]{args}[0]{name} eq "hl"
                    && $effects[ $i + 1 ]{args}[1]{type} eq "mem" )
                {
                    my $mem_arg = $effects[ $i + 1 ]{args}[1];

                    if (   $effects[ $i + 2 ]{type} eq "inst"
                        && $effects[ $i + 2 ]{opcode} eq "ld"
                        && @{ $effects[ $i + 2 ]{args} } == 2
                        && $effects[ $i + 2 ]{args}[0]{type} eq "regpair"
                        && $effects[ $i + 2 ]{args}[1]{type} eq "regpair"
                        && $effects[ $i + 2 ]{args}[1]{name} eq "hl" )
                    {
                        my $regpair = $effects[ $i + 2 ]{args}[0];

                        if (   $effects[ $i + 3 ]{type} eq "inst"
                            && $effects[ $i + 3 ]{opcode} eq "pop"
                            && @{ $effects[ $i + 3 ]{args} } == 1
                            && $effects[ $i + 3 ]{args}[0]{type} eq "regpair"
                            && $effects[ $i + 3 ]{args}[0]{name} eq "hl" )
                        {
                            splice @effects, $i, 4,
                                {
                                type   => 'inst',
                                opcode => "ld",
                                args   => [ $regpair, $mem_arg ],
                                };
                            $repeat = 1;
                        }
                    }
                }
            }
        }

        # push af;ld a, (%m);ld c, a;ld a, (%m+1);ld b, a;pop af -> ld bc, (%m)
        for ( my $i = 0 ; $i <= $#effects - 5 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "push"
                && @{ $effects[$i]{args} } == 1
                && $effects[$i]{args}[0]{type} eq "regpair"
                && $effects[$i]{args}[0]{name} eq "af" )
            {
                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "ld"
                    && @{ $effects[ $i + 1 ]{args} } == 2
                    && $effects[ $i + 1 ]{args}[0]{type} eq "reg"
                    && $effects[ $i + 1 ]{args}[0]{name} eq "a"
                    && $effects[ $i + 1 ]{args}[1]{type} eq "mem"
                    && defined $effects[ $i + 1 ]{args}[1]{addr}
                    && ( $effects[ $i + 1 ]{args}[1]{disp_offset} // 0 ) == 0 )
                {
                    my $mem_arg  = $effects[ $i + 1 ]{args}[1];
                    my $mem_addr = $effects[ $i + 1 ]{args}[1]{addr};

                    if (   $effects[ $i + 2 ]{type} eq "inst"
                        && $effects[ $i + 2 ]{opcode} eq "ld"
                        && @{ $effects[ $i + 2 ]{args} } == 2
                        && $effects[ $i + 2 ]{args}[0]{type} eq "reg"
                        && $effects[ $i + 2 ]{args}[1]{type} eq "reg"
                        && $effects[ $i + 2 ]{args}[1]{name} eq "a" )
                    {
                        my $reg_l = $effects[ $i + 2 ]{args}[0]{name};

                        if (   $effects[ $i + 3 ]{type} eq "inst"
                            && $effects[ $i + 3 ]{opcode} eq "ld"
                            && @{ $effects[ $i + 3 ]{args} } == 2
                            && $effects[ $i + 3 ]{args}[0]{type} eq "reg"
                            && $effects[ $i + 3 ]{args}[0]{name} eq "a"
                            && $effects[ $i + 3 ]{args}[1]{type} eq "mem"
                            && defined $effects[ $i + 3 ]{args}[1]{addr}
                            && ( $effects[ $i + 3 ]{args}[1]{disp_offset} // 0 ) == 1 )
                        {
                            my $mem_addr2 = $effects[ $i + 3 ]{args}[1]{addr};
                            if ( $mem_addr eq $mem_addr2 ) {
                                if (   $effects[ $i + 4 ]{type} eq "inst"
                                    && $effects[ $i + 4 ]{opcode} eq "ld"
                                    && @{ $effects[ $i + 4 ]{args} } == 2
                                    && $effects[ $i + 4 ]{args}[0]{type} eq "reg"
                                    && $effects[ $i + 4 ]{args}[1]{type} eq "reg"
                                    && $effects[ $i + 4 ]{args}[1]{name} eq "a" )
                                {
                                    my $reg_h    = $effects[ $i + 4 ]{args}[0]{name};
                                    my $reg_pair = reg_pair( $reg_h, $reg_l );

                                    if (   $effects[ $i + 5 ]{type} eq "inst"
                                        && $effects[ $i + 5 ]{opcode} eq "pop"
                                        && @{ $effects[ $i + 5 ]{args} } == 1
                                        && $effects[ $i + 5 ]{args}[0]{type} eq "regpair"
                                        && $effects[ $i + 5 ]{args}[0]{name} eq "af" )
                                    {
                                        splice @effects, $i, 6,
                                            {
                                            type   => 'inst',
                                            opcode => "ld",
                                            args   => [
                                                {
                                                    type  => 'regpair',
                                                    name  => $reg_pair,
                                                    alt   => 0,
                                                    width => undef
                                                },
                                                $mem_arg
                                            ],
                                            };
                                        $repeat = 1;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        # cpl a; inc a -> neg a
        for ( my $i = 0 ; $i <= $#effects - 1 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "cpl"
                && @{ $effects[$i]{args} } == 1
                && $effects[$i]{args}[0]{type} eq "reg"
                && $effects[$i]{args}[0]{name} eq "a" )
            {
                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "inc"
                    && @{ $effects[ $i + 1 ]{args} } == 1
                    && $effects[ $i + 1 ]{args}[0]{type} eq "reg"
                    && $effects[ $i + 1 ]{args}[0]{name} eq "a" )
                {
                    splice @effects, $i, 2,
                        {
                        type   => 'inst',
                        opcode => "neg",
                        args   => [
                            {
                                type  => 'reg',
                                name  => "a",
                                alt   => 0,
                                width => undef
                            }
                        ],
                        };
                    $repeat = 1;
                }
            }
        }

        # push af; ld a, REG; cpl a; ld REG, a; inc REG; pop af -> neg REG
        for ( my $i = 0 ; $i <= $#effects - 5 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "push"
                && @{ $effects[$i]{args} } == 1
                && $effects[$i]{args}[0]{type} eq "regpair"
                && $effects[$i]{args}[0]{name} eq "af" )
            {
                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "ld"
                    && @{ $effects[ $i + 1 ]{args} } == 2
                    && $effects[ $i + 1 ]{args}[0]{type} eq "reg"
                    && $effects[ $i + 1 ]{args}[0]{name} eq "a"
                    && $effects[ $i + 1 ]{args}[1]{type} eq "reg" )
                {
                    my $reg = $effects[ $i + 1 ]{args}[1]{name};

                    if (   $effects[ $i + 2 ]{type} eq "inst"
                        && $effects[ $i + 2 ]{opcode} eq "cpl"
                        && @{ $effects[ $i + 2 ]{args} } == 1
                        && $effects[ $i + 2 ]{args}[0]{type} eq "reg"
                        && $effects[ $i + 2 ]{args}[0]{name} eq "a" )
                    {
                        if (   $effects[ $i + 3 ]{type} eq "inst"
                            && $effects[ $i + 3 ]{opcode} eq "ld"
                            && @{ $effects[ $i + 3 ]{args} } == 2
                            && $effects[ $i + 3 ]{args}[0]{type} eq "reg"
                            && $effects[ $i + 3 ]{args}[0]{name} eq $reg
                            && $effects[ $i + 3 ]{args}[1]{type} eq "reg"
                            && $effects[ $i + 3 ]{args}[1]{name} eq "a" )
                        {
                            if (   $effects[ $i + 4 ]{type} eq "inst"
                                && $effects[ $i + 4 ]{opcode} eq "inc"
                                && @{ $effects[ $i + 4 ]{args} } == 1
                                && $effects[ $i + 4 ]{args}[0]{type} eq "reg"
                                && $effects[ $i + 4 ]{args}[0]{name} eq $reg )
                            {
                                if (   $effects[ $i + 5 ]{type} eq "inst"
                                    && $effects[ $i + 5 ]{opcode} eq "pop"
                                    && @{ $effects[ $i + 5 ]{args} } == 1
                                    && $effects[ $i + 5 ]{args}[0]{type} eq "regpair"
                                    && $effects[ $i + 5 ]{args}[0]{name} eq "af" )
                                {
                                    splice @effects, $i, 6,
                                        {
                                        type   => 'inst',
                                        opcode => "neg",
                                        args   => [
                                            {
                                                type  => 'reg',
                                                name  => $reg,
                                                alt   => 0,
                                                width => undef
                                            }
                                        ],
                                        };
                                    $repeat = 1;
                                }
                            }
                        }
                    }
                }
            }
        }

        # push af;
        # ld a, REG_H; cpl a; ld REG_H, a;
        # ld a, REG_L; cpl a; ld REG_L, a:
        # inc REG; pop af
        # -> neg REG
        for ( my $i = 0 ; $i <= $#effects - 8 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "push"
                && @{ $effects[$i]{args} } == 1
                && $effects[$i]{args}[0]{type} eq "regpair"
                && $effects[$i]{args}[0]{name} eq "af" )
            {
                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "ld"
                    && @{ $effects[ $i + 1 ]{args} } == 2
                    && $effects[ $i + 1 ]{args}[0]{type} eq "reg"
                    && $effects[ $i + 1 ]{args}[0]{name} eq "a"
                    && $effects[ $i + 1 ]{args}[1]{type} eq "reg" )
                {
                    my $reg_h = $effects[ $i + 1 ]{args}[1]{name};

                    if (   $effects[ $i + 2 ]{type} eq "inst"
                        && $effects[ $i + 2 ]{opcode} eq "cpl"
                        && @{ $effects[ $i + 2 ]{args} } == 1
                        && $effects[ $i + 2 ]{args}[0]{type} eq "reg"
                        && $effects[ $i + 2 ]{args}[0]{name} eq "a" )
                    {
                        if (   $effects[ $i + 3 ]{type} eq "inst"
                            && $effects[ $i + 3 ]{opcode} eq "ld"
                            && @{ $effects[ $i + 3 ]{args} } == 2
                            && $effects[ $i + 3 ]{args}[0]{type} eq "reg"
                            && $effects[ $i + 3 ]{args}[0]{name} eq $reg_h
                            && $effects[ $i + 3 ]{args}[1]{type} eq "reg"
                            && $effects[ $i + 3 ]{args}[1]{name} eq "a" )
                        {
                            if (   $effects[ $i + 4 ]{type} eq "inst"
                                && $effects[ $i + 4 ]{opcode} eq "ld"
                                && @{ $effects[ $i + 4 ]{args} } == 2
                                && $effects[ $i + 4 ]{args}[0]{type} eq "reg"
                                && $effects[ $i + 4 ]{args}[0]{name} eq "a"
                                && $effects[ $i + 4 ]{args}[1]{type} eq "reg" )
                            {
                                my $reg_l = $effects[ $i + 4 ]{args}[1]{name};
                                if ( $reg_h ne "a" && $reg_l ne "a" ) {
                                    my $reg_pair = reg_pair( $reg_h, $reg_l );

                                    if (   $effects[ $i + 5 ]{type} eq "inst"
                                        && $effects[ $i + 5 ]{opcode} eq "cpl"
                                        && @{ $effects[ $i + 5 ]{args} } == 1
                                        && $effects[ $i + 5 ]{args}[0]{type} eq "reg"
                                        && $effects[ $i + 5 ]{args}[0]{name} eq "a" )
                                    {
                                        if (   $effects[ $i + 6 ]{type} eq "inst"
                                            && $effects[ $i + 6 ]{opcode} eq "ld"
                                            && @{ $effects[ $i + 6 ]{args} } == 2
                                            && $effects[ $i + 6 ]{args}[0]{type} eq "reg"
                                            && $effects[ $i + 6 ]{args}[0]{name} eq $reg_l
                                            && $effects[ $i + 6 ]{args}[1]{type} eq "reg"
                                            && $effects[ $i + 6 ]{args}[1]{name} eq "a" )
                                        {
                                            if (   $effects[ $i + 7 ]{type} eq "inst"
                                                && $effects[ $i + 7 ]{opcode} eq "inc"
                                                && @{ $effects[ $i + 7 ]{args} } == 1
                                                && $effects[ $i + 7 ]{args}[0]{type} eq "regpair"
                                                && $effects[ $i + 7 ]{args}[0]{name} eq $reg_pair )
                                            {
                                                if (   $effects[ $i + 8 ]{type} eq "inst"
                                                    && $effects[ $i + 8 ]{opcode} eq "pop"
                                                    && @{ $effects[ $i + 8 ]{args} } == 1
                                                    && $effects[ $i + 8 ]{args}[0]{type} eq
                                                    "regpair"
                                                    && $effects[ $i + 8 ]{args}[0]{name} eq "af" )
                                                {
                                                    splice @effects, $i, 9,
                                                        {
                                                        type   => 'inst',
                                                        opcode => "neg",
                                                        args   => [
                                                            {
                                                                type  => 'regpair',
                                                                name  => $reg_pair,
                                                                alt   => 0,
                                                                width => undef
                                                            }
                                                        ],
                                                        };
                                                    $repeat = 1;
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        # push af; push hl; ld hl, IX
        # ld a, h; cpl a; ld h, a;
        # ld a, l; cpl a; ld l, a:
        # inc hl; ld ix, hl; pop hl; pop af
        # -> neg REG
        for ( my $i = 0 ; $i <= $#effects - 12 ; $i++ ) {
            if (   $effects[$i]{type} eq "inst"
                && $effects[$i]{opcode} eq "push"
                && @{ $effects[$i]{args} } == 1
                && $effects[$i]{args}[0]{type} eq "regpair"
                && $effects[$i]{args}[0]{name} eq "af" )
            {
                if (   $effects[ $i + 1 ]{type} eq "inst"
                    && $effects[ $i + 1 ]{opcode} eq "push"
                    && @{ $effects[ $i + 1 ]{args} } == 1
                    && $effects[ $i + 1 ]{args}[0]{type} eq "regpair"
                    && $effects[ $i + 1 ]{args}[0]{name} eq "hl" )
                {
                    if (   $effects[ $i + 2 ]{type} eq "inst"
                        && $effects[ $i + 2 ]{opcode} eq "ld"
                        && @{ $effects[ $i + 2 ]{args} } == 2
                        && $effects[ $i + 2 ]{args}[0]{type} eq "regpair"
                        && $effects[ $i + 2 ]{args}[0]{name} eq "hl"
                        && $effects[ $i + 2 ]{args}[1]{type} eq "regpair" )
                    {
                        my $x_reg = $effects[ $i + 2 ]{args}[1]{name};

                        if (   $effects[ $i + 3 ]{type} eq "inst"
                            && $effects[ $i + 3 ]{opcode} eq "ld"
                            && @{ $effects[ $i + 3 ]{args} } == 2
                            && $effects[ $i + 3 ]{args}[0]{type} eq "reg"
                            && $effects[ $i + 3 ]{args}[0]{name} eq "a"
                            && $effects[ $i + 3 ]{args}[1]{type} eq "reg"
                            && $effects[ $i + 3 ]{args}[1]{name} eq "h" )
                        {
                            if (   $effects[ $i + 4 ]{type} eq "inst"
                                && $effects[ $i + 4 ]{opcode} eq "cpl"
                                && @{ $effects[ $i + 4 ]{args} } == 1
                                && $effects[ $i + 4 ]{args}[0]{type} eq "reg"
                                && $effects[ $i + 4 ]{args}[0]{name} eq "a" )
                            {
                                if (   $effects[ $i + 5 ]{type} eq "inst"
                                    && $effects[ $i + 5 ]{opcode} eq "ld"
                                    && @{ $effects[ $i + 5 ]{args} } == 2
                                    && $effects[ $i + 5 ]{args}[0]{type} eq "reg"
                                    && $effects[ $i + 5 ]{args}[0]{name} eq "h"
                                    && $effects[ $i + 5 ]{args}[1]{type} eq "reg"
                                    && $effects[ $i + 5 ]{args}[1]{name} eq "a" )
                                {
                                    if (   $effects[ $i + 6 ]{type} eq "inst"
                                        && $effects[ $i + 6 ]{opcode} eq "ld"
                                        && @{ $effects[ $i + 6 ]{args} } == 2
                                        && $effects[ $i + 6 ]{args}[0]{type} eq "reg"
                                        && $effects[ $i + 6 ]{args}[0]{name} eq "a"
                                        && $effects[ $i + 6 ]{args}[1]{type} eq "reg"
                                        && $effects[ $i + 6 ]{args}[1]{name} eq "l" )
                                    {
                                        if (   $effects[ $i + 7 ]{type} eq "inst"
                                            && $effects[ $i + 7 ]{opcode} eq "cpl"
                                            && @{ $effects[ $i + 7 ]{args} } == 1
                                            && $effects[ $i + 7 ]{args}[0]{type} eq "reg"
                                            && $effects[ $i + 7 ]{args}[0]{name} eq "a" )
                                        {
                                            if (   $effects[ $i + 8 ]{type} eq "inst"
                                                && $effects[ $i + 8 ]{opcode} eq "ld"
                                                && @{ $effects[ $i + 8 ]{args} } == 2
                                                && $effects[ $i + 8 ]{args}[0]{type} eq "reg"
                                                && $effects[ $i + 8 ]{args}[0]{name} eq "l"
                                                && $effects[ $i + 8 ]{args}[1]{type} eq "reg"
                                                && $effects[ $i + 8 ]{args}[1]{name} eq "a" )
                                            {
                                                if (   $effects[ $i + 9 ]{type} eq "inst"
                                                    && $effects[ $i + 9 ]{opcode} eq "inc"
                                                    && @{ $effects[ $i + 9 ]{args} } == 1
                                                    && $effects[ $i + 9 ]{args}[0]{type} eq
                                                    "regpair"
                                                    && $effects[ $i + 9 ]{args}[0]{name} eq "hl" )
                                                {
                                                    if (   $effects[ $i + 10 ]{type} eq "inst"
                                                        && $effects[ $i + 10 ]{opcode} eq "ld"
                                                        && @{ $effects[ $i + 10 ]{args} } == 2
                                                        && $effects[ $i + 10 ]{args}[0]{type} eq
                                                        "regpair"
                                                        && $effects[ $i + 10 ]{args}[0]{name} eq
                                                        $x_reg
                                                        && $effects[ $i + 10 ]{args}[1]{type} eq
                                                        "regpair"
                                                        && $effects[ $i + 10 ]{args}[1]{name} eq
                                                        "hl" )
                                                    {
                                                        if (   $effects[ $i + 11 ]{type} eq "inst"
                                                            && $effects[ $i + 11 ]{opcode} eq "pop"
                                                            && @{ $effects[ $i + 11 ]{args} } == 1
                                                            && $effects[ $i + 11 ]{args}[0]{type}
                                                            eq "regpair"
                                                            && $effects[ $i + 11 ]{args}[0]{name}
                                                            eq "hl" )
                                                        {
                                                            if ( $effects[ $i + 12 ]{type} eq "inst"
                                                                && $effects[ $i + 12 ]{opcode} eq
                                                                "pop"
                                                                && @{ $effects[ $i + 12 ]{args} }
                                                                == 1
                                                                && $effects[ $i + 12 ]{args}[0]
                                                                {type} eq "regpair"
                                                                && $effects[ $i + 12 ]{args}[0]
                                                                {name} eq "af" )
                                                            {
                                                                splice @effects, $i, 13,
                                                                    {
                                                                    type   => 'inst',
                                                                    opcode => "neg",
                                                                    args   => [
                                                                        {
                                                                            type  => 'regpair',
                                                                            name  => $x_reg,
                                                                            alt   => 0,
                                                                            width => undef
                                                                        }
                                                                    ],
                                                                    };
                                                                $repeat = 1;
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        # remove redundant labels
        my %used_labels;
        for ( my $i = 0 ; $i <= $#effects ; $i++ ) {
            if ( $effects[$i]{type} eq "inst" ) {
                for my $arg ( @{ $effects[$i]{args} } ) {
                    if ( $arg->{type} eq "labelref" ) {
                        $used_labels{ $arg->{name} } = 1;
                    }
                }
            }
        }

        for ( my $i = 0 ; $i <= $#effects ; $i++ ) {
            if ( $effects[$i]{type} eq "label"
                && !exists $used_labels{ $effects[$i]{name} } )
            {
                splice @effects, $i, 1;
                $repeat = 1;
            }
        }

    } while ($repeat);

    return @effects;
}

sub intel_to_zilog {
    my ($asm) = @_;

    $asm = lc($asm);
    for ($asm) {

        # --- mnemonic renames ---
        s/\b inr \b/inc/x;
        s/\b dcr \b/dec/x;
        s/\b ana \b/and/x;
        s/\b ora \b/or/x;
        s/\b xra \b/xor/x;
        s/\b sbb \b/sbc/x;
        s/\b mov \b/ld/x;
        s/\b mvi \b/ld/x;
        s/\b cma \b/cpl/x;

        # --- register pair rewrites ---
        s/\b ldax \s+ (b|d|h|sp) \b/"ld a, (". rp_from_intel($1).")"   /xe;
        s/\b stax \s+ (b|d|h|sp) \b/"ld (".    rp_from_intel($1)."), a"/xe;
        s/\b inx  \s+ (b|d|h|sp) \b/"inc ".    rp_from_intel($1)       /xe;
        s/\b dcx  \s+ (b|d|h|sp) \b/"dec ".    rp_from_intel($1)       /xe;
        s/\b lxi  \s+ (b|d|h|sp) \b/"ld ".     rp_from_intel($1)       /xe;
        s/\b dad  \s+ (b|d|h|sp) \b/"add hl, ".rp_from_intel($1)       /xe;
        s/\b push \s+ (b|d|h|psw)\b/"push ".   rp_from_intel($1)       /xe;
        s/\b pop  \s+ (b|d|h|psw)\b/"pop ".    rp_from_intel($1)       /xe;
        s/\b shld \s+ %m         \b/ld (%m), hl/x;
        s/\b lhld \s+ %m         \b/ld hl, (%m)/x;
        s/\b dsub                \b/sub hl, bc/x;
        s/\b ldsi \s+ %n         \b/ld de, sp+%n/x;
        s/\b ldhi \s+ %n         \b/ld de, hl+%n/x;
        s/\b lhlde               \b/ld hl, (de)/x;
        s/\b shlde               \b/ld (de), hl/x;
        s/\b shlx                \b/ld (de), hl/x;
        s/\b lhlx                \b/ld hl, (de)/x;
        s/\b xchg                \b/ex de, hl/x;
        s/\b xthl                \b/ex (sp), hl/x;

        # --- memory operand rewrites ---
        s/\b ( (ld|add|adc|sub|sbc|and|xor|or|cp|cmp|inc|dec) .*? [^%] ) m \b/$1(hl)/x;

        # --- shifts and rotates ---
        s/\b arhl \b/sra hl/x;
        s/\b rdel \b/rl de/x;
        s/\b rlde \b/rl de/x;
        s/\b rrhl \b/sra hl/x;

        # --- flag condition rewrites ---
        s/\b j _? (nz|z|nc|c|po|pe|lz|lo|nv|v|  m|ne|eq|ltu|gtu|leu|geu|lt|gt|le|ge) \b/jp $1,/x;
        s/\b j _  (                           p                                    ) \b/jp p,/x;

        s/\b c _? (nz|z|nc|c|po|pe|lz|lo|nv|v|  m|ne|eq|ltu|gtu|leu|geu|lt|gt|le|ge) \b/call $1,/x;
        s/\b c _  (                           p                                    ) \b/call p,/x;

        s/\b r _? (nz|z|nc|c|po|pe|lz|lo|nv|v|p|m|ne|eq|ltu|gtu|leu|geu|lt|gt|le|ge) \b/ret $1/x;
    }
    return $asm;
}

sub rp_from_intel {
    my ($r) = @_;
    return 'bc' if $r eq 'b';
    return 'de' if $r eq 'd';
    return 'hl' if $r eq 'h';
    return 'af' if $r eq 'psw';
    return 'sp' if $r eq 'sp';
    die "unknown rp '$r'";
}

sub invert_flag {
    my ($f) = @_;
    return "c"   if $f eq "nc";
    return "nc"  if $f eq "c";
    return "z"   if $f eq "nz";
    return "nz"  if $f eq "z";
    return "po"  if $f eq "pe";
    return "pe"  if $f eq "po";
    return "p"   if $f eq "m";
    return "m"   if $f eq "p";
    return "lz"  if $f eq "lo";
    return "lo"  if $f eq "lz";
    return "nv"  if $f eq "v";
    return "v"   if $f eq "nv";
    return "le"  if $f eq "gt";
    return "gt"  if $f eq "le";
    return "leu" if $f eq "gtu";
    return "gtu" if $f eq "leu";
    return "lt"  if $f eq "ge";
    return "ge"  if $f eq "lt";
    return "ltu" if $f eq "geu";
    return "geu" if $f eq "ltu";
    die "unknown flag '$f'";
}

sub reg_pair {
    my ( $h, $l ) = @_;
    return "bc" if $h eq "b"   && $l eq "c";
    return "de" if $h eq "d"   && $l eq "e";
    return "hl" if $h eq "h"   && $l eq "l";
    return "ix" if $h eq "ixh" && $l eq "ixl";
    return "iy" if $h eq "iyh" && $l eq "iyl";
    die "unknown register pair '$h$l'";
}
