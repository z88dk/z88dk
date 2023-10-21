#!/usr/bin/env perl

#------------------------------------------------------------------------------
# z80asm assembler
# Test z88dk-z80asm-*.lib
# Copyright (C) Paulo Custodio, 2011-2023
# License: http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/z88dk/z88dk
#------------------------------------------------------------------------------

BEGIN { use lib '../../t'; require 'testlib.pl'; }

use Modern::Perl;

my $ticks = Ticks->new;

# LDI
$ticks->add(<<END,
						jr start
				src:	defb 1,2,3,4
				dst:	defb 0,0,0,0
				start:	ld hl, src
						ld de, dst
						ld bc, 4
						ldi
END
				HL => sub { my($t) = @_;
							local $Test::Builder::Level = $Test::Builder::Level + 1;
							is $t->{mem}[$t->{labels}{L1_dst}+0], 1, "L1_dst+0=1";
							is $t->{mem}[$t->{labels}{L1_dst}+1], 0, "L1_dst+1=0";
							is $t->{mem}[$t->{labels}{L1_dst}+2], 0, "L1_dst+2=0";
							is $t->{mem}[$t->{labels}{L1_dst}+3], 0, "L1_dst+3=0";
							return $t->{labels}{L1_src}+1; 
				},
				DE => sub { my($t) = @_;
							return $t->{labels}{L1_dst}+1; 
				},
				BC => 3);


# LDIR
$ticks->add(<<END,
						jr start
				src:	defb 1,2,3,4
				dst:	defb 0,0,0,0
				start:	ld hl, src
						ld de, dst
						ld bc, 4
						ldir
END
				HL => sub { my($t) = @_;
							local $Test::Builder::Level = $Test::Builder::Level + 1;
							is $t->{mem}[$t->{labels}{L2_dst}+0], 1, "L2_dst+0=1";
							is $t->{mem}[$t->{labels}{L2_dst}+1], 2, "L2_dst+1=2";
							is $t->{mem}[$t->{labels}{L2_dst}+2], 3, "L2_dst+2=3";
							is $t->{mem}[$t->{labels}{L2_dst}+3], 4, "L2_dst+3=4";
							return $t->{labels}{L2_src}+4; 
				},
				DE => sub { my($t) = @_;
							return $t->{labels}{L2_dst}+4; 
				},
				BC => 0);

# LDD
$ticks->add(<<END,
						jr start
				src:	defb 1,2,3,4
				dst:	defb 0,0,0,0
				start:	ld hl, src+3
						ld de, dst+3
						ld bc, 4
						ldd
END
				HL => sub { my($t) = @_;
							local $Test::Builder::Level = $Test::Builder::Level + 1;
							is $t->{mem}[$t->{labels}{L3_dst}+0], 0, "L3_dst+0=0";
							is $t->{mem}[$t->{labels}{L3_dst}+1], 0, "L3_dst+1=0";
							is $t->{mem}[$t->{labels}{L3_dst}+2], 0, "L3_dst+2=0";
							is $t->{mem}[$t->{labels}{L3_dst}+3], 4, "L3_dst+3=4";
							return $t->{labels}{L3_src}+2; 
				},
				DE => sub { my($t) = @_;
							return $t->{labels}{L3_dst}+2; 
				},
				BC => 3);

# LDDR
$ticks->add(<<END,
						jr start
				src:	defb 1,2,3,4
				dst:	defb 0,0,0,0
				start:	ld hl, src+3
						ld de, dst+3
						ld bc, 4
						lddr
END
				HL => sub { my($t) = @_;
							local $Test::Builder::Level = $Test::Builder::Level + 1;
							is $t->{mem}[$t->{labels}{L4_dst}+0], 1, "L3_dst+0=0";
							is $t->{mem}[$t->{labels}{L4_dst}+1], 2, "L3_dst+1=0";
							is $t->{mem}[$t->{labels}{L4_dst}+2], 3, "L3_dst+2=0";
							is $t->{mem}[$t->{labels}{L4_dst}+3], 4, "L3_dst+3=4";
							return $t->{labels}{L4_src}-1; 
				},
				DE => sub { my($t) = @_;
							return $t->{labels}{L4_dst}-1; 
				},
				BC => 0);



$ticks->run;

unlink_testfiles();
done_testing();
