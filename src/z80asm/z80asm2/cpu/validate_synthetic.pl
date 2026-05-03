#!/usr/bin/env perl

#------------------------------------------------------------------------------
# Z80 assembler
# Copyright (C) Paulo Custodio, 2011-2026
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

use Modern::Perl;
use Test::More;
use Data::Dump 'dump';

@ARGV==1 or die "usage: $0 synthetic.dat\n";
my($synthetic_file) = @ARGV;

open(my $fh, "<", $synthetic_file) or die "open $synthetic_file: $!\n";
ok 1, "$synthetic_file open";

chomp(my $title = <$fh>);
is $title, "asm|cpu|synth", "title ok";

while (<$fh>) {
	chomp;
	my($asm, $cpu, $instr) = split /\|/, $_, 3;
	my @effect_synth = parse_effect($asm, $cpu);
	my @effect_real = map { parse_effect($_, $cpu) } split /;/, $instr;
	next;

	@effect_real = normalize_effects(@effect_real);
	align_temporaries(\@effect_synth, \@effect_real);
	
	is_deeply \@effect_synth, \@effect_real, "$asm | $cpu"
		or do {
			my $msg = join "\n",
				"$asm | $cpu | $instr",
				"Expected:",
				dump(\@effect_synth),
				"Got:",
				dump(\@effect_real);
			die "$msg\n";
		};
}

close($fh);
done_testing;

#------------------------------------------------------------------------------
# Convert assembly instruction to effects, including synthetic instructions
# {
#     type	=> 'inst',
#     opcode   => 'ld',
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
#         { type => 'cond', cond => 'c' },
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
    my $inst = parse_assembly($asm, $cpu);
	dump($asm, $inst);
	return;

	$inst = lower_operand_kinds();
	$inst = lower_emulated_ops($inst);
    $inst = lower_rabbit_prefixes($inst);
    $inst = lower_ez80_suffixes($inst);

    my @insts = lower_postinc($inst);
    @insts = map lower_addressing($_), @insts;

    return map opcode_to_effect( $_, $cpu ), @insts;
}

sub parse_assembly {
	my ( $asm, $cpu ) = @_;

	# text cleanup
	$asm = lc($asm);
    $asm =~ s/^\s+|\s+$//g;

	if ($asm =~ /^ (%t \d*) : $/x) {
		return { type => 'label', name => $1 };
	}

	my %prefixes = extract_prefixes( \$asm );
	my ( $opcode, $suffix ) = extract_opcode_and_suffix( \$asm, $cpu );
	my @opr = split /\s*,\s*/, $asm;
	add_default_a_register( \@opr, $opcode );
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

	my %prefixes = (altd => 0, alts => 0, io => undef);
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
		my ($opcode, $suffix) = ($1, $2);
		if ( $suffix =~ /^i[sl]$/ ) {
			$suffix = ( $cpu eq "ez80" ? "l" : "s" ) . $suffix;    # ix -> xix
		}
		elsif ( $suffix =~ /^[sl]$/ ) {
			$suffix .= ( $cpu eq "ez80" ? "il" : "is" );           # x -> xix
		}

		return ($opcode, $suffix);
	}

	if ($$asm_ref =~ s/^ (\w+) \b \s* //x) {
		return ($1, undef);
	}

	die "Failed to extract opcode and suffix from '$$asm_ref'";
}

sub add_default_a_register {
	my ( $args_ref, $opcode ) = @_;

	# add default a register for certain opcodes with only one operand
	if (@$args_ref == 1 && $opcode =~ /\b(add|adc|sub|sbc|and|or|xor|cp|cmp)\b/) {
		unshift @$args_ref, "a";
	}
}

sub parse_operand {
	my($opr) = @_;
	
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
		return { type => 'regpair', name => $1, alt => $2 ? 1 : 0, disp => $2, disp_offset => 0, 
		         width => undef };
	}

	if ( $opr =~ /^ (nz|z|nc|po|pe|p|m|nv|v|lz|lo|eq|ne|gtu|ltu|geu|leu|lt|gt|ge|le) $/x ) {
		return { type => 'cond', cond => $1 };
	}

	if ( $opr =~ /^ (c) ('?) $/x ) {	# C can be a register or a flag
		my $alt = $2 ? 1 : 0;
		return { type => $alt ? 'reg' : 'ident', name => $1, alt => $alt, width => undef };
	}

	if ( $opr =~ /^ \( (c) \) $/x ) {
		return { type => 'mem', base => $1, disp => undef, 
				 space => 'io', post => 0, width => undef };
	}

	if ( $opr =~ /^ \( (hl) ([id]?) \) $/x ) {
		return { type => 'mem', base => $1, disp => undef, space => 'io', 
				 post => $2 eq "i" ? 1 : $2 eq "d" ? -1 : 0, width => undef };
	}

	if ( $opr =~ /^ \( (bc|de|hl|sp|ix|iy) ([-+]?) \) $/x ) {
		return { type => 'mem', base => $1, disp => undef, space => 'mem', 
				 post => $2 eq '+' ? 1 : $2 eq '-' ? -1 : 0, width => undef };
	}

	if ( $opr =~ /^ \( (ix|iy) \) $/x ) {
		return { type => 'mem', base => $1, disp => undef, disp_offset => 0,
				 space => 'mem', post => 0, width => undef };
	}

	if ( $opr =~ /^ \( (ix|iy) \+ 1\) $/x ) {
		return { type => 'mem', base => $1, disp => undef, disp_offset => 1,
				 space => 'mem', post => 0, width => undef };
	}

	if ( $opr =~ /^ \( (ix|iy) \+ (%d) \) $/x ) {
		return { type => 'mem', base => $1, disp => $2, disp_offset => 0,
				 space => 'mem', post => 0, width => undef };
	}

	if ( $opr =~ /^ \( (ix|iy) \+ (%d) \+ 1 \) $/x ) {
		return { type => 'mem', base => $1, disp => $2, disp_offset => 1,
				 space => 'mem', post => 0, width => undef };
	}

	if ( $opr =~ /^ (%n|%d|%m|%j|%J|0|1|2) $/x ) {
		return { type => 'imm', value => $1, width => undef };
	}

	if ( $opr =~ /^ \( (%m) \) $/x ) {
		return { type => 'mem', base => undef, addr => $1, disp => undef, 
		         space => 'mem', width => undef };
	}

	if ( $opr =~ /^ \( (%m) \+ (1) \) $/x ) {
		return { type => 'mem', base => undef, addr => $1, disp => $2, 
		         space => 'mem', width => undef };
	}

	if ( $opr =~ /^ (%t\d*) $/x ) {
		return { type => 'labelref', value => $1, width => undef };
	}

	if ( $opr =~ /^ (__z80asm__\w+) $/x ) {
		return { type => 'symbol', name => $1 };
	}
	
	die "Failed to parse operand '$opr'";	
}





