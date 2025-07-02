#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

#------------------------------------------------------------------------------
# check cpu
#------------------------------------------------------------------------------

append_out("Check CPU\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr0 1
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v $test.asm >> $test.out 2>&1");
append_out("\n");


append_out("Check CPU\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr0 1
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v +zxn $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("Check CPU\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr0 1
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v -mz80n $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("Check CPU\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr0 1
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v -mz80n_strict $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


#------------------------------------------------------------------------------
# DMA.WR0
#------------------------------------------------------------------------------

append_out("DMA.WR0\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr0
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v +zxn $test.asm >> $test.out 2>&1");
append_out("\n");



append_out("DMA.WR0\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr0 ext
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v +zxn $test.asm >> $test.out 2>&1");
append_out("\n");


append_out("DMA.WR0\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr0 -1
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v +zxn $test.asm >> $test.out 2>&1");
append_out("\n");


append_out("DMA.WR0\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr0 255
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v +zxn $test.asm >> $test.out 2>&1");
append_out("\n");


append_out("DMA.WR0\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr0 0
	dma.wr0 2
	dma.wr0 3
	dma.wr0 128
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v +zxn $test.asm >> $test.out 2>&1");
append_out("\n");


append_out("DMA.WR0\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr0 1
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v +zxn $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("DMA.WR0\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr0 1, 99
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v +zxn $test.asm >> $test.out 2>&1");
append_out("\n");


append_out("DMA.WR0\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr0 1, 
			99
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v +zxn $test.asm >> $test.out 2>&1");
append_out("\n");


append_out("DMA.WR0\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr0 1, 
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v +zxn $test.asm >> $test.out 2>&1");
append_out("\n");


append_out("DMA.WR0\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr0 9
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v +zxn $test.asm >> $test.out 2>&1");
append_out("\n");


append_out("DMA.WR0\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr0 9, 2
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v +zxn $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("DMA.WR0\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr0 17, 2
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v +zxn $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("DMA.WR0\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr0 25, 32770
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v +zxn $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("DMA.WR0\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr0 33, 2
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v +zxn $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("DMA.WR0\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr0 65, 2
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v +zxn $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("DMA.WR0\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr0 97, 32770
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v +zxn $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("DMA.WR0\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr0 121, 16386, 32770
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v +zxn $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


#------------------------------------------------------------------------------
# DMA.WR1
#------------------------------------------------------------------------------

append_out("DMA.WR1\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr1 1
	dma.wr1 2
	dma.wr1 3
	dma.wr1 5
	dma.wr1 6
	dma.wr1 7
	dma.wr1 128
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v +zxn $test.asm >> $test.out 2>&1");
append_out("\n");


append_out("DMA.WR1\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr1 4
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v +zxn $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("DMA.WR1\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr1 68
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v +zxn $test.asm >> $test.out 2>&1");
append_out("\n");


append_out("DMA.WR1\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr1 68, \$
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v +zxn $test.asm >> $test.out 2>&1");
append_out("\n");


append_out("DMA.WR1\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr1 68, 16
	dma.wr1 68, 32
	dma.wr1 68, 48
	dma.wr1 68, 3
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v +zxn $test.asm >> $test.out 2>&1");
append_out("\n");


append_out("DMA.WR1\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr1 68, 0
	dma.wr1 68, 1
	dma.wr1 68, 2
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v +zxn $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("DMA.WR1\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr1 68, 128
	dma.wr1 68, 64
	dma.wr1 68, 8
	dma.wr1 68, 4
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v +zxn $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


#------------------------------------------------------------------------------
# DMA.WR2
#------------------------------------------------------------------------------

append_out("DMA.WR2\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr2 1
	dma.wr2 2
	dma.wr2 3
	dma.wr2 4
	dma.wr2 5
	dma.wr2 6
	dma.wr2 7
	dma.wr2 128
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v +zxn $test.asm >> $test.out 2>&1");
append_out("\n");


append_out("DMA.WR2\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr2 0
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v +zxn $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("DMA.WR2\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr2 64
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v +zxn $test.asm >> $test.out 2>&1");
append_out("\n");


append_out("DMA.WR2\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr2 64, \$
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v +zxn $test.asm >> $test.out 2>&1");
append_out("\n");


append_out("DMA.WR2\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr2 64, 16
	dma.wr2 64, 3
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v +zxn $test.asm >> $test.out 2>&1");
append_out("\n");


append_out("DMA.WR2\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr2 64, 0
	dma.wr2 64, 1
	dma.wr2 64, 2
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v +zxn $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("DMA.WR2\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr2 64, 128
	dma.wr2 64, 64
	dma.wr2 64, 8
	dma.wr2 64, 4
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v +zxn $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("DMA.WR2\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr2 64, 32
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v +zxn $test.asm >> $test.out 2>&1");
append_out("\n");


append_out("DMA.WR2\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr2 64, 32, 2
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v +zxn $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


#------------------------------------------------------------------------------
# DMA.WR3
#------------------------------------------------------------------------------

append_out("DMA.WR3\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr3 1
	dma.wr2 2
	dma.wr2 3
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v +zxn $test.asm >> $test.out 2>&1");
append_out("\n");


append_out("DMA.WR3\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr3 0
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v +zxn $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("DMA.WR3\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr3 4
	dma.wr3 32
	dma.wr3 64
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v +zxn $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("DMA.WR3\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr3 136
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v +zxn $test.asm >> $test.out 2>&1");
append_out("\n");


append_out("DMA.WR3\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr3 136, 23
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v +zxn $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("DMA.WR3\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr3 152, 23
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v +zxn $test.asm >> $test.out 2>&1");
append_out("\n");


append_out("DMA.WR3\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr3 152, 23, 45
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v +zxn $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


#------------------------------------------------------------------------------
# DMA.WR4
#------------------------------------------------------------------------------

append_out("DMA.WR4\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr4 2
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v +zxn $test.asm >> $test.out 2>&1");
append_out("\n");


append_out("DMA.WR4\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr4 17
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v +zxn $test.asm >> $test.out 2>&1");
append_out("\n");


append_out("DMA.WR4\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr4 1
	dma.wr4 97
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v +zxn $test.asm >> $test.out 2>&1");
append_out("\n");


append_out("DMA.WR4\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr4 64
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v +zxn $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("DMA.WR4\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr4 68
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v +zxn $test.asm >> $test.out 2>&1");
append_out("\n");


append_out("DMA.WR4\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr4 72
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v +zxn $test.asm >> $test.out 2>&1");
append_out("\n");


append_out("DMA.WR4\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr4 68, 23
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v +zxn $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("DMA.WR4\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr4 72, 23
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v +zxn $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("DMA.WR4\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr4 76
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v +zxn $test.asm >> $test.out 2>&1");
append_out("\n");


append_out("DMA.WR4\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr4 76, 4660
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v +zxn $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


#------------------------------------------------------------------------------
# DMA.WR5
#------------------------------------------------------------------------------

append_out("DMA.WR5\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr5 1
	dma.wr5 4
	dma.wr5 64
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v +zxn $test.asm >> $test.out 2>&1");
append_out("\n");


append_out("DMA.WR5\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr5 0
	dma.wr5 8
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v +zxn $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


#------------------------------------------------------------------------------
# DMA.WR6 | DMA.CMD
#------------------------------------------------------------------------------

append_out("DMA.WR6\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr6 0
	dma.cmd 0
	dma.wr6 1
	dma.cmd 1
	dma.wr6 2
	dma.cmd 2
	dma.wr6 3
	dma.cmd 3
	dma.wr6 4
	dma.cmd 4
	dma.wr6 5
	dma.cmd 5
	dma.wr6 6
	dma.cmd 6
	dma.wr6 7
	dma.cmd 7
	dma.wr6 8
	dma.cmd 8
	dma.wr6 9
	dma.cmd 9
	dma.wr6 10
	dma.cmd 10
	dma.wr6 11
	dma.cmd 11
	dma.wr6 12
	dma.cmd 12
	dma.wr6 13
	dma.cmd 13
	dma.wr6 14
	dma.cmd 14
	dma.wr6 15
	dma.cmd 15
	dma.wr6 16
	dma.cmd 16
	dma.wr6 17
	dma.cmd 17
	dma.wr6 18
	dma.cmd 18
	dma.wr6 19
	dma.cmd 19
	dma.wr6 20
	dma.cmd 20
	dma.wr6 21
	dma.cmd 21
	dma.wr6 22
	dma.cmd 22
	dma.wr6 23
	dma.cmd 23
	dma.wr6 24
	dma.cmd 24
	dma.wr6 25
	dma.cmd 25
	dma.wr6 26
	dma.cmd 26
	dma.wr6 27
	dma.cmd 27
	dma.wr6 28
	dma.cmd 28
	dma.wr6 29
	dma.cmd 29
	dma.wr6 30
	dma.cmd 30
	dma.wr6 31
	dma.cmd 31
	dma.wr6 32
	dma.cmd 32
	dma.wr6 33
	dma.cmd 33
	dma.wr6 34
	dma.cmd 34
	dma.wr6 35
	dma.cmd 35
	dma.wr6 36
	dma.cmd 36
	dma.wr6 37
	dma.cmd 37
	dma.wr6 38
	dma.cmd 38
	dma.wr6 39
	dma.cmd 39
	dma.wr6 40
	dma.cmd 40
	dma.wr6 41
	dma.cmd 41
	dma.wr6 42
	dma.cmd 42
	dma.wr6 43
	dma.cmd 43
	dma.wr6 44
	dma.cmd 44
	dma.wr6 45
	dma.cmd 45
	dma.wr6 46
	dma.cmd 46
	dma.wr6 47
	dma.cmd 47
	dma.wr6 48
	dma.cmd 48
	dma.wr6 49
	dma.cmd 49
	dma.wr6 50
	dma.cmd 50
	dma.wr6 51
	dma.cmd 51
	dma.wr6 52
	dma.cmd 52
	dma.wr6 53
	dma.cmd 53
	dma.wr6 54
	dma.cmd 54
	dma.wr6 55
	dma.cmd 55
	dma.wr6 56
	dma.cmd 56
	dma.wr6 57
	dma.cmd 57
	dma.wr6 58
	dma.cmd 58
	dma.wr6 59
	dma.cmd 59
	dma.wr6 60
	dma.cmd 60
	dma.wr6 61
	dma.cmd 61
	dma.wr6 62
	dma.cmd 62
	dma.wr6 63
	dma.cmd 63
	dma.wr6 64
	dma.cmd 64
	dma.wr6 65
	dma.cmd 65
	dma.wr6 66
	dma.cmd 66
	dma.wr6 67
	dma.cmd 67
	dma.wr6 68
	dma.cmd 68
	dma.wr6 69
	dma.cmd 69
	dma.wr6 70
	dma.cmd 70
	dma.wr6 71
	dma.cmd 71
	dma.wr6 72
	dma.cmd 72
	dma.wr6 73
	dma.cmd 73
	dma.wr6 74
	dma.cmd 74
	dma.wr6 75
	dma.cmd 75
	dma.wr6 76
	dma.cmd 76
	dma.wr6 77
	dma.cmd 77
	dma.wr6 78
	dma.cmd 78
	dma.wr6 79
	dma.cmd 79
	dma.wr6 80
	dma.cmd 80
	dma.wr6 81
	dma.cmd 81
	dma.wr6 82
	dma.cmd 82
	dma.wr6 83
	dma.cmd 83
	dma.wr6 84
	dma.cmd 84
	dma.wr6 85
	dma.cmd 85
	dma.wr6 86
	dma.cmd 86
	dma.wr6 87
	dma.cmd 87
	dma.wr6 88
	dma.cmd 88
	dma.wr6 89
	dma.cmd 89
	dma.wr6 90
	dma.cmd 90
	dma.wr6 91
	dma.cmd 91
	dma.wr6 92
	dma.cmd 92
	dma.wr6 93
	dma.cmd 93
	dma.wr6 94
	dma.cmd 94
	dma.wr6 95
	dma.cmd 95
	dma.wr6 96
	dma.cmd 96
	dma.wr6 97
	dma.cmd 97
	dma.wr6 98
	dma.cmd 98
	dma.wr6 99
	dma.cmd 99
	dma.wr6 100
	dma.cmd 100
	dma.wr6 101
	dma.cmd 101
	dma.wr6 102
	dma.cmd 102
	dma.wr6 103
	dma.cmd 103
	dma.wr6 104
	dma.cmd 104
	dma.wr6 105
	dma.cmd 105
	dma.wr6 106
	dma.cmd 106
	dma.wr6 107
	dma.cmd 107
	dma.wr6 108
	dma.cmd 108
	dma.wr6 109
	dma.cmd 109
	dma.wr6 110
	dma.cmd 110
	dma.wr6 111
	dma.cmd 111
	dma.wr6 112
	dma.cmd 112
	dma.wr6 113
	dma.cmd 113
	dma.wr6 114
	dma.cmd 114
	dma.wr6 115
	dma.cmd 115
	dma.wr6 116
	dma.cmd 116
	dma.wr6 117
	dma.cmd 117
	dma.wr6 118
	dma.cmd 118
	dma.wr6 119
	dma.cmd 119
	dma.wr6 120
	dma.cmd 120
	dma.wr6 121
	dma.cmd 121
	dma.wr6 122
	dma.cmd 122
	dma.wr6 123
	dma.cmd 123
	dma.wr6 124
	dma.cmd 124
	dma.wr6 125
	dma.cmd 125
	dma.wr6 126
	dma.cmd 126
	dma.wr6 127
	dma.cmd 127
	dma.wr6 128
	dma.cmd 128
	dma.wr6 129
	dma.cmd 129
	dma.wr6 130
	dma.cmd 130
	dma.wr6 132
	dma.cmd 132
	dma.wr6 133
	dma.cmd 133
	dma.wr6 134
	dma.cmd 134
	dma.wr6 136
	dma.cmd 136
	dma.wr6 137
	dma.cmd 137
	dma.wr6 138
	dma.cmd 138
	dma.wr6 140
	dma.cmd 140
	dma.wr6 141
	dma.cmd 141
	dma.wr6 142
	dma.cmd 142
	dma.wr6 143
	dma.cmd 143
	dma.wr6 144
	dma.cmd 144
	dma.wr6 145
	dma.cmd 145
	dma.wr6 146
	dma.cmd 146
	dma.wr6 147
	dma.cmd 147
	dma.wr6 148
	dma.cmd 148
	dma.wr6 149
	dma.cmd 149
	dma.wr6 150
	dma.cmd 150
	dma.wr6 151
	dma.cmd 151
	dma.wr6 152
	dma.cmd 152
	dma.wr6 153
	dma.cmd 153
	dma.wr6 154
	dma.cmd 154
	dma.wr6 155
	dma.cmd 155
	dma.wr6 156
	dma.cmd 156
	dma.wr6 157
	dma.cmd 157
	dma.wr6 158
	dma.cmd 158
	dma.wr6 159
	dma.cmd 159
	dma.wr6 160
	dma.cmd 160
	dma.wr6 161
	dma.cmd 161
	dma.wr6 162
	dma.cmd 162
	dma.wr6 164
	dma.cmd 164
	dma.wr6 165
	dma.cmd 165
	dma.wr6 166
	dma.cmd 166
	dma.wr6 168
	dma.cmd 168
	dma.wr6 169
	dma.cmd 169
	dma.wr6 170
	dma.cmd 170
	dma.wr6 172
	dma.cmd 172
	dma.wr6 173
	dma.cmd 173
	dma.wr6 174
	dma.cmd 174
	dma.wr6 176
	dma.cmd 176
	dma.wr6 177
	dma.cmd 177
	dma.wr6 178
	dma.cmd 178
	dma.wr6 180
	dma.cmd 180
	dma.wr6 181
	dma.cmd 181
	dma.wr6 182
	dma.cmd 182
	dma.wr6 184
	dma.cmd 184
	dma.wr6 185
	dma.cmd 185
	dma.wr6 186
	dma.cmd 186
	dma.wr6 188
	dma.cmd 188
	dma.wr6 189
	dma.cmd 189
	dma.wr6 190
	dma.cmd 190
	dma.wr6 192
	dma.cmd 192
	dma.wr6 193
	dma.cmd 193
	dma.wr6 194
	dma.cmd 194
	dma.wr6 196
	dma.cmd 196
	dma.wr6 197
	dma.cmd 197
	dma.wr6 198
	dma.cmd 198
	dma.wr6 200
	dma.cmd 200
	dma.wr6 201
	dma.cmd 201
	dma.wr6 202
	dma.cmd 202
	dma.wr6 204
	dma.cmd 204
	dma.wr6 205
	dma.cmd 205
	dma.wr6 206
	dma.cmd 206
	dma.wr6 208
	dma.cmd 208
	dma.wr6 209
	dma.cmd 209
	dma.wr6 210
	dma.cmd 210
	dma.wr6 212
	dma.cmd 212
	dma.wr6 213
	dma.cmd 213
	dma.wr6 214
	dma.cmd 214
	dma.wr6 215
	dma.cmd 215
	dma.wr6 216
	dma.cmd 216
	dma.wr6 217
	dma.cmd 217
	dma.wr6 218
	dma.cmd 218
	dma.wr6 219
	dma.cmd 219
	dma.wr6 220
	dma.cmd 220
	dma.wr6 221
	dma.cmd 221
	dma.wr6 222
	dma.cmd 222
	dma.wr6 223
	dma.cmd 223
	dma.wr6 224
	dma.cmd 224
	dma.wr6 225
	dma.cmd 225
	dma.wr6 226
	dma.cmd 226
	dma.wr6 227
	dma.cmd 227
	dma.wr6 228
	dma.cmd 228
	dma.wr6 229
	dma.cmd 229
	dma.wr6 230
	dma.cmd 230
	dma.wr6 231
	dma.cmd 231
	dma.wr6 232
	dma.cmd 232
	dma.wr6 233
	dma.cmd 233
	dma.wr6 234
	dma.cmd 234
	dma.wr6 235
	dma.cmd 235
	dma.wr6 236
	dma.cmd 236
	dma.wr6 237
	dma.cmd 237
	dma.wr6 238
	dma.cmd 238
	dma.wr6 239
	dma.cmd 239
	dma.wr6 240
	dma.cmd 240
	dma.wr6 241
	dma.cmd 241
	dma.wr6 242
	dma.cmd 242
	dma.wr6 243
	dma.cmd 243
	dma.wr6 244
	dma.cmd 244
	dma.wr6 245
	dma.cmd 245
	dma.wr6 246
	dma.cmd 246
	dma.wr6 247
	dma.cmd 247
	dma.wr6 248
	dma.cmd 248
	dma.wr6 249
	dma.cmd 249
	dma.wr6 250
	dma.cmd 250
	dma.wr6 251
	dma.cmd 251
	dma.wr6 252
	dma.cmd 252
	dma.wr6 253
	dma.cmd 253
	dma.wr6 254
	dma.cmd 254
	dma.wr6 255
	dma.cmd 255
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v +zxn $test.asm >> $test.out 2>&1");
append_out("\n");


append_out("DMA.WR6\n");
path("$test.asm")->spew(<<END);
	ld a,1
	
	dma.wr6 131
	dma.wr6 135
	dma.wr6 207
	dma.wr6 211
	
	dma.cmd 131
	dma.cmd 135
	dma.cmd 207
	dma.cmd 211
	
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v +zxn $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("DMA.WR6\n");
path("$test.asm")->spew(<<END);
	ld a,1
	
	dma.wr6 195
	dma.wr6 199
	dma.wr6 203
	dma.wr6 175
	dma.wr6 171
	dma.wr6 163
	dma.wr6 183
	dma.wr6 191
	dma.wr6 139 
	dma.wr6 167
	dma.wr6 179
	
	dma.cmd 195
	dma.cmd 199
	dma.cmd 203
	dma.cmd 175
	dma.cmd 171
	dma.cmd 163
	dma.cmd 183
	dma.cmd 191
	dma.cmd 139 
	dma.cmd 167
	dma.cmd 179
	
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v +zxn $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("DMA.WR6\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr6 187
	dma.cmd 187
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v +zxn $test.asm >> $test.out 2>&1");
append_out("\n");


append_out("DMA.WR6\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr6 187, 127
	dma.cmd 187, 127
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_ok("$exec -v +zxn $test.asm >> $test.out 2>&1");
run_ok("z88dk-z80nm -a $test.o >> $test.out 2>&1");
append_out("\n");


append_out("DMA.WR6\n");
path("$test.asm")->spew(<<END);
	ld a,1
	dma.wr6 187, 128
	dma.cmd 187, 128
	ld a,2
END

run_ok("$exec -E $test.asm >> $test.out 2>&1");
run_nok("$exec -v +zxn $test.asm >> $test.out 2>&1");
append_out("\n");


run_ok("diff -w $bmk $test.out");

unlink_testfiles();
done_testing();
