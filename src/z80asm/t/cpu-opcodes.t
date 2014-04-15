#!/usr/bin/perl

#     ZZZZZZZZZZZZZZZZZZZZ    8888888888888       00000000000
#   ZZZZZZZZZZZZZZZZZZZZ    88888888888888888    0000000000000
#                ZZZZZ      888           888  0000         0000
#              ZZZZZ        88888888888888888  0000         0000
#            ZZZZZ            8888888888888    0000         0000       AAAAAA         SSSSSSSSSSS   MMMM       MMMM
#          ZZZZZ            88888888888888888  0000         0000      AAAAAAAA      SSSS            MMMMMM   MMMMMM
#        ZZZZZ              8888         8888  0000         0000     AAAA  AAAA     SSSSSSSSSSS     MMMMMMMMMMMMMMM
#      ZZZZZ                8888         8888  0000         0000    AAAAAAAAAAAA      SSSSSSSSSSS   MMMM MMMMM MMMM
#    ZZZZZZZZZZZZZZZZZZZZZ  88888888888888888    0000000000000     AAAA      AAAA           SSSSS   MMMM       MMMM
#  ZZZZZZZZZZZZZZZZZZZZZ      8888888888888       00000000000     AAAA        AAAA  SSSSSSSSSSS     MMMM       MMMM
#
# Copyright (C) Paulo Custodio, 2011-2014

# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/t/Attic/cpu-opcodes.t,v 1.7 2014-04-15 20:06:44 pauloscustodio Exp $
# $Log: cpu-opcodes.t,v $
# Revision 1.7  2014-04-15 20:06:44  pauloscustodio
# Solve warning: no newline at end of file
#
# Revision 1.6  2014/03/29 01:19:41  pauloscustodio
# Accept both "ex af,af" and "ex af,af'"
#
# Revision 1.5  2014/01/11 01:29:46  pauloscustodio
# Extend copyright to 2014.
# Move CVS log to bottom of file.
#
# Revision 1.4  2013/01/20 21:24:29  pauloscustodio
# Updated copyright year to 2013
#
# Revision 1.3  2013/01/20 20:43:12  pauloscustodio
# Delete *.lst files that are generated during the test in the libsrc/z80_crt0s/z80_emu
# directory
#
# Revision 1.2  2012/05/17 15:01:52  pauloscustodio
# Test only Z80 and RCM2000, skip Z180 (same as Z80 as of now) and RCM3000 (same as RCM2000 as of now)
#
# Revision 1.1  2012/05/13 20:40:03  pauloscustodio
# Test all variations of Z80 vs RCMX000 opcodes. Prepared the way to add Z180.
# Still to do: add all instructions of RCM2000 and RCM3000 (postponed)
#
# Revision 1.1  2011/07/11 15:46:33  pauloscustodio
# Added test scripts for all z80asm options
#
# Test assembly for different CPUs

use strict;
use warnings;
use Test::More;
use Iterator::Array::Jagged;
require 't/test_utils.pl';

my $z80emu_lib = 'z80emu.lib';
my $z80emu_srcdir = '../../libsrc/z80_crt0s/z80_emu';
my @z80emu_routines = qw(
		afswap
		exxswap
		rcmx_cpd
		rcmx_cpdr
		rcmx_cpi
		rcmx_cpir
		rcmx_rld
		rcmx_rrd
);
my @z80emu_src = map {$z80emu_srcdir.'/'.$_.'.asm'} @z80emu_routines;
my @z80emu_lst = map {$z80emu_srcdir.'/'.$_.'.lst'} @z80emu_routines;

my @CPUS = (qw( Z80 Z180 RCM2000 RCM3000 ));
my %OPTION = (
	Z80		=> "",
	Z180	=> "",
	RCM2000	=> "-RCMX000 -i".$z80emu_lib,
	RCM3000	=> "-RCMX000 -i".$z80emu_lib,
);
my %SKIP = ( Z180 => 1, RCM3000 => 1 );

# build z80emu.lib
t_z80asm_capture("-l -x$z80emu_lib @z80emu_src", "", "", 0);

test_opcodes();

unlink_testfiles($z80emu_lib, @z80emu_lst);
done_testing();

#------------------------------------------------------------------------------
# parse lines from __DATA__, assemble instructions, compare results
sub test_opcodes {
	my $iter = sub { scalar(<DATA>) };
	
	while (my %opcodes = next_opcode($iter)) {
		for my $cpu (@CPUS) {
			if (exists($opcodes{$cpu}) && ! exists($SKIP{$cpu})) {
				my $asm = $opcodes{$cpu}{asm};
				my $bin = $opcodes{$cpu}{bin};
				(my $asm_text = $asm) =~ s/\n/ : /g;
				note "$cpu : $asm_text";
				t_z80asm_ok(0, $asm, $bin, $OPTION{$cpu});
			}
		}
	}
}