sub parse_effect_old {
	my($asm, $cpu) = @_;
	my $asm0 = $asm;
	
	my $prefix = "";
	my $suffix = "";

	# deduce post-increment and post-decrement effects
	my @post;
	if ($asm =~ s/\((\w+)([+-])\)/($1)/) {
		my($rp, $inc) = ($1, $2.$2);		# hl-- / hl++
		push @post, $rp.$inc;
		push @post, $rp.$inc if $asm =~ /ld \($rp\), \w\w|ld \w\w, \($rp\)/;	# ld (hl+), bc
	}
	if ($asm =~ s/\(hl([id])\)/(hl)/) {
		push @post, "hl".($1 eq "i" ? "++" : "--");	# hl-- / hl++
	}
	if ($asm =~ s/(ld)([id])(.*\((\w+)\))/$1$3/) {
		my($rp, $inc) = ($4, $2 eq "i" ? "++" : "--");	# hl-- / hl++
		push @post, $rp.$inc;
		push @post, $rp.$inc if $asm =~ /ld \($rp\), \w\w|ld \w\w, \($rp\)/;	# ld (hl+), bc
	}
	
	# replace indirect access by mem()
	$asm =~ s/\((.*?)\)/mem($1)/g;
	
	# replace mem by ioi/ioe
	if ($prefix =~ /(ioi|ioe)/) {
		my $io = $1;
		$asm =~ s/\bmem\b/$io/;
	}
	
	# get opcode and operands
	my($opc, @opr) = split /\s+|\s*,\s*/, $asm;
	
	# add ' if altd/alts/altsd
	if ($prefix =~ /\b(altd|altsd)\b/) {
		if (@opr == 1 && $opc =~ /\b(add|adc|sub|sbc|and|or|xor|cp|cmp)\b/) {
			unshift @opr, "a";
		}
		@opr == 1 || @opr == 2 or die "invalid number of operands";
		$opr[0] =~ s/\b(a|f|b|c|d|e|h|l|bc|de|hl)\b/$1'/;
	}
	if ($prefix =~ /\b(alts|altsd)\b/) {
		@opr == 2 or die "invalid number of operands";
		$opr[1] =~ s/\b(a|f|b|c|d|e|h|l|bc|de|hl)\b/$1'/;
	}
	
	# add suffix to operands
	if ($suffix) {
		for (@opr, @post) {
			s/(bc|de|hl|sp|ix|iy)/$1.$suffix/;
			s/(%m)/$1.$suffix/;
		}
	}
	
	# deduce effects
	my @effect;
	if ($opc eq "ld") {
		@opr == 2 or die "@opr";
		push @effect, "$opr[0]=$opr[1]";
	}
	elsif ($opc eq "clr") {
		@opr == 1 or die "@opr";
		push @effect, "$opr[0]=0";
	}
	elsif ($opc eq "ex") {
		@opr == 2 or die "@opr";
		@opr = sort @opr;
		if ($opr[0] eq "af" && $opr[1] eq "af") {
			$opr[1] = "af'";
		}
		push @effect, "$opr[0]<->$opr[1]";
	}
	elsif ($opc eq "adc") {
		unshift @opr, "a" if @opr == 1;
		push @effect, $opr[0]."+=".$opr[1]."+C";
	}
	elsif ($opc eq "add") {
		unshift @opr, "a" if @opr == 1;
		push @effect, $opr[0]."+=".$opr[1];
	}
	elsif ($opc eq "adi") {
		@opr == 2 or die "@opr";
		if ($opr[0] =~ /(hl|sp)/ && $opr[1] eq "%n") {
			push @effect, "de=$1+%n";
		}
		else {
			die "invalid adi operands @opr";
		}
	}
	elsif ($opc eq "sbc") {
		unshift @opr, "a" if @opr == 1;
		push @effect, $opr[0]."-=".$opr[1]."-C";
	}
	elsif ($opc eq "sub") {
		unshift @opr, "a" if @opr == 1;
		push @effect, $opr[0]."-=".$opr[1];
	}
	elsif ($opc eq "and") {
		unshift @opr, "a" if @opr == 1;
		push @effect, $opr[0]."&=".$opr[1];
	}
	elsif ($opc eq "or") {
		unshift @opr, "a" if @opr == 1;
		push @effect, $opr[0]."|=".$opr[1];
	}
	elsif ($opc eq "xor") {
		unshift @opr, "a" if @opr == 1;
		push @effect, $opr[0]."^=".$opr[1];
	}
	elsif ($opc =~ /\b(cp|cmp)\b/) {
		unshift @opr, "a" if @opr == 1;
		push @effect, $opr[0]."==".$opr[1];
	}
	elsif ($opc eq "inc") {
		@opr == 1 or die "@opr";
		push @effect, $opr[0]."++";
	}
	elsif ($opc eq "dec") {
		@opr == 1 or die "@opr";
		push @effect, $opr[0]."--";
	}
	elsif ($opc eq "push") {
		@opr == 1 or die "@opr";
		if ($opr[0] =~ /^(b|d|h|psw)$/) {
			push @effect, "save(".rp_from_intel($opr[0]).")";
		}
		else {
			push @effect, "save($opr[0])";
		}
	}
	elsif ($opc eq "pop") {
		@opr == 1 or die "@opr";
		if ($opr[0] =~ /^(b|d|h|psw)$/) {
			push @effect, "restore(".rp_from_intel($opr[0]).")";
		}
		else {
			push @effect, "restore($opr[0])";
		}
	}
	elsif ($opc eq "extern") {
		# ignore
	}
	elsif ($opc =~ /call3?/) {
		if (@opr == 2) {
			if ($opr[0] eq "eq") {
				push @effect, "$opc z, $opr[1]";
			}
			elsif ($opr[0] eq "ne") {
				push @effect, "$opc nz, $opr[1]";
			}
			elsif ($opr[0] eq "geu") {
				push @effect, "$opc nc, $opr[1]";
			}
			elsif ($opr[0] eq "ltu") {
				push @effect, "$opc c, $opr[1]";
			}
			elsif ($opr[0] eq "gtu") {
				push @effect, "jp z, %t";
				push @effect, "call nc, $opr[1]";
				push @effect, "%t:";
			}
			elsif ($opr[0] eq "leu") {
				push @effect, "jp z, %t3";
				push @effect, "jp nc, %t";
				push @effect, "%t3:";
				push @effect, "call $opr[1]";
				push @effect, "%t:";
			}
			elsif ($opr[0] =~ /^(lz|nv)$/) {
				push @effect, "call po, $opr[1]";
			}
			elsif ($opr[0] =~ /^(lo|v)$/) {
				push @effect, "call pe, $opr[1]";
			}
			else {
				push @effect, "$opc $opr[0], $opr[1]";
			}
		}
		else {
			@opr == 1 or die "@opr";
			if ($opr[0] =~ /__z80asm__adc_hl_(\w+)/) {
				push @effect, "hl+=$1+C";
			}
			elsif ($opr[0] =~ /__z80asm__add_(\w\w)_a/) {
				push @effect, "$1+=a";
			}
			elsif ($opr[0] =~ /__z80asm__add_sp_d/) {
				push @effect, "sp+=%d";
			}
			elsif ($opr[0] =~ /__z80asm__sra_hl/) {
				push @effect, "sra hl";
			}
			elsif ($opr[0] =~ /__z80asm__rl_(\w+)/) {
				push @effect, "rl $1";
			}
			elsif ($opr[0] =~ /__z80asm__rr_(\w+)/) {
				push @effect, "rr $1";
			}
			elsif ($opr[0] =~ /__z80asm__sra_(\w+)/) {
				push @effect, "sra $1";
			}
			elsif ($opr[0] =~ /__z80asm__call_(\w+)/) {
				push @effect, "call mem($1)";
			}
			elsif ($opr[0] =~ /__z80asm__(cpi|cpir|cpd|cpdr|ldi|ldir|ldd|lddr|daa|rld|rrd)$/) {
				push @effect, $1;
			}
			elsif ($opr[0] =~ /__z80asm__sub_hl_(\w+)/) {
				push @effect, "hl-=$1";
			}
			elsif ($opr[0] =~ /__z80asm__sbc_hl_(\w+)/) {
				push @effect, "hl-=$1-C";
			}
			elsif ($opr[0] =~ /__z80asm__ex_sp_hl/) {
				push @effect, "hl<->mem(sp)";
			}
			elsif ($opr[0] =~ /%m/) {
				push @effect, "call $opr[0]";
			}
			elsif ($opr[0] =~ /\(\w+\)/) {
				push @effect, "call $opr[0]";
			}
			else {
				die "unknown sub $opr[0]";
			}
		}
	}
	elsif ($opc =~ /^c_?(nc|c|nz|z|po|pe|m)$/) {
		@opr == 1 or die "@opr";
		push @effect, "call $1, $opr[0]";
	}
	elsif ($opc =~ /^c_(p)$/) {
		@opr == 1 or die "@opr";
		push @effect, "call $1, $opr[0]";
	}
	elsif ($opc =~ /^c_?eq$/) {
		@opr == 1 or die "@opr";
		push @effect, "call z, $opr[0]";
	}
	elsif ($opc =~ /^c_?ne$/) {
		@opr == 1 or die "@opr";
		push @effect, "call nz, $opr[0]";
	}
	elsif ($opc =~ /^c_?geu$/) {
		@opr == 1 or die "@opr";
		push @effect, "call nc, $opr[0]";
	}
	elsif ($opc =~ /^c_?ltu$/) {
		@opr == 1 or die "@opr";
		push @effect, "call c, $opr[0]";
	}
	elsif ($opc =~ /^c_?gtu$/) {
		@opr == 1 or die "@opr";
		push @effect, "jp z, %t";
		push @effect, "call nc, $opr[0]";
		push @effect, "%t:";
	}
	elsif ($opc =~ /^c_?leu$/) {
		@opr == 1 or die "@opr";
		push @effect, "jp z, %t3";
		push @effect, "jp nc, %t";
		push @effect, "%t3:";
		push @effect, "call $opr[0]";
		push @effect, "%t:";
	}
	elsif ($opc =~ /^c_?(lz|nv)$/) {
		@opr == 1 or die "@opr";
		push @effect, "call po, $opr[0]";
	}
	elsif ($opc =~ /^c_?(lo|v)$/) {
		@opr == 1 or die "@opr";
		push @effect, "call pe, $opr[0]";
	}
	elsif ($opc =~ /^(jr|jp|jmp|jp3|jre)$/) {
		if (@opr == 1) {
			push @effect, "jp $opr[0]";
		}
		else {
			@opr == 2 or die "@opr";
			if ($opr[0] eq "eq") {
				push @effect, "jp z, $opr[1]";
			}
			elsif ($opr[0] eq "ne") {
				push @effect, "jp nz, $opr[1]";
			}
			elsif ($opr[0] eq "geu") {
				push @effect, "jp nc, $opr[1]";
			}
			elsif ($opr[0] eq "ltu") {
				push @effect, "jp c, $opr[1]";
			}
			elsif ($opr[0] eq "gtu") {
				if ($cpu =~ /^r[456]k/) {	# r4k, r5k, r6k
					push @effect, "jp gtu, $opr[1]";	# r4k, r5k, r6k
				}
				else {
					push @effect, "jp z, %t";
					push @effect, "jp nc, $opr[1]";
					push @effect, "%t:";
				}
			}
			elsif ($opr[0] eq "leu") {
				if ($cpu =~ /^r[456]k/ && $opc !~ /^jre?/) {	# r4k, r5k, r6k
					push @effect, "jp gtu, %t";	# r4k, r5k, r6k
					push @effect, "jp $opr[1]";
					push @effect, "%t:";
				}
				elsif ($opc eq "jre") {
					push @effect, "jp z, %t3";
					push @effect, "jp c, %t3";
					push @effect, "jp %t";
					push @effect, "%t3:";
					push @effect, "jp %J";
					push @effect, "%t:";
				}
				else {
					push @effect, "jp z, $opr[1]";
					push @effect, "jp c, $opr[1]";
				}
			}
			elsif ($opr[0] =~ /^lz$/) {
				push @effect, "jp po, $opr[1]";
			}
			elsif ($opr[0] =~ /^nv$/) {
				if ($cpu =~ /^r[456]k/) {	# r4k, r5k, r6k
					push @effect, "jp v, %t";	# r4k, r5k, r6k
					push @effect, "jp $opr[1]";
					push @effect, "%t:";
				}
				else {
					push @effect, "jp po, $opr[1]";
				}
			}
			elsif ($opr[0] =~ /^lo$/) {
				push @effect, "jp pe, $opr[1]";
			}
			elsif ($opr[0] =~ /^v$/) {
				if ($cpu =~ /^r[456]k/) {	# r4k, r5k, r6k
					push @effect, "jp v, $opr[1]";	# r4k, r5k, r6k
				}
				else {
					push @effect, "jp pe, $opr[1]";
				}
			}
			elsif ($opr[0] =~ /^ge$/) {	# r4k, r5k, r6k
				push @effect, "jp lt, %t";	# r4k, r5k, r6k
				push @effect, "jp $opr[1]";
				push @effect, "%t:";
			}
			elsif ($opr[0] =~ /^le$/) {	# r4k, r5k, r6k
				push @effect, "jp gt, %t";	# r4k, r5k, r6k
				push @effect, "jp $opr[1]";
				push @effect, "%t:";
			}
			else {
				push @effect, "jp $opr[0], $opr[1]";
			}
		}
	}
	elsif ($opc eq "djnz") {
		unshift @opr, "b" if @opr == 1;
		@opr == 2 or die "@opr";
		push @effect, "djnz $opr[0], $opr[1]";
	}
	elsif ($opc =~ /^j_?(nc|c|nz|z|po|pe|m)$/) {
		@opr == 1 or die "@opr";
		push @effect, "jp $1, $opr[0]";
	}
	elsif ($opc =~ /^j_(p)$/) {
		@opr == 1 or die "@opr";
		push @effect, "jp $1, $opr[0]";
	}
	elsif ($opc =~ /^j_?eq$/) {
		@opr == 1 or die "@opr";
		push @effect, "jp z, $opr[0]";
	}
	elsif ($opc =~ /^j_?ne$/) {
		@opr == 1 or die "@opr";
		push @effect, "jp nz, $opr[0]";
	}
	elsif ($opc =~ /^j_?geu$/) {
		@opr == 1 or die "@opr";
		push @effect, "jp nc, $opr[0]";
	}
	elsif ($opc =~ /^j_?ltu$/) {
		@opr == 1 or die "@opr";
		push @effect, "jp c, $opr[0]";
	}
	elsif ($opc =~ /^j_?gtu$/) {
		@opr == 1 or die "@opr";
		if ($cpu =~ /^r[456]k/) {	# r4k, r5k, r6k
			push @effect, "jp gtu, $opr[0]";	# r4k, r5k, r6k
		}
		else {
			push @effect, "jp z, %t";
			push @effect, "jp nc, $opr[0]";
			push @effect, "%t:";
		}
	}
	elsif ($opc =~ /^j_?leu$/) {
		@opr == 1 or die "@opr";
		if ($cpu =~ /^r[456]k/) {	# r4k, r5k, r6k
			push @effect, "jp gtu, %t";	# r4k, r5k, r6k
			push @effect, "jp $opr[0]";
			push @effect, "%t:";
		}
		else {
			push @effect, "jp z, $opr[0]";
			push @effect, "jp c, $opr[0]";
		}
	}
	elsif ($opc =~ /^j_?lz$/) {
		@opr == 1 or die "@opr";
		push @effect, "jp po, $opr[0]";
	}
	elsif ($opc =~ /^j_?nv$/) {
		@opr == 1 or die "@opr";
		if ($cpu =~ /^r[456]k/) {	# r4k, r5k, r6k
			push @effect, "jp v, %t";	# r4k, r5k, r6k
			push @effect, "jp $opr[0]";
			push @effect, "%t:";
		}
		else {
			push @effect, "jp po, $opr[0]";
		}
	}
	elsif ($opc =~ /^j_?lo$/) {
		@opr == 1 or die "@opr";
		push @effect, "jp pe, $opr[0]";
	}
	elsif ($opc =~ /^j_?v$/) {
		@opr == 1 or die "@opr";
		if ($cpu =~ /^r[456]k/) {	# r4k, r5k, r6k
			push @effect, "jp v, $opr[0]";	# r4k, r5k, r6k
		}
		else {
			push @effect, "jp pe, $opr[0]";
		}
	}
	elsif ($opc =~ /^j_?ge$/) {	# r4k, r5k, r6k
		@opr == 1 or die "@opr";
		push @effect, "jp lt, %t";	# r4k, r5k, r6k
		push @effect, "jp $opr[0]";
		push @effect, "%t:";
	}
	elsif ($opc =~ /^j_?le$/) {	# r4k, r5k, r6k
		@opr == 1 or die "@opr";
		push @effect, "jp gt, %t";	# r4k, r5k, r6k
		push @effect, "jp $opr[0]";
		push @effect, "%t:";
	}
	elsif ($opc eq "ret") {
		if (@opr == 0) {
			push @effect, "ret";
		}
		elsif (@opr == 1) {
			if ($opr[0] eq "eq") {
				push @effect, "ret z";
			}
			elsif ($opr[0] eq "ne") {
				push @effect, "ret nz";
			}
			elsif ($opr[0] eq "geu") {
				push @effect, "ret nc";
			}
			elsif ($opr[0] eq "ltu") {
				push @effect, "ret c";
			}
			elsif ($opr[0] eq "gtu") {
				push @effect, "jp z, %t";
				push @effect, "ret nc";
				push @effect, "%t:";
			}
			elsif ($opr[0] eq "leu") {
				push @effect, "ret z";
				push @effect, "ret c";
			}
			elsif ($opr[0] =~ /^lz$/) {
				push @effect, "ret po";
			}
			elsif ($opr[0] =~ /^nv$/) {
				if ($cpu =~ /^r[456]k/) {	# r4k, r5k, r6k
					push @effect, "jp v, %t";	# r4k, r5k, r6k
					push @effect, "ret";
					push @effect, "%t:";
				}
				else {
					push @effect, "ret po";
				}
			}
			elsif ($opr[0] =~ /^lo$/) {
				push @effect, "ret pe";
			}
			elsif ($opr[0] =~ /^v$/) {
				if ($cpu =~ /^r[456]k/) {	# r4k, r5k, r6k
					push @effect, "jp v, %t1";	# r4k, r5k, r6k
					push @effect, "jp %t";
					push @effect, "%t1:";
					push @effect, "ret";
					push @effect, "%t:";
				}
				else {
					push @effect, "ret pe";
				}
			}
			elsif ($opr[0] =~ /^ge$/) {	# r4k, r5k, r6k
				push @effect, "jp lt, %t";	# r4k, r5k, r6k
				push @effect, "ret";
				push @effect, "%t:";
			}
			elsif ($opr[0] =~ /^le$/) {	# r4k, r5k, r6k
				push @effect, "jp gt, %t";	# r4k, r5k, r6k
				push @effect, "ret";
				push @effect, "%t:";
			}
			else {
				push @effect, "ret $opr[0]";
			}
		}
		else {
			die "@opr";
		}
	}
	elsif ($opc eq "ret3") {
		if (@opr == 0) {
			push @effect, "ret";
		}
		elsif (@opr == 1) {
			if ($opr[0] eq "eq") {
				push @effect, "jp nz, %t";
				push @effect, "ret";
				push @effect, "%t:";
			}
			elsif ($opr[0] eq "ne") {
				push @effect, "jp z, %t";
				push @effect, "ret";
				push @effect, "%t:";
			}
			elsif ($opr[0] eq "geu") {
				push @effect, "jp c, %t";
				push @effect, "ret";
				push @effect, "%t:";
			}
			elsif ($opr[0] eq "ltu") {
				push @effect, "jp nc, %t";
				push @effect, "ret";
				push @effect, "%t:";
			}
			elsif ($opr[0] eq "gtu") {
				push @effect, "jp z, %t";
				push @effect, "jp c, %t";
				push @effect, "ret";
				push @effect, "%t:";
			}
			elsif ($opr[0] eq "leu") {
				push @effect, "jp z, %t1";
				push @effect, "jp nc, %t";
				push @effect, "%t1:";
				push @effect, "ret";
				push @effect, "%t:";
			}
			elsif ($opr[0] =~ /^nv$/) {
				push @effect, "jp pe, %t";
				push @effect, "ret";
				push @effect, "%t:";
			}
			elsif ($opr[0] =~ /^v$/) {
				push @effect, "jp po, %t";
				push @effect, "ret";
				push @effect, "%t:";
			}
			else {
				push @effect, "jp ".invert_flag($opr[0]).", %t";
				push @effect, "ret";
				push @effect, "%t:";
			}
		}
		else {
			die "@opr";
		}
	}
	elsif ($opc =~ /^r_?(nc|c|nz|z|po|pe|p|m)$/) {
		@opr == 0 or die "@opr";
		push @effect, "ret $1";
	}
	elsif ($opc =~ /^r_?eq$/) {
		@opr == 0 or die "@opr";
		push @effect, "ret z";
	}
	elsif ($opc =~ /^r_?ne$/) {
		@opr == 0 or die "@opr";
		push @effect, "ret nz";
	}
	elsif ($opc =~ /^r_?geu$/) {
		@opr == 0 or die "@opr";
		push @effect, "ret nc";
	}
	elsif ($opc =~ /^r_?ltu$/) {
		@opr == 0 or die "@opr";
		push @effect, "ret c";
	}
	elsif ($opc =~ /^r_?gtu$/) {
		@opr == 0 or die "@opr";
		push @effect, "jp z, %t";
		push @effect, "ret nc";
		push @effect, "%t:";
	}
	elsif ($opc =~ /^r_?leu$/) {
		@opr == 0 or die "@opr";
		push @effect, "ret z";
		push @effect, "ret c";
	}
	elsif ($opc =~ /^r_?lz$/) {
		@opr == 0 or die "@opr";
		push @effect, "ret po";
	}
	elsif ($opc =~ /^r_?nv$/) {
		@opr == 0 or die "@opr";
		if ($cpu =~ /^r[456]k/) {	# r4k, r5k, r6k
			push @effect, "jp v, %t";	# r4k, r5k, r6k
			push @effect, "ret";
			push @effect, "%t:";
		}
		else {
			push @effect, "ret po";
		}
	}
	elsif ($opc =~ /^r_?lo$/) {
		@opr == 0 or die "@opr";
		push @effect, "ret pe";
	}
	elsif ($opc =~ /^r_?v$/) {
		@opr == 0 or die "@opr";
		if ($cpu =~ /^r[456]k/) {	# r4k, r5k, r6k
			push @effect, "jp v, %t1";	# r4k, r5k, r6k
			push @effect, "jp %t";
			push @effect, "%t1:";
			push @effect, "ret";
			push @effect, "%t:";
		}
		else {
			push @effect, "ret pe";
		}
	}
	elsif ($opc =~ /%t\d*:/) {
		@opr == 0 or die "@opr";
		push @effect, $opc;
	}
	elsif ($opc =~ /^(rl|rr|rlc|rrc|sll|srl|sra)$/) {
		@opr == 1 or die "@opr";
		push @effect, "$opc $opr[0]";
	}
	elsif ($opc eq "bool") {
		@opr == 1 or die "@opr";
		my $reg = $opr[0];
		push @effect, "$reg=$reg?1:0";
	}
	elsif ($opc eq "exx") {
		@opr == 0 or die "@opr";
		push @effect, $opc;
	}
	elsif ($opc eq "neg") {
		if (@opr == 0) {
			push @effect, "a=-a";
		}
		elsif (@opr == 1) {
			push @effect, "$opr[0]=-$opr[0]";
		}
		else {
			die "@opr";
		}
	}
	elsif ($opc eq "cpl") {
		if (@opr == 0) {
			push @effect, "a=~a";
		}
		elsif (@opr == 1) {
			push @effect, "$opr[0]=~$opr[0]";
		}
		else {
			die "@opr";
		}
	}
	elsif ($opc =~ /^(cpi|cpir|cpd|cpdr|ldi|ldir|ldd|lddr|daa|rld|rrd)$/) {
		@opr == 0 or die "@opr";
		push @effect, $opc;
	}
	elsif ($opc eq "defb") {
		@opr == 1 or die "@opr";
		push @effect, "$opc $opr[0]";
	}
	else {
		die "invalid opcode $opc in $asm0";
	}
	
	return (@effect, @post);
}