#------------------------------------------------------------------------------
# parse each line from DATA, return %opcodes with asm and bin per CPU
sub next_opcode {
	my($iter) = @_;
	my %opcodes;
	
	# loop to skip comments and blanks, but exit on first opcode line found
	while (my $_ = $iter->()) {
		# continuation lines
		while (s/\\\n\z/ /) {
			my $next = $iter->() || "";
			$_ .= $next;
		}
			
		# skip blanks and comments
		s/\s*\#.*//; s/^\s+//; s/\s+$//;
		next unless /\S/;

		# skip from __END__ onwards
		if (/^__END__/) {
			1 while ($iter->());	# consume all
			next;
		}

		my($instr, $cpus, $bytes) = /^(.*?)\s*=>\s*([-x]+)\s+(.*)$/
			or die "cannot parse $_";
		
		my @instr_tmpl = split(/\s+|\s*,\s*/, $instr);
		
		my @cpus;
		for (0 .. length($cpus)-1) {
			push @cpus, $CPUS[$_] if uc(substr($cpus, $_, 1)) eq 'X';
		}
		
		my @bytes_tmpl = split(' ', $bytes);

		# convert each operand to a list of [index, value]
		for (@instr_tmpl) {
			if (s/^<(.*)>$/$1/) {
				my @list = split(/\./, $_);
				$_ = [ grep {$_->[1] ne ""} map {[$_, $list[$_]]} 0 .. $#list ];
			}
			else {
				$_ = [[0, $_]];
			}
		}
		
		# iterate through lists
		my $instr_iter = Iterator::Array::Jagged->new(data => \@instr_tmpl);
		while (my @set = $instr_iter->next) {
			# compute instr and bytes
			my @value = map {$_->[0]} @set;
			my @instr = map {$_->[1]} @set;

			# make a copy, so that @bytes remains intact
			my @bytes = @bytes_tmpl;	

			for (@bytes) {
				s/<(\d)(:(\d))?>/ $value[ $1 ] << ($3 || 0) /ge;
				if (! /(NN?|DIS)/) {
					$_ = eval $_; $@ and die $@;
				}
			}
			
			add_opcodes(\%opcodes, [@cpus], [@instr], [@bytes]);
		}

		return %opcodes;			# one opcode line at a time
	}
	
	return;							# end of input
}

#------------------------------------------------------------------------------
# add an opcode to the %opcodes list
sub add_opcodes {
	my($opcodes, $cpus, $instr, $bytes) = @_;
	our %found_asm;
	
	# expand N, NN, DIS
	if (grep {/NN/} @$bytes) {
		if ($instr->[0] =~ /jr|djnz/) {
			for my $n (-128, 0, 127) {
				my @instr = @$instr;
				for (@instr) {
					s/\bNN\b/ASMPC+2+($n)/;
				}
				my @bytes = @$bytes;
				for (@bytes) {
					s/\bNNo\b/$n/;
				}
				add_opcodes($opcodes, $cpus, \@instr, \@bytes);
			}
		}
		else {
			for my $nn (-0x8000, 0, 0xFFFF) {
				my @instr = @$instr;
				for (@instr) {
					s/\bNN\b/$nn/;
				}
				my @bytes = @$bytes;
				for (@bytes) {
					s/\bNNh\b/ ($nn >> 8) & 0xFF /e;
					s/\bNNl\b/  $nn       & 0xFF /e;
				}
				add_opcodes($opcodes, $cpus, \@instr, \@bytes);
			}
		}
	}
	elsif (grep {/N/} @$bytes) {
		for my $n (-128, 0, 255) {
			my @instr = @$instr;
			my @bytes = @$bytes;
			for (@instr, @bytes) {
				s/\bN\b/$n/;
			}
			add_opcodes($opcodes, $cpus, \@instr, \@bytes);
		}
	}
	elsif (grep {/DIS/} @$bytes) {
		my $plus1 = grep {$_ eq 'DIS+1'} @$bytes;
		for my $n (-128, 0, $plus1 ? 126 : 127) {
			my @instr = @$instr;
			for (@instr) {
				if ($n == 0) {
					s/\+DIS\b//;
				}
				else {
					s/\bDIS\b/($n)/;
				}
			}
			my @bytes = @$bytes;
			for (@bytes) {
				s/\bDIS\+1/$n+1/e;
				s/\bDIS\b/$n/;
			}
			add_opcodes($opcodes, $cpus, \@instr, \@bytes);
		}
	}
	else {
		# N, NN, DIS already decoded
		
		my $asm = join(" ", $instr->[0], join(",", @$instr[1..$#$instr]));
		my $bin = join("", map {chr($_ & 0xFF)} @$bytes);
		
		for my $cpu (@$cpus) {
			if ($found_asm{$cpu}{$asm}++) {
				next;			# skip ADC HL,xx (ED xx) instruction if already loaded
								# without ED prefix
			}
			$opcodes->{$cpu}{asm} ||= "";
			$opcodes->{$cpu}{asm} .= $asm."\n";
			
			$opcodes->{$cpu}{bin} ||= "";
			$opcodes->{$cpu}{bin} .= $bin;
		}
	}
}	
	
__DATA__

#------------------------------------------------------------------------------
# Z80 assembly table
# The order is important: an instruction is only loaded if not yet defined

#------------------------------------------------------------------------------
# 8 bit load group
#										   +---Z80
#										   |+--Z180
#										   ||+-RCM2000
#										   |||+RCM3000
ld   <b.c.d.e.h.l..a>,<b.c.d.e.h.l..a>	=> xxxx	     0x40+<1:3>+<2>
ld   <b.c.d.e.ixh.ixl..a>,<b.c.d.e.ixh.ixl..a>	\
										=> xx--	0xDD 0x40+<1:3>+<2>
ld   <b.c.d.e.iyh.iyl..a>,<b.c.d.e.iyh.iyl..a>	\
										=> xx--	0xFD 0x40+<1:3>+<2>

ld   <b.c.d.e.h.l..a>,N					=> xxxx	     0x06+<1:3> N
ld   <....ixh.ixl..>,N					=> xx--	0xDD 0x06+<1:3> N
ld   <....iyh.iyl..>,N					=> xx--	0xFD 0x06+<1:3> N

ld   <b.c.d.e.h.l..a>,(hl)				=> xxxx	     0x46+<1:3>
#ldi <b.c.d.e.h.l..a>,(hl)				=> xxxx	     0x46+<1:3> 0x23
#ldd <b.c.d.e.h.l..a>,(hl)				=> xxxx	     0x46+<1:3> 0x2B

ld   <b.c.d.e.h.l..a>,(ix+DIS)			=> xxxx	0xDD 0x46+<1:3> DIS
#ldi <b.c.d.e.h.l..a>,(ix+DIS)			=> xxxx	0xDD 0x46+<1:3> DIS 0xDD 0x23
#ldd <b.c.d.e.h.l..a>,(ix+DIS)			=> xxxx	0xDD 0x46+<1:3> DIS 0xDD 0x2B

ld	 <b.c.d.e.h.l..a>,(iy+DIS)			=> xxxx	0xFD 0x46+<1:3> DIS
#ldi <b.c.d.e.h.l..a>,(iy+DIS)			=> xxxx	0xFD 0x46+<1:3> DIS 0xFD 0x23
#ldd <b.c.d.e.h.l..a>,(iy+DIS)			=> xxxx	0xFD 0x46+<1:3> DIS 0xFD 0x2B

ld	 (hl),<b.c.d.e.h.l..a>				=> xxxx      0x70+<2>
#ldi (hl),<b.c.d.e.h.l..a>				=> xxxx      0x70+<2> 0x23
#ldd (hl),<b.c.d.e.h.l..a>				=> xxxx      0x70+<2> 0x2B

ld	 (ix+DIS),<b.c.d.e.h.l..a>			=> xxxx 0xDD 0x70+<2> DIS
#ldi (ix+DIS),<b.c.d.e.h.l..a>			=> xxxx 0xDD 0x70+<2> DIS 0xDD 0x23
#ldd (ix+DIS),<b.c.d.e.h.l..a>			=> xxxx 0xDD 0x70+<2> DIS 0xDD 0x2B

ld	 (iy+DIS),<b.c.d.e.h.l..a>			=> xxxx 0xFD 0x70+<2> DIS
#ldi (iy+DIS),<b.c.d.e.h.l..a>			=> xxxx 0xFD 0x70+<2> DIS 0xFD 0x23
#ldd (iy+DIS),<b.c.d.e.h.l..a>			=> xxxx 0xFD 0x70+<2> DIS 0xFD 0x2B

ld   (hl),N								=> xxxx      0x36 N
#ldi (hl),N								=> xxxx      0x36 N 0x23
#ldd (hl),N								=> xxxx      0x36 N 0x2B

ld   (ix+DIS),N							=> xxxx 0xDD 0x36 DIS N
#ldi (ix+DIS),N							=> xxxx 0xDD 0x36 DIS N 0xDD 0x23
#ldd (ix+DIS),N							=> xxxx 0xDD 0x36 DIS N 0xDD 0x2B

ld   (iy+DIS),N							=> xxxx 0xFD 0x36 DIS N
#ldi (iy+DIS),N							=> xxxx 0xFD 0x36 DIS N 0xFD 0x23
#ldd (iy+DIS),N							=> xxxx 0xFD 0x36 DIS N 0xFD 0x2B

ld   a,<(bc).(de)>						=> xxxx 0x0A+<2:4>
#ldi a,<(bc).(de)>						=> xxxx 0x0A+<2:4> 0x03+<2:4>
#ldd a,<(bc).(de)>						=> xxxx 0x0A+<2:4> 0x0B+<2:4>

ld   <(bc).(de)>,a						=> xxxx 0x02+<1:4>
#ldi <(bc).(de)>,a						=> xxxx 0x02+<1:4> 0x03+<1:4>
#ldd <(bc).(de)>,a						=> xxxx 0x02+<1:4> 0x0B+<1:4>

ld   a,(NN) 							=> xxxx 0x3A NNl NNh
ld   (NN),a 							=> xxxx 0x32 NNl NNh

ld   a,<i.r>							=> xx-- 0xED 0x57+<2:3>
ld   <i.r>,a							=> xx-- 0xED 0x47+<1:3>

ld   a,<iir.eir>						=> --xx 0xED 0x57+<2:3>
ld   <iir.eir>,a						=> --xx 0xED 0x47+<1:3>


#------------------------------------------------------------------------------
# 16 bit load group
#										   +---Z80
#										   |+--Z180
#										   ||+-RCM2000
#										   |||+RCM3000
#ld  <bc..de..hl>,<bc..de..hl>			=> xxxx 0x40+<1:3>+<2> 0x49+<1:3>+<2>
#ld  <bc..de..>,ix						=> xxxx 0xDD 0x44+<1:3> 0xDD 0x4D+<1:3>
#ld  <bc..de..>,iy						=> xxxx 0xFD 0x44+<1:3> 0xFD 0x4D+<1:3>

#ld  <bc..de..>,(hl)					=> xxxx 0x4E+<1:3> 0x23 0x46+<1:3> 0x2B
#ldi <bc..de..>,(hl)					=> xxxx 0x4E+<1:3> 0x23 0x46+<1:3> 0x23

#ld  <bc..de..hl>,(ix+DIS)				=> xxxx 0xDD 0x4E+<1:3> DIS	\
												0xDD 0x46+<1:3> DIS+1
#ldi <bc..de..hl>,(ix+DIS)				=> xxxx 0xDD 0x4E+<1:3> DIS	\
												0xDD 0x23 \
												0xDD 0x46+<1:3> DIS \
												0xDD 0x23 

#ld  <bc..de..hl>,(iy+DIS)				=> xxxx 0xFD 0x4E+<1:3> DIS	\
												0xFD 0x46+<1:3> DIS+1
#ldi <bc..de..hl>,(iy+DIS)				=> xxxx 0xFD 0x4E+<1:3> DIS \
												0xFD 0x23 \
												0xFD 0x46+<1:3> DIS \
												0xFD 0x23

#ld  (hl),<bc..de>						=> xxxx 0x71+<2> 0x23 0x70+<2> 0x2B
#ldi (hl),<bc..de>						=> xxxx 0x71+<2> 0x23 0x70+<2> 0x23

#ld  (ix+DIS),<bc..de..hl>				=> xxxx 0xDD 0x71+<2> DIS \
												0xDD 0x70+<2> DIS+1
#ldi (ix+DIS),<bc..de..hl>				=> xxxx 0xDD 0x71+<2> DIS \
												0xDD 0x23 \
												0xDD 0x70+<2> DIS \
												0xDD 0x23

#ld  (iy+DIS),<bc..de..hl>				=> xxxx 0xFD 0x71+<2> DIS \
												0xFD 0x70+<2> DIS+1
#ldi (iy+DIS),<bc..de..hl>				=> xxxx 0xFD 0x71+<2> DIS \
												0xFD 0x23 \
												0xFD 0x70+<2> DIS \
												0xFD 0x23

#ld  hl,ix								=> xxxx 0xDD 0xE5 0xE1
#ld  hl,iy								=> xxxx 0xFD 0xE5 0xE1

#ld  ix,<bc..de..>						=> xxxx 0xDD 0x69+<2> \
												0xDD 0x60+<2>
#ld  iy,<bc..de..>						=> xxxx 0xFD 0x69+<2> \
												0xFD 0x60+<2>

#ld  ix,hl								=> xxxx 0xE5 0xDD 0xE1
#ld  iy,hl								=> xxxx 0xE5 0xFD 0xE1

#ld  ix,ix								=> xxxx 0xDD 0x6D 0xDD 0x64
#ld  ix,iy								=> xxxx 0xFD 0xE5 0xDD 0xE1

#ld  iy,iy								=> xxxx 0xFD 0x6D 0xFD 0x64
#ld  iy,ix								=> xxxx 0xDD 0xE5 0xFD 0xE1

ld   <bc.de.hl.sp>,NN					=> xxxx      0x01+<1:4> NNl NNh
ld   ix,NN								=> xxxx 0xDD 0x21       NNl NNh
ld   iy,NN								=> xxxx 0xFD 0x21       NNl NNh

ld   hl,(NN)							=> xxxx      0x2A NNl NNh
ld   ix,(NN)							=> xxxx 0xDD 0x2A NNl NNh
ld   iy,(NN)							=> xxxx 0xFD 0x2A NNl NNh

ld   <bc.de.hl.sp>,(NN)					=> xxxx 0xED 0x4B+<1:4> NNl NNh

ld   (NN),hl							=> xxxx      0x22 NNl NNh
ld   (NN),ix							=> xxxx 0xDD 0x22 NNl NNh
ld   (NN),iy							=> xxxx 0xFD 0x22 NNl NNh

ld   (NN),<bc.de.hl.sp>					=> xxxx 0xED 0x43+<2:4> NNl NNh

ld   sp,hl								=> xxxx      0xF9
ld   sp,ix								=> xxxx 0xDD 0xF9
ld   sp,iy								=> xxxx 0xFD 0xF9

push <bc.de.hl.af>						=> xxxx      0xC5+<1:4>
push ix									=> xxxx 0xDD 0xE5
push iy									=> xxxx 0xFD 0xE5

pop  <bc.de.hl.af>						=> xxxx      0xC1+<1:4>
pop  ix									=> xxxx 0xDD 0xE1
pop  iy									=> xxxx 0xFD 0xE1


#------------------------------------------------------------------------------
# Exchange, block transfer, search group
#										   +---Z80
#										   |+--Z180
#										   ||+-RCM2000
#										   |||+RCM3000
ex   de,hl								=> xxxx      0xEB
ex   af,af								=> xxxx      0x08
ex   af,af'								=> xxxx      0x08
exx										=> xxxx      0xD9

ex   (sp),hl							=> xx--      0xE3
ex   (sp),hl							=> --xx 0xED 0x54

ex   (sp),ix							=> xxxx 0xDD 0xE3
ex   (sp),iy							=> xxxx 0xFD 0xE3

ldi										=> xxxx 0xED 0xA0
ldir									=> xxxx 0xED 0xB0
ldd										=> xxxx 0xED 0xA8
lddr									=> xxxx 0xED 0xB8

cpi										=> xx-- 0xED 0xA1
cpir									=> xx-- 0xED 0xB1
cpd										=> xx-- 0xED 0xA9
cpdr									=> xx-- 0xED 0xB9

cpi										=> --xx 0xCD 0x03 0x00 \
												0x38 0x12 0xBE 0x23 0x0B 0xF5 \
												0xE3 0xCB 0x85 0xCB 0xD5 0x78 \
												0xB1 0x20 0x02 0xCB 0x95 0xE3 \
												0xF1 0xC9 0xBE 0x23 0x0B 0xF5 \
												0xE3 0xCB 0xC5 0x18 0xEC

cpir									=> --xx 0xCD 0x03 0x00 \
												0x30 0x06 0xCD 0x0B 0x00 0x37 \
												0xC9 0x23 0x0B 0xBE 0x28 0x12 \
												0x0C 0x0D 0x20 0xF7 0x04 0x10 \
												0xF4 0xBE 0x23 0xF5 0xE3 0xCB \
												0x85 0xCB 0x95 0xE3 0xF1 0xC9 \
												0x23 0xF5 0x78 0xB1 0x28 0xF2 \
												0xE3 0xCB 0x85 0xCB 0xD5 0xE3 \
												0xF1 0xC9 

cpd										=> --xx 0xCD 0x03 0x00 \
												0x38 0x12 0xBE 0x2B 0x0B 0xF5 \
												0xE3 0xCB 0x85 0xCB 0xD5 0x78 \
												0xB1 0x20 0x02 0xCB 0x95 0xE3 \
												0xF1 0xC9 0xBE 0x2B 0x0B 0xF5 \
												0xE3 0xCB 0xC5 0x18 0xEC

cpdr									=> --xx 0xCD 0x03 0x00 \
												0x30 0x06 0xCD 0x0B 0x00 0x37 \
												0xC9 0x2B 0x0B 0xBE 0x28 0x12 \
												0x0C 0x0D 0x20 0xF7 0x04 0x10 \
												0xF4 0xBE 0x2B 0xF5 0xE3 0xCB \
												0x85 0xCB 0x95 0xE3 0xF1 0xC9 \
												0x2B 0xF5 0x78 0xB1 0x28 0xF2 \
												0xE3 0xCB 0x85 0xCB 0xD5 0xE3 \
												0xF1 0xC9

#------------------------------------------------------------------------------
# 8 bit arithmetic and logical group
#										   +---Z80
#										   |+--Z180
#										   ||+-RCM2000
#										   |||+RCM3000
<add.adc..sbc> a,<b.c.d.e.h.l..a>		=> xxxx      0x80+<0:3>+<2>
<add.adc..sbc> a,<....ixh.ixl..>		=> xx-- 0xDD 0x80+<0:3>+<2>
<add.adc..sbc> a,<....iyh.iyl..>		=> xx-- 0xFD 0x80+<0:3>+<2>

<add.adc..sbc> a,N						=> xxxx      0xC6+<0:3> N
<add.adc..sbc> a,(hl)					=> xxxx      0x86+<0:3>
<add.adc..sbc> a,(ix+DIS)				=> xxxx 0xDD 0x86+<0:3> DIS
<add.adc..sbc> a,(iy+DIS)				=> xxxx 0xFD 0x86+<0:3> DIS

<..sub..and.xor.or.cp> <b.c.d.e.h.l..a>	=> xxxx      0x80+<0:3>+<1>
<..sub..and.xor.or.cp> <....ixh.ixl..>	=> xx-- 0xDD 0x80+<0:3>+<1>
<..sub..and.xor.or.cp> <....iyh.iyl..>	=> xx-- 0xFD 0x80+<0:3>+<1>

<..sub..and.xor.or.cp> N				=> xxxx		0xC6+<0:3> N
<..sub..and.xor.or.cp> (hl)				=> xxxx      0x86+<0:3>
<..sub..and.xor.or.cp> (ix+DIS)			=> xxxx 0xDD 0x86+<0:3> DIS
<..sub..and.xor.or.cp> (iy+DIS)			=> xxxx 0xFD 0x86+<0:3> DIS

<....inc.dec> <b.c.d.e.h.l..a>			=> xxxx      0x00+<0>+<1:3>
<....inc.dec> <....ixh.ixl..>			=> xx-- 0xDD 0x00+<0>+<1:3>
<....inc.dec> <....iyh.iyl..>			=> xx-- 0xFD 0x00+<0>+<1:3>
                                          
<....inc.dec> (hl)						=> xxxx      0x30+<0>
<....inc.dec> (ix+DIS)					=> xxxx 0xDD 0x30+<0> DIS
<....inc.dec> (iy+DIS)					=> xxxx 0xFD 0x30+<0> DIS


#------------------------------------------------------------------------------
# General purpose arithmetic and CPU control group
#										   +---Z80
#										   |+--Z180
#										   ||+-RCM2000
#										   |||+RCM3000
daa 									=> xx-- 0x27

cpl 									=> xxxx 0x2F
neg 									=> xxxx 0xED 0x44
ccf 									=> xxxx 0x3F
scf 									=> xxxx 0x37
nop 									=> xxxx 0x00

halt									=> xx-- 0x76
di 										=> xx-- 0xF3
ei	 									=> xx-- 0xFB
im	0 									=> xx-- 0xED 0x46
im	1 									=> xx-- 0xED 0x56
im	2 									=> xx-- 0xED 0x5E


#------------------------------------------------------------------------------
# 16 bit arithmetic and logical group
#										   +---Z80
#										   |+--Z180
#										   ||+-RCM2000
#										   |||+RCM3000
add hl,<bc.de.hl.sp>					=> xxxx      0x09+<2:4>
add ix,<bc.de.ix.sp>					=> xxxx 0xDD 0x09+<2:4>
add iy,<bc.de.iy.sp>					=> xxxx 0xFD 0x09+<2:4>

<sbc.adc> hl,<bc.de.hl.sp>				=> xxxx      0xED 0x42+<0:3>+<2:4>
#sub hl,<bc.de.hl.sp>					=> xxxx 0xB7 0xED 0x42+<2:4>

<inc.dec> <bc.de.hl.sp>					=> xxxx      0x03+<0:3>+<1:4>
<inc.dec> <..ix.>						=> xxxx 0xDD 0x03+<0:3>+<1:4>
<inc.dec> <..iy.>						=> xxxx 0xFD 0x03+<0:3>+<1:4>


#------------------------------------------------------------------------------
# 8 bit rotate and shift group
#										   +---Z80
#										   |+--Z180
#										   ||+-RCM2000
#										   |||+RCM3000
<rlca.rrca.rla.rra>						=> xxxx      0x07+<0:3>

<rlc.rrc.rl.rr.sla.sra..srl> \
	<b.c.d.e.h.l..a>					=> xxxx 0xCB 0x00+<0:3>+<1>
<......sll.> \
	<b.c.d.e.h.l..a>					=> xx-- 0xCB 0x00+<0:3>+<1>
#<......sli.> \
	<b.c.d.e.h.l..a>					=> xx-- 0xCB 0x00+<0:3>+<1>

<rlc.rrc.rl.rr.sla.sra..srl> (hl)		=> xxxx      0xCB     0x06+<0:3>
<rlc.rrc.rl.rr.sla.sra..srl> (ix+DIS)	=> xxxx 0xDD 0xCB DIS 0x06+<0:3>
<rlc.rrc.rl.rr.sla.sra..srl> (iy+DIS)	=> xxxx 0xFD 0xCB DIS 0x06+<0:3>

<......sll.>                 (hl)		=> xx--      0xCB     0x06+<0:3>
<......sll.>                 (ix+DIS)	=> xx-- 0xDD 0xCB DIS 0x06+<0:3>
<......sll.>                 (iy+DIS)	=> xx-- 0xFD 0xCB DIS 0x06+<0:3>
#<......sli.>                (hl)		=> xx--      0xCB     0x06+<0:3>
#<......sli.>                (ix+DIS)	=> xx-- 0xDD 0xCB DIS 0x06+<0:3>
#<......sli.>                (iy+DIS)	=> xx-- 0xFD 0xCB DIS 0x06+<0:3>

#<rlc.rrc.rl.rr.sla.sra..srl> \
	(ix+DIS),<b.c.d.e.h.l..a>			=> xxxx 0xDD 0xCB DIS 0x00+<0:3>+<2>
#<rlc.rrc.rl.rr.sla.sra..srl> \
	(iy+DIS),<b.c.d.e.h.l..a>			=> xxxx 0xFD 0xCB DIS 0x00+<0:3>+<2>
#<......sll.> \
	(ix+DIS),<b.c.d.e.h.l..a>			=> xx-- 0xDD 0xCB DIS 0x00+<0:3>+<2>
#<......sll.> \
	(iy+DIS),<b.c.d.e.h.l..a>			=> xx-- 0xFD 0xCB DIS 0x00+<0:3>+<2>
#<......sli.> \
	(ix+DIS),<b.c.d.e.h.l..a>			=> xx-- 0xDD 0xCB DIS 0x00+<0:3>+<2>
#<......sli.> \
	(iy+DIS),<b.c.d.e.h.l..a>			=> xx-- 0xFD 0xCB DIS 0x00+<0:3>+<2>

rld										=> xx-- 0xED 0x6F
rrd										=> xx-- 0xED 0x67

rld										=> --xx 0xCD 0x03 0x00 \
												0x30 0x05 0xCD 0x0A 0x00 0x37 \
												0xC9 0x07 0x07 0x07 0x07 0xCB \
												0x27 0xCB 0x16 0xCE 0x00 0x17 \
												0xCB 0x16 0xCE 0x00 0x17 0xCB \
												0x16 0xCE 0x00 0x17 0xCB 0x16 \
												0xCE 0x00 0xB7 0xC9
rrd										=> --xx 0xCD 0x03 0x00 \
												0x30 0x05 0xCD 0x0A 0x00 0x37 \
												0xC9 0xCB 0x3F 0xCB 0x1E 0x1F \
												0xCB 0x1E 0x1F 0xCB 0x1E 0x1F \
												0xCB 0x1E 0x1F 0x1F 0x1F 0x1F \
												0x1F 0xB7 0xC9 





#------------------------------------------------------------------------------
# 16 bit rotate and shift group
#										   +---Z80
#										   |+--Z180
#										   ||+-RCM2000
#										   |||+RCM3000

#rl <bc..de..hl>						=> xxxx 0xCB 0x11+<1> 0xCB 0x10+<1>
#rr <bc..de..hl>						=> xxxx 0xCB 0x18+<1> 0xCB 0x19+<1>

# special case: sla hl = add hl,hl
#sla hl									=> xxxx 0x29
#sla <bc..de..hl>						=> xxxx 0xCB 0x21+<1> 0xCB 0x10+<1>
#sll <bc..de..hl>						=> xxxx 0xCB 0x31+<1> 0xCB 0x10+<1>
#sli <bc..de..hl>						=> xxxx 0xCB 0x31+<1> 0xCB 0x10+<1>

#sra <bc..de..hl>						=> xxxx 0xCB 0x28+<1> 0xCB 0x19+<1>
#srl <bc..de..hl>						=> xxxx 0xCB 0x38+<1> 0xCB 0x19+<1>


#------------------------------------------------------------------------------
# Bit Set, Reset and Test Group
#										   +---Z80
#										   |+--Z180
#										   ||+-RCM2000
#										   |||+RCM3000
<.bit.res.set> \
	<0.1.2.3.4.5.6.7>,<b.c.d.e.h.l..a>	=> xxxx      0xCB     <0:6>+<1:3>+<2>
<.bit.res.set> \
	<0.1.2.3.4.5.6.7>,(hl)				=> xxxx      0xCB     <0:6>+<1:3>+6
<.bit.res.set> \
	<0.1.2.3.4.5.6.7>,(ix+DIS)			=> xxxx 0xDD 0xCB DIS <0:6>+<1:3>+6
<.bit.res.set> \
	<0.1.2.3.4.5.6.7>,(iy+DIS)			=> xxxx 0xFD 0xCB DIS <0:6>+<1:3>+6

#<..res.set>    <0.1.2.3.4.5.6.7>,(ix+DIS),<b.c.d.e.h.l..a>	=> xxxx 0xDD 0xCB DIS <0:6>+<1:3>+<3>
#<..res.set>    <0.1.2.3.4.5.6.7>,(iy+DIS),<b.c.d.e.h.l..a>	=> xxxx 0xFD 0xCB DIS <0:6>+<1:3>+<3>


#------------------------------------------------------------------------------
# Jump Group
#										   +---Z80
#										   |+--Z180
#										   ||+-RCM2000
#										   |||+RCM3000
jp NN									=> xxxx 0xC3       NNl NNh
jp <nz.z.nc.c.po.pe.p.m>,NN				=> xxxx 0xC2+<1:3> NNl NNh

jr NN									=> xxxx 0x18       NNo
jr <nz.z.nc.c>,NN						=> xxxx 0x20+<1:3> NNo
#jr <....po.pe.p.m>,NN					=> xxxx 0xC2+<1:3> NNl NNh
djnz NN									=> xxxx 0x10       NNo

jp (hl)									=> xxxx      0xE9
jp (ix)									=> xxxx 0xDD 0xE9
jp (iy)									=> xxxx 0xFD 0xE9


#------------------------------------------------------------------------------
# Call and Return Group
#										   +---Z80
#										   |+--Z180
#										   ||+-RCM2000
#										   |||+RCM3000
call NN									=> xxxx 0xCD       NNl NNh

call <nz.z.nc.c.po.pe.p.m>,NN			=> xx-- 0xC4+<1:3> NNl NNh

call <z.nz.c.nc>,NN						=> --xx 0x20+<1:3> 0x03 \
												0xCD NNl NNh

# need to hard-code address so that absolute jump over CALL can be computed
# (6 bytes * position of flag, starting at one)
call <....pe.po.m.p>,0x1234				=> --xx 0xC2+<1:3> 6*(<1>-3) 0x00 \
												0xCD 0x34 0x12

ret										=> xxxx 0xC9
ret <nz.z.nc.c.po.pe.p.m>				=> xxxx 0xC0+<1:3>
reti									=> xxxx 0xED 0x4D
retn									=> xx-- 0xED 0x45

rst <0.8.16.24.32.40.48.56>				=> xx-- 0xC7+(<1:3>&0b00111000)
rst <..16.24.32.40..56>					=> --xx 0xC7+(<1:3>&0b00111000)


#rst <0.1.2.3.4.5.6.7>					=> xxxx 0xC7+(<1:3>&0b00111000)


#------------------------------------------------------------------------------
# Input and Output Group
#										   +---Z80
#										   |+--Z180
#										   ||+-RCM2000
#										   |||+RCM3000
in a,(N)								=> xx--		0xDB N
in <b.c.d.e.h.l..a>,(c)					=> xx-- 0xED 0x40+<1:3>
in f,(c)								=> xx-- 0xED 0x70

ini										=> xx-- 0xED 0xA2
inir									=> xx-- 0xED 0xB2
ind										=> xx-- 0xED 0xAA
indr									=> xx-- 0xED 0xBA

out (N),a								=> xx--		0xD3 N
out (c),<b.c.d.e.h.l..a>				=> xx-- 0xED 0x41+<2:3>
#out (c),0								=> xx-- 0xED 0x71

outi									=> xx-- 0xED 0xA3
otir									=> xx-- 0xED 0xB3
outd									=> xx-- 0xED 0xAB
otdr									=> xx-- 0xED 0xBB