sub normalize_effects {
	my(@effect) = @_;
	
	my $repeat;
	do {
		$repeat = 0;
		
		# ["b=h", "c=l"]->["bc=hl"]
		for (my $i = 0; $i+1 < @effect; $i++) {
			if ($effect[$i] =~ /^[bdh]'?=[bdh]$/ && 
				$effect[$i+1] =~ /^[cel]'?=[cel]$/) {
				my($dest_h, $tick_h, $src_h) = $effect[$i] =~ /(\w)('?)=(\w)/;
				my($dest_l, $tick_l, $src_l) = $effect[$i+1] =~ /(\w)('?)=(\w)/;
				$tick_h eq $tick_l or die;
				splice(@effect, $i, 2, "$dest_h$dest_l$tick_h=$src_h$src_l");
				$i--;
				$repeat++;
			}
		}
		
		# ["save(hl)", "save(de)", "restore(hl)", "restore(de)"]->["de<->hl"]
		for (my $i = 0; $i+3 < @effect; $i++) {
			if ($effect[$i] =~ /save\((\w+)\)/) {
				my $rp1 = $1;
				if ($effect[$i+1] =~ /save\((\w+)\)/) {
					my $rp2 = $1;
					if ($effect[$i+2] =~ /restore\($rp1\)/ &&
						$effect[$i+3] =~ /restore\($rp2\)/) {
						($rp1, $rp2) = sort($rp1, $rp2);
						splice(@effect, $i, 4, "$rp1<->$rp2");
						$i--;
						$repeat++;
					}
				}	
			}
		}
		
		# ["save(hl)", "hl=%m", "hl+=bc", "bc=hl", "restore(hl)"]->["bc+=%m"]
		for (my $i = 0; $i+4 < @effect; $i++) {
			if ($effect[$i] =~ /save\((\w+)\)/) {
				my $scratch = $1;
				if ($effect[$i+1] =~ /$scratch=(.*)/) {
					my $expr = $1;
					if ($effect[$i+2] =~ /$scratch\+=(\w+)/) {
						my $reg = $1;
						if ($effect[$i+3] =~ /$reg=$scratch/ && 
							$effect[$i+4] =~ /restore\($scratch\)/) {
							splice(@effect, $i, 5, "$reg+=$expr");
							$i--;
							$repeat++;
						}
					}
				}
			}
		}
		
		# ["save(de)", "de=%m", "hl+=de", "restore(de)"]->["hl+=%m"]
		for (my $i = 0; $i+3 < @effect; $i++) {
			if ($effect[$i] =~ /save\((\w+)\)/) {
				my $scratch = $1;
				if ($effect[$i+1] =~ /$scratch=(.*)/) {
					my $expr = $1;
					if ($effect[$i+2] =~ /(\w+)\+=$scratch/) {
						my $reg = $1;
						if ($effect[$i+3] =~ /restore\($scratch\)/) {
							splice(@effect, $i, 4, "$reg+=$expr");
							$i--;
							$repeat++;
						}
					}
				}
			}
		}
		
		# ["save(hl)", "de=%n", "hl+=de", "de<->hl", "restore(hl)"]->["de=hl+%n"]
		for (my $i = 0; $i+4 < @effect; $i++) {
			if ($effect[$i] =~ /save\(hl\)/ &&
				$effect[$i+1] =~ /de=(.*)/) {
				my $expr = $1;
				if ($effect[$i+2] =~ /hl\+=de/ && 
					$effect[$i+3] =~ /de<->hl/ && 
					$effect[$i+4] =~ /restore\(hl\)/) {
					splice(@effect, $i, 5, "de=hl+$expr");
					$i--;
					$repeat++;
				}
			}
		}
		
		# ["de<->hl", "hl=%n", "hl+=sp", "de<->hl"]->["de=sp+%n"]
		for (my $i = 0; $i+3 < @effect; $i++) {
			if ($effect[$i] =~ /de<->hl/ &&
				$effect[$i+1] =~ /hl=(.*)/) {
				my $expr = $1;
				if ($effect[$i+2] =~ /hl\+=sp/ && 
					$effect[$i+3] =~ /de<->hl/) {
					$expr = "+$expr";
					$expr =~ s/\+0//;
					splice(@effect, $i, 4, "de=sp$expr");
					$i--;
					$repeat++;
				}
			}
		}
		
		# ["save(af)","a=h","a&=b","h=a","a=l","a&=c","l=a","restore(af)"]->["hl&=bc"]
		for (my $i = 0; $i+7 < @effect; $i++) {
			if ($effect[$i] =~ /save\(af\)/ &&
				$effect[$i+1] =~ /a=(\w)\b/) {
				my $rp1_h = $1;
				if ($effect[$i+2] =~ /a([&|^]=)(\w)\b/) {
					my($op1, $rp2_h) = ($1, $2);
					if ($effect[$i+3] =~ /$rp1_h=a/ &&
						$effect[$i+4] =~ /a=(\w)\b/) {
						my $rp1_l = $1;
						if ($effect[$i+5] =~ /a([&|^]=)(\w)\b/) {
							my($op2, $rp2_l) = ($1, $2);
							if ($op1 eq $op2 &&
								$effect[$i+6] =~ /$rp1_l=a/ &&
								$effect[$i+7] =~ /restore\(af\)/) {
								splice(@effect, $i, 8, "$rp1_h$rp1_l$op1$rp2_h$rp2_l");
								$i--;
								$repeat++;
							}
						}
					}
				}
			}
		}
		for (my $i = 0; $i+7 < @effect; $i++) {
			if ($effect[$i] =~ /save\(af\)/ &&
				$effect[$i+1] =~ /a=(ix|iy)h\b/) {
				my $rp1 = $1;
				if ($effect[$i+2] =~ /a([&|^]=)(\w)\b/) {
					my($op1, $rp2_h) = ($1, $2);
					if ($effect[$i+3] =~ /${rp1}h=a/ &&
						$effect[$i+4] =~ /a=${rp1}l\b/) {
						if ($effect[$i+5] =~ /a([&|^]=)(\w)\b/) {
							my($op2, $rp2_l) = ($1, $2);
							if ($op1 eq $op2 &&
								$effect[$i+6] =~ /${rp1}l=a/ &&
								$effect[$i+7] =~ /restore\(af\)/) {
								splice(@effect, $i, 8, "$rp1$op1$rp2_h$rp2_l");
								$i--;
								$repeat++;
							}
						}
					}
				}
			}
		}
		
		# ["sp+=%d", "defb %d"]->["sp+=%d"]
		for (my $i = 0; $i+1 < @effect; $i++) {
			if ($effect[$i] =~ /sp\+=%d/ && 
				$effect[$i+1] =~ /defb %d/) {
				splice(@effect, $i, 2, "sp+=%d");
				$i--;
				$repeat++;
			}
		}
		
		# ["sra h", "rr l"]->["sra hl"]
		for (my $i = 0; $i+1 < @effect; $i++) {
			if ($effect[$i] =~ /sra (\w)\b/) {
				my $h = $1;
				if ($effect[$i+1] =~ /rr (\w)\b/) {
					my $l = $1;
					splice(@effect, $i, 2, "sra $h$l");
					$i--;
					$repeat++;
				}
			}
		}
		
		# ["save(af)","a=h","a|=l","jp z, %t1","hl=1","%t1:","restore(af)"]->["hl=hl?1:0"]
		for (my $i = 0; $i+6 < @effect; $i++) {
			if ($effect[$i] =~ /save\(af\)/ &&
				$effect[$i+1] =~ /a=(\w)\b/) {
				my $h = $1;
				if ($effect[$i+2] =~ /a\|=(\w)\b/) {
					my $l = $1;
					if ($effect[$i+3] =~ /jp z, %t1/ &&
						$effect[$i+4] =~ /$h$l=1/ &&
						$effect[$i+5] =~ /%t1:/ &&
						$effect[$i+6] =~ /restore\(af\)/) {
						splice(@effect, $i, 7, "$h$l=$h$l?1:0");
						$i--;
						$repeat++;
					}
				}
			}
		}
		for (my $i = 0; $i+6 < @effect; $i++) {
			if ($effect[$i] =~ /save\(af\)/ &&
				$effect[$i+1] =~ /a=(ix|iy)h/) {
				my $x = $1;
				if ($effect[$i+2] =~ /a\|=${x}l\b/ &&
					$effect[$i+3] =~ /jp z, %t1/ &&
					$effect[$i+4] =~ /$x=1/ &&
					$effect[$i+5] =~ /%t1:/ &&
					$effect[$i+6] =~ /restore\(af\)/) {
					splice(@effect, $i, 7, "$x=$x?1:0");
					$i--;
					$repeat++;
				}
			}
		}

		# ["save(af)","save(hl)","save(ix)","restore(hl)",
		#  "a=h","a|=l","jp z, %t2","ix=1",
		#  "%t2:","restore(hl)","restore(af)"]->["ix=ix?1:0"]
		for (my $i = 0; $i+10 < @effect; $i++) {
			if ($effect[$i] =~ /save\(af\)/ &&
				$effect[$i+1] =~ /save\(hl\)/ &&
				$effect[$i+2] =~ /save\((ix|iy)\)/) {
				my $x = $1;
				if ($effect[$i+3] =~ /restore\(hl\)/ && 
					$effect[$i+4] =~ /a=h/ &&
					$effect[$i+5] =~ /a\|=l/ &&
					$effect[$i+6] =~ /jp z, %t2/ &&
					$effect[$i+7] =~ /$x=1/ &&
					$effect[$i+8] =~ /%t2:/ &&
					$effect[$i+9] =~ /restore\(hl\)/ &&
					$effect[$i+10] =~ /restore\(af\)/) {
					splice(@effect, $i, 11, "$x=$x?1:0");
					$i--;
					$repeat++;
				}
			}
		}

		# ["jp nc, %t", "call %m", "%t:"]->["call c, %m"]
		for (my $i = 0; $i+2 < @effect; $i++) {
			if ($effect[$i] =~ /jp (nc|c|nz|z|po|pe|p|m), %t$/) {
				my $f = $1;
				if ($effect[$i+1] =~ /call %m/ &&
					$effect[$i+2] =~ /%t:/) {
					splice(@effect, $i, 3, "call ".invert_flag($f).", %m");
					$i--;
					$repeat++;
					if (grep {/%t$/} @effect) {		# two jumps to end
						push @effect, "%t:";
					}
				}
			}
		}
			
		# ["jp v, %t", "call %m", "%t:"]->["call po, %m"]
		for (my $i = 0; $i+2 < @effect; $i++) {
			if ($effect[$i] =~ /jp v, %t$/ &&
				$effect[$i+1] =~ /call %m/ &&
				$effect[$i+2] =~ /%t:/) {
				splice(@effect, $i, 3, "call po, %m");
				$i--;
				$repeat++;
				if (grep {/%t$/} @effect) {		# two jumps to end
					push @effect, "%t:";
				}
			}
		}

		# no nv flag in Rabbits, hence double jump
		# ["jp v, %t3", "jp %t", "%t3:", "call %m", "%t:"]->["call pe, %m"]
		for (my $i = 0; $i+4 < @effect; $i++) {
			if ($effect[$i] =~ /jp v, (%t\d)$/) {
				my $call_label = $1;
				if ($effect[$i+1] =~ /jp %t$/ &&
					$effect[$i+2] =~ /$call_label:/ &&
					$effect[$i+3] =~ /call %m/ &&
					$effect[$i+4] =~ /%t:/) {
					splice(@effect, $i, 5, "call pe, %m");
					$i--;
					$repeat++;
					if (grep {/%t$/} @effect) {		# two jumps to end
						push @effect, "%t:";
					}
				}
			}
		}

		# ["b--", "jp nz, %m"]->["djnz %j"]
		for (my $i = 0; $i+1 < @effect; $i++) {
			if ($effect[$i] =~ /b--/ &&
				$effect[$i+1] =~ /jp nz, (%m|%j)/) {
				splice(@effect, $i, 2, "djnz b, %j");
				$i--;
				$repeat++;
			}
		}

		# ["save(bc)", "ret"]->["jp mem(bc)"]
		for (my $i = 0; $i+1 < @effect; $i++) {
			if ($effect[$i] =~ /save\((\w+)\)/) {
				my $reg = $1;
				if ($effect[$i+1] =~ /ret/) {
					splice(@effect, $i, 2, "jp mem($reg)");
					$i--;
					$repeat++;
				}
			}
		}

		# ["save(hl)", "hl=bc", "mem(%m)=hl", "restore(hl)"]->["mem(%m)=bc"]
		for (my $i = 0; $i+3 < @effect; $i++) {
			if ($effect[$i] =~ /save\(hl\)/ &&
				$effect[$i+1] =~ /hl=(\w+)/) {
				my $reg = $1;
				if ($effect[$i+2] =~ /mem\(%m\)=hl/ &&
					$effect[$i+3] =~ /restore\(hl\)/) {
					splice(@effect, $i, 4, "mem(%m)=$reg");
					$i--;
					$repeat++;
				}
			}
		}

		# ["save(af)","a=c","mem(%m)=a","a=b","mem(%m+1)=a","restore(af)"]->["mem(%m)=bc"]
		for (my $i = 0; $i+5 < @effect; $i++) {
			if ($effect[$i] =~ /save\(af\)/ &&
				$effect[$i+1] =~ /a=(\w)$/) {
				my $l = $1;
				if ($effect[$i+2] =~ /mem\(%m\)=a/ &&
					$effect[$i+3] =~ /a=(\w)$/) {
					my $h = $1;
					if ($effect[$i+4] =~ /mem\(%m\+1\)=a/ &&
						$effect[$i+5] =~ /restore\(af\)/) {
						splice(@effect, $i, 6, "mem(%m)=$h$l");
						$i--;
						$repeat++;
					}
				}
			}
		}

		# ["de<->hl", "mem(%m)=hl", "de<->hl"]->["mem(%m)=de"]
		for (my $i = 0; $i+2 < @effect; $i++) {
			if ($effect[$i] =~ /de<->hl/ &&
				$effect[$i+1] =~ /mem\(%m\)=hl/ &&
				$effect[$i+2] =~ /de<->hl/) {
				splice(@effect, $i, 3, "mem(%m)=de");
				$i--;
				$repeat++;
			}
		}
		
		# ["save(hl)", "hl=2", "hl+=sp", "mem(%m)=hl", "restore(hl)"]->["mem(%m)=sp"]
		for (my $i = 0; $i+4 < @effect; $i++) {
			if ($effect[$i] =~ /save\(hl\)/ &&
				$effect[$i+1] =~ /hl=2/ &&
				$effect[$i+2] =~ /hl\+=sp/ &&
				$effect[$i+3] =~ /mem\(%m\)=hl/ &&
				$effect[$i+4] =~ /restore\(hl\)/) {
				splice(@effect, $i, 5, "mem(%m)=sp");
				$i--;
				$repeat++;
			}
		}
		
		# ["de<->hl", "mem(hl)=%n", "de<->hl"]->["mem(de)=%n"]
		for (my $i = 0; $i+2 < @effect; $i++) {
			if ($effect[$i] =~ /de<->hl/ &&
				$effect[$i+1] =~ /mem\(hl(\.(?:lis|sil))?\)=(.*)/) {
				my($suffix, $arg) = ($1, $2);
				$arg =~ tr/dehl/hlde/;
				if ($effect[$i+2] =~ /de<->hl/) {
					splice(@effect, $i, 3, "mem(de$suffix)=$arg");
					$i--;
					$repeat++;
				}
			}
		}
		
		# ["de<->hl", "e=mem(hl)", "hl++", "d=mem(hl)", "hl--", "de<->hl"]->["hl=mem(de)"]
		for (my $i = 0; $i+5 < @effect; $i++) {
			if ($effect[$i] =~ /de<->hl/ &&
				$effect[$i+1] =~ /(\w)=mem\(hl\)/) {
				my $l = $1;
				$l =~ tr/dehl/hlde/;
				if ($effect[$i+2] =~ /hl\+\+/ &&
					$effect[$i+3] =~ /(\w)=mem\(hl\)/) {
					my $h = $1;
					$h =~ tr/dehl/hlde/;
					if ($effect[$i+4] =~ /hl--/ &&
						$effect[$i+5] =~ /de<->hl/) {
						splice(@effect, $i, 6, "$h$l=mem(de)");
						$i--;
						$repeat++;
					}
				}
			}
		}
		
		# ["save(af)","a=mem(hl)","hl++","h=mem(hl)","l=a","restore(af)"]->["hl=mem(hl)"]
		for (my $i = 0; $i+5 < @effect; $i++) {
			if ($effect[$i] =~ /save\(af\)/ &&
				$effect[$i+1] =~ /a=mem\(hl\)/ &&
				$effect[$i+2] =~ /hl\+\+/ &&
				$effect[$i+3] =~ /h=mem\(hl\)/ &&
				$effect[$i+4] =~ /l=a/ &&
				$effect[$i+5] =~ /restore\(af\)/) {
				splice(@effect, $i, 6, "hl=mem(hl)");
				$i--;
				$repeat++;
			}
		}
		
		# ["de<->hl", "b=mem(hl)", "de<->hl"]->["b=mem(de)"]
		for (my $i = 0; $i+2 < @effect; $i++) {
			if ($effect[$i] =~ /de<->hl/ &&
				$effect[$i+1] =~ /(\w)=mem\(hl(\.(?:lis|sil))?\)/) {
				my($r, $suffix) = ($1, $2);
				$r =~ tr/dehl/hlde/;
				if ($effect[$i+2] =~ /de<->hl/) {
					splice(@effect, $i, 3, "$r=mem(de$suffix)");
					$i--;
					$repeat++;
				}
			}
		}
		
		# ["de<->hl", "mem(hl)=e", "hl++", "mem(hl)=d", "hl--", "de<->hl"]->["mem(de)=hl"]
		for (my $i = 0; $i+5 < @effect; $i++) {
			if ($effect[$i] =~ /de<->hl/ &&
				$effect[$i+1] =~ /mem\(hl\)=e/ &&
				$effect[$i+2] =~ /hl\+\+/ &&
				$effect[$i+3] =~ /mem\(hl\)=d/ &&
				$effect[$i+4] =~ /hl--/ &&
				$effect[$i+5] =~ /de<->hl/) {
				splice(@effect, $i, 6, "mem(de)=hl");
				$i--;
				$repeat++;
			}
		}
		
		# ["mem(hl)=c", "hl++", "mem(hl)=b", "hl--"]->["mem(hl)=bc"]
		for (my $i = 0; $i+3 < @effect; $i++) {
			if ($effect[$i] =~ /mem\(hl\)=(\w)$/) {
				my $l = $1;
				if ($effect[$i+1] =~ /hl\+\+/ &&
					$effect[$i+2] =~ /mem\(hl\)=(\w)$/) {
					my $h = $1;
					if ($effect[$i+3] =~ /hl--/) {
						splice(@effect, $i, 4, "mem(hl)=$h$l");
						$i--;
						$repeat++;
					}
				}
			}
		}
		
		# ["save(af)","a=h","mem(hl)=l","hl++","mem(hl)=a","restore(af)","hl--"]->["mem(hl)=hl"]
		for (my $i = 0; $i+6 < @effect; $i++) {
			if ($effect[$i] =~ /save\(af\)/ &&
				$effect[$i+1] =~ /a=h/ && 
				$effect[$i+2] =~ /mem\(hl\)=l/ &&
				$effect[$i+3] =~ /hl\+\+/ &&
				$effect[$i+4] =~ /mem\(hl\)=a/ &&
				$effect[$i+5] =~ /restore\(af\)/ &&
				$effect[$i+6] =~ /hl--/) {
				splice(@effect, $i, 7, "mem(hl)=hl");
				$i--;
				$repeat++;
			}
		}
		
		# ["save(af)","a=h","mem(hl)=l","hl++","mem(hl)=a","restore(af)","hl++"]->["mem(hl)=hl", "hl++", "hl++"]
		for (my $i = 0; $i+6 < @effect; $i++) {
			if ($effect[$i] =~ /save\(af\)/ &&
				$effect[$i+1] =~ /a=h/ && 
				$effect[$i+2] =~ /mem\(hl\)=l/ &&
				$effect[$i+3] =~ /hl\+\+/ &&
				$effect[$i+4] =~ /mem\(hl\)=a/ &&
				$effect[$i+5] =~ /restore\(af\)/ &&
				$effect[$i+6] =~ /hl\+\+/) {
				splice(@effect, $i, 7, "mem(hl)=hl", "hl++", "hl++");
				$i--;
				$repeat++;
			}
		}
		
		# ["save(de)","de=ix","mem(hl)=de","restore(de)"]->["mem(hl)=ix"]
		for (my $i = 0; $i+3 < @effect; $i++) {
			if ($effect[$i] =~ /save\(de\)/ &&
				$effect[$i+1] =~ /de=(ix|iy)/) {
				my $x = $1;
				if ($effect[$i+2] =~ /mem\(hl\)=de/ &&
					$effect[$i+3] =~ /restore\(de\)/) {
					splice(@effect, $i, 4, "mem(hl)=$x");
					$i--;
					$repeat++;
				}
			}
		}
		
		# ["save(de)","de=ix","mem(hl)=de","hl++","hl++","restore(de)"]
		# ->["mem(hl)=ix", "hl++", "hl++"]
		for (my $i = 0; $i+5 < @effect; $i++) {
			if ($effect[$i] =~ /save\(de\)/ &&
				$effect[$i+1] =~ /de=(ix|iy)/) {
				my $x = $1;
				if ($effect[$i+2] =~ /mem\(hl\)=de/ &&
					$effect[$i+3] =~ /hl\+\+/ &&
					$effect[$i+4] =~ /hl\+\+/ &&
					$effect[$i+5] =~ /restore\(de\)/) {
					splice(@effect, $i, 6, "mem(hl)=$x", "hl++", "hl++");
					$i--;
					$repeat++;
				}
			}
		}
		
		# ["mem(hl)=c", "hl++", "mem(hl)=b", "hl++"]->["mem(hl)=bc", "hl++", "hl++"]
		for (my $i = 0; $i+3 < @effect; $i++) {
			if ($effect[$i] =~ /mem\(hl\)=(\w)$/) {
				my $l = $1;
				if ($effect[$i+1] =~ /hl\+\+/ &&
					$effect[$i+2] =~ /mem\(hl\)=(\w)$/) {
					my $h = $1;
					if ($effect[$i+3] =~ /hl\+\+/) {
						splice(@effect, $i, 4, "mem(hl)=$h$l", "hl++", "hl++");
						$i--;
						$repeat++;
					}
				}
			}
		}
		
		# ["save(ix)","hl<->mem(sp)","mem(ix)=hl","hl<->mem(sp)","restore(ix)"]
		# ->["mem(ix)=ix"]
		for (my $i = 0; $i+4 < @effect; $i++) {
			if ($effect[$i] =~ /save\((\w+)\)/) {
				my $x1 = $1;
				if ($effect[$i+1] =~ /hl<->mem\(sp\)/ &&
					$effect[$i+2] =~ /mem\((ix|iy)\)=hl$/) {
					my $x2 = $1;
					if ($effect[$i+3] =~ /hl<->mem\(sp\)/ &&
						$effect[$i+4] =~ /restore\($x1\)/) {
						splice(@effect, $i, 5, "mem($x2)=$x1");
						$i--;
						$repeat++;
					}
				}
			}
		}

		# ["save(ix)","hl<->mem(sp)","mem(ix+%d)=hl","hl<->mem(sp)","restore(ix)"] 
		# ->["mem(ix+%d)=ix"]
		for (my $i = 0; $i+4 < @effect; $i++) {
			if ($effect[$i] =~ /save\((\w+)\)/) {
				my $x1 = $1;
				if ($effect[$i+1] =~ /hl<->mem\(sp\)/ &&
					$effect[$i+2] =~ /mem\((ix|iy)\+%d\)=hl$/) {
					my $x2 = $1;
					if ($effect[$i+3] =~ /hl<->mem\(sp\)/ &&
						$effect[$i+4] =~ /restore\($x1\)/) {
						splice(@effect, $i, 5, "mem($x2+%d)=$x1");
						$i--;
						$repeat++;
					}
				}
			}
		}

		# ["mem(ix)=c", "mem(ix+1)=b"]->["mem(ix)=bc"]
		for (my $i = 0; $i+1 < @effect; $i++) {
			if ($effect[$i] =~ /mem\((\w+)\)=(\w)$/) {
				my($x, $l) = ($1, $2);
				if ($effect[$i+1] =~ /mem\($x\+1\)=(\w)$/) {
					my $h = $1;
					splice(@effect, $i, 2, "mem($x)=$h$l");
					$i--;
					$repeat++;
				}
			}
		}
		
		# ["mem(ix+%d)=c", "mem(ix+%d+1)=b"]->["mem(ix+%d)=bc"]
		for (my $i = 0; $i+1 < @effect; $i++) {
			if ($effect[$i] =~ /mem\((\w+)\+%d\)=(\w)$/) {
				my($x, $l) = ($1, $2);
				if ($effect[$i+1] =~ /mem\($x\+%d\+1\)=(\w)$/) {
					my $h = $1;
					splice(@effect, $i, 2, "mem($x+%d)=$h$l");
					$i--;
					$repeat++;
				}
			}
		}

		# ["exx", "bc=de", "exx"]->["bc'=de'"]
		for (my $i = 0; $i+2 < @effect; $i++) {
			if ($effect[$i] =~ /exx/ &&
				$effect[$i+1] =~ /(\w+)=(\w+)/) {
				my($a, $b) = ($1, $2);
				if ($effect[$i+2] =~ /exx/) {
					splice(@effect, $i, 3, "$a'=$b'");
					$i--;
					$repeat++;
				}
			}
		}
		
		# ["save(ix)", "restore(bc')"]->["bc'=ix"]
		for (my $i = 0; $i+1 < @effect; $i++) {
			if ($effect[$i] =~ /save\((ix|iy)\)/) {
				my $x = $1;
				if ($effect[$i+1] =~ /restore\((\w+'?)\)/) {
					my $a = $1;
					splice(@effect, $i, 2, "$a=$x");
					$i--;
					$repeat++;
				}
			}
		}
		
		# ["save(bc)", "restore(ix)"]->["ix=bc"]
		for (my $i = 0; $i+1 < @effect; $i++) {
			if ($effect[$i] =~ /save\((\w+)\)/) {
				my $b = $1;
				if ($effect[$i+1] =~ /restore\((\w+)\)/) {
					my $a = $1;
					splice(@effect, $i, 2, "$a=$b");
					$i--;
					$repeat++;
				}
			}
		}
		
		# ["save(hl)", "hl=mem(%m)", "bc=hl", "restore(hl)"]->["bc=mem(%m)"]
		for (my $i = 0; $i+3 < @effect; $i++) {
			if ($effect[$i] =~ /save\(hl\)/ &&
				$effect[$i+1] =~ /hl=mem\(%m\)/ &&
				$effect[$i+2] =~ /(\w+)=hl/) {
				my $rp = $1;
				if ($effect[$i+3] =~ /restore\(hl\)/) {
					splice(@effect, $i, 4, "$rp=mem(%m)");
					$i--;
					$repeat++;
				}
			}
		}

		# ["save(af)","a=mem(%m)","c=a","a=mem(%m+1)","b=a","restore(af)"]->["bc=mem(%m)"]
		for (my $i = 0; $i+5 < @effect; $i++) {
			if ($effect[$i] =~ /save\(af\)/ &&
				$effect[$i+1] =~ /a=mem\(%m\)/ &&
				$effect[$i+2] =~ /(\w)=a/) {
				my $l = $1;
				if ($effect[$i+3] =~ /a=mem\(%m\+1\)/ &&
					$effect[$i+4] =~ /(\w)=a/) {
					my $h = $1;
					if ($effect[$i+5] =~ /restore\(af\)/) {
						splice(@effect, $i, 6, "$h$l=mem(%m)");
						$i--;
						$repeat++;
					}
				}
			}
		}
		
		# ["c=mem(hl)", "hl++", "b=mem(hl)", "hl--"]->["bc=mem(hl)"]
		for (my $i = 0; $i+3 < @effect; $i++) {
			if ($effect[$i] =~ /(\w)=mem\(hl\)/) {
				my $l = $1;
				if ($effect[$i+1] =~ /hl\+\+/ &&
					$effect[$i+2] =~ /(\w)=mem\(hl\)/) {
					my $h = $1;
					if ($effect[$i+3] =~ /hl--/) {
						splice(@effect, $i, 4, "$h$l=mem(hl)");
						$i--;
						$repeat++;
					}
				}
			}
		}
		
		# ["c=mem(hl)", "hl++", "b=mem(hl)", "hl++"]->["bc=mem(hl)", "hl++", "hl++"]
		for (my $i = 0; $i+3 < @effect; $i++) {
			if ($effect[$i] =~ /(\w)=mem\(hl\)/) {
				my $l = $1;
				if ($effect[$i+1] =~ /hl\+\+/ &&
					$effect[$i+2] =~ /(\w)=mem\(hl\)/) {
					my $h = $1;
					if ($effect[$i+3] =~ /hl\+\+/) {
						splice(@effect, $i, 4, "$h$l=mem(hl)", "hl++", "hl++");
						$i--;
						$repeat++;
					}
				}
			}
		}
		
		# ["c=mem(ix)", "b=mem(ix+1)"]->["bc=mem(ix)"]
		for (my $i = 0; $i+1 < @effect; $i++) {
			if ($effect[$i] =~ /(\w)=mem\((\w+)\)/) {
				my($l, $x) = ($1, $2);
				if ($effect[$i+1] =~ /(\w)=mem\($x\+1\)/) {
					my $h = $1;
					splice(@effect, $i, 2, "$h$l=mem($x)");
					$i--;
					$repeat++;
				}
			}
		}
		
		# ["c=mem(ix+%d)", "b=mem(ix+%d+1)"]->["bc=mem(ix+%d)"]
		for (my $i = 0; $i+1 < @effect; $i++) {
			if ($effect[$i] =~ /(\w)=mem\((\w+)\+%d\)/) {
				my($l, $x) = ($1, $2);
				if ($effect[$i+1] =~ /(\w)=mem\($x\+%d\+1\)/) {
					my $h = $1;
					splice(@effect, $i, 2, "$h$l=mem($x+%d)");
					$i--;
					$repeat++;
				}
			}
		}

		# ["exx", "save(bc)", "exx", "restore(bc)"]->["bc=bc'"]
		for (my $i = 0; $i+3 < @effect; $i++) {
			if ($effect[$i] =~ /exx/ &&
				$effect[$i+1] =~ /save\((\w+)\)/) {
				my $b = $1;
				if ($effect[$i+2] =~ /exx/ &&
					$effect[$i+3] =~ /restore\((\w+)\)/) {
					my $a = $1;
					splice(@effect, $i, 4, "$a=$b'");
					$i--;
					$repeat++;
				}
			}
		}

		# ["exx", "save(bc)", "exx"]->["save(bc')"]
		for (my $i = 0; $i+2 < @effect; $i++) {
			if ($effect[$i] =~ /exx/ &&
				$effect[$i+1] =~ /save\((\w+)\)/) {
				my $rp = $1;
				if ($effect[$i+2] =~ /exx/) {
					splice(@effect, $i, 3, "save($rp')");
					$i--;
					$repeat++;
				}
			}
		}

		# ["b=ixh", "c=ixl"]->["bc=ix"]
		for (my $i = 0; $i+1 < @effect; $i++) {
			if ($effect[$i] =~ /(\w)=(ix|iy)h/) {
				my($h, $x) = ($1, $2);
				if ($effect[$i+1] =~ /(\w)=${x}l/) {
					my $l = $1;
					splice(@effect, $i, 2, "$h$l=$x");
					$i--;
					$repeat++;
				}
			}
		}

		# ["ixh=b", "ixl=c"]->["ix=bc"]
		for (my $i = 0; $i+1 < @effect; $i++) {
			if ($effect[$i] =~ /(ix|iy)h=(\w)/) {
				my($x, $h) = ($1, $2);
				if ($effect[$i+1] =~ /${x}l=(\w)/) {
					my $l = $1;
					splice(@effect, $i, 2, "$x=$h$l");
					$i--;
					$repeat++;
				}
			}
		}

		# ["de<->hl", "hl=mem(%m)", "de<->hl"]->["de=mem(%m)"]
		for (my $i = 0; $i+2 < @effect; $i++) {
			if ($effect[$i] =~ /de<->hl/ &&
				$effect[$i+1] =~ /hl=mem\(%m\)/ &&
				$effect[$i+2] =~ /de<->hl/) {
				splice(@effect, $i, 3, "de=mem(%m)");
				$i--;
				$repeat++;
			}
		}

		# ["hl=0", "hl+=sp"]->["hl=sp"]
		for (my $i = 0; $i+1 < @effect; $i++) {
			if ($effect[$i] =~ /hl=(.*)/) {
				my $expr = "+$1";
				$expr =~ s/\+0//;
				if ($effect[$i+1] =~ /hl\+=sp/) {
					splice(@effect, $i, 2, "hl=sp$expr");
					$i--;
					$repeat++;
				}
			}
		}

		# ["de<->hl", "de=sp", "de<->hl"]->["hl=sp"]
		for (my $i = 0; $i+2 < @effect; $i++) {
			if ($effect[$i] =~ /de<->hl/ &&
				$effect[$i+1] =~ /de=sp(.*)/) {
				my $expr = $1;
				if ($effect[$i+2] =~ /de<->hl/) {
					splice(@effect, $i, 3, "hl=sp$expr");
					$i--;
					$repeat++;
				}
			}
		}
		
		# ["save(de)","de=mem(hl)","ix=de","restore(de)"]->["ix=mem(hl)"]
		for (my $i = 0; $i+3 < @effect; $i++) {
			if ($effect[$i] =~ /save\(de\)/ &&
				$effect[$i+1] =~ /de=mem\(hl\)/ &&
				$effect[$i+2] =~ /(ix|iy)=de/) {
				my $x = $1;
				if ($effect[$i+3] =~ /restore\(de\)/) {
					splice(@effect, $i, 4, "$x=mem(hl)");
					$i--;
					$repeat++;
				}
			}
		}
		
		# ["save(de)","de=mem(hl)","hl++","hl++","ix=de","restore(de)"] 
		# ->["ix=mem(hl)", "hl++", "hl++"]
		for (my $i = 0; $i+5 < @effect; $i++) {
			if ($effect[$i] =~ /save\(de\)/ &&
				$effect[$i+1] =~ /de=mem\(hl\)/ &&
				$effect[$i+2] =~ /hl\+\+/ &&
				$effect[$i+3] =~ /hl\+\+/ &&
				$effect[$i+4] =~ /(ix|iy)=de/) {
				my $x = $1;
				if ($effect[$i+5] =~ /restore\(de\)/) {
					splice(@effect, $i, 6, "$x=mem(hl)", "hl++", "hl++");
					$i--;
					$repeat++;
				}
			}
		}
		
		# ["save(ix)","hl<->mem(sp)","hl=mem(ix)","hl<->mem(sp)","restore(ix)"]->["ix=mem(ix)"]
		for (my $i = 0; $i+4 < @effect; $i++) {
			if ($effect[$i] =~ /save\((ix|iy)\)/) {
				my $x1 = $1;
				if ($effect[$i+1] =~ /hl<->mem\(sp\)/ &&
					$effect[$i+2] =~ /hl=mem\((ix|iy)(.*)\)/) {
					my($x2, $expr) = ($1, $2);
					if ($effect[$i+3] =~ /hl<->mem\(sp\)/ &&
						$effect[$i+4] =~ /restore\($x1\)/) {
						splice(@effect, $i, 5, "$x1=mem($x2$expr)");
						$i--;
						$repeat++;
					}
				}
			}
		}

		# ["a=~a", "a++"]->["a=-a"]
		for (my $i = 0; $i+1 < @effect; $i++) {
			if ($effect[$i] =~ /a=~a/ &&
				$effect[$i+1] =~ /a\+\+/) {
				splice(@effect, $i, 2, "a=-a");
				$i--;
				$repeat++;
			}
		}

		# ["save(af)", "a=b", "a=~a", "b=a", "b++", "restore(af)"]->["b=-b"]
		for (my $i = 0; $i+5 < @effect; $i++) {
			if ($effect[$i] =~ /save\(af\)/ &&
				$effect[$i+1] =~ /a=(\w)$/) {
				my $r = $1;
				if ($effect[$i+2] =~ /a=~a/ &&
					$effect[$i+3] =~ /$r=a/ &&
					$effect[$i+4] =~ /$r\+\+/ &&
					$effect[$i+5] =~ /restore\(af\)/) {
					splice(@effect, $i, 6, "$r=-$r");
					$i--;
					$repeat++;
				}
			}
		}
		
		# ["save(af)","a=b","a=~a","b=a","a=c","a=~a","c=a","bc++","restore(af)"] 
		# ->["bc=-bc"]
		for (my $i = 0; $i+8 < @effect; $i++) {
			if ($effect[$i] =~ /save\(af\)/ &&
				$effect[$i+1] =~ /a=(\w)$/) {
				my $h = $1;
				if ($effect[$i+2] =~ /a=~a/ &&
					$effect[$i+3] =~ /$h=a/ &&
					$effect[$i+4] =~ /a=(\w)$/) {
					my $l = $1;
					if ($effect[$i+5] =~ /a=~a/ &&
						$effect[$i+6] =~ /$l=a/ &&
						$effect[$i+7] =~ /$h$l\+\+/ &&
						$effect[$i+8] =~ /restore\(af\)/) {
						splice(@effect, $i, 9, "$h$l=-$h$l");
						$i--;
						$repeat++;
					}
				}
			}
		}
		
		# ["save(af)","a=ixh","a=~a","ixh=a","a=ixl","a=~a","ixl=a","ix++","restore(af)"]
		# ->["ix=-ix"]
		for (my $i = 0; $i+8 < @effect; $i++) {
			if ($effect[$i] =~ /save\(af\)/ &&
				$effect[$i+1] =~ /a=(ix|iy)h$/) {
				my $x = $1;
				if ($effect[$i+2] =~ /a=~a/ &&
					$effect[$i+3] =~ /${x}h=a/ &&
					$effect[$i+4] =~ /a=${x}l/ &&
					$effect[$i+5] =~ /a=~a/ &&
					$effect[$i+6] =~ /${x}l=a/ &&
					$effect[$i+7] =~ /$x\+\+/ &&
					$effect[$i+8] =~ /restore\(af\)/) {
					splice(@effect, $i, 9, "$x=-$x");
					$i--;
					$repeat++;
				}
			}
		}
		
		# ["save(hl)","hl=ix","a=h","a=~a","h=a","a=l","a=~a","l=a","hl++","ix=hl","restore(hl)"]
		# ->["ix=-ix"]
		for (my $i = 0; $i+10 < @effect; $i++) {
			if ($effect[$i] =~ /save\(hl\)/ &&
				$effect[$i+1] =~ /hl=(ix|iy)/) {
				my $x = $1;
				if ($effect[$i+2] =~ /a=h/ &&
					$effect[$i+3] =~ /a=~a/ &&
					$effect[$i+4] =~ /h=a/ &&
					$effect[$i+5] =~ /a=l/ &&
					$effect[$i+6] =~ /a=~a/ &&
					$effect[$i+7] =~ /l=a/ &&
					$effect[$i+8] =~ /hl\+\+/ &&
					$effect[$i+9] =~ /$x=hl/ &&
					$effect[$i+10] =~ /restore\(hl\)/) {
					splice(@effect, $i, 11, "$x=-$x");
					$i--;
					$repeat++;
				}
			}
		}
		
		# ["rl e", "rl d"]->["rl de"]
		for (my $i = 0; $i+1 < @effect; $i++) {
			if ($effect[$i] =~ /rl (\w)$/) {
				my $l = $1;
				if ($effect[$i+1] =~ /rl (\w)$/) {
					my $h = $1;
					splice(@effect, $i, 2, "rl $h$l");
					$i--;
					$repeat++;
				}
			}
		}
				
		# ["rr b", "rr c"]->["rr bc"]
		for (my $i = 0; $i+1 < @effect; $i++) {
			if ($effect[$i] =~ /rr (\w)$/) {
				my $h = $1;
				if ($effect[$i+1] =~ /rr (\w)$/) {
					my $l = $1;
					splice(@effect, $i, 2, "rr $h$l");
					$i--;
					$repeat++;
				}
			}
		}
				
	} while ($repeat);
	
	return @effect;
}

# normalize %tN - may be %t3 or %t4 for ez80
sub align_temporaries {
	my($eff1, $eff2) = @_;
	return if @$eff1 != @$eff2;		# only check if same size

	# find mismatched labels
	my %replace2;					# labels to be replaced in $eff2
	for my $i (0 .. $#$eff1) {
		if ($eff1->[$i] =~ /(%t\d+)/) {
			my $label1 = $1;
			if ($eff2->[$i] =~ /(%t\d+)/) {
				my $label2 = $1;
				if ($label1 ne $label2) {
					$replace2{$label2} = $label1;
				}
			}
		}
	}
	
	# replace mismatched labels
	for (@$eff2) {
		s/(%t\d+)/ exists $replace2{$1} ? $replace2{$1} : $1 /e;
	}
}

sub intel_to_zilog {
	my($asm) = @_;

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
    return "c"  if $f eq "nc";
    return "nc" if $f eq "c";
    return "z"  if $f eq "nz";
    return "nz" if $f eq "z";
    return "po" if $f eq "pe";
    return "pe" if $f eq "po";
    return "p"  if $f eq "m";
    return "m"  if $f eq "p";
    die "unknown flag '$f'";
}
