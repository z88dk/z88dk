#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/2320
# z80asm: do not link with object files built for a different cpu


# make multi-cpu library

unlink_testfiles;
spew("$test.asm", <<'END');
		extern the_answer
		defb the_answer
END

spew("$test.1.asm", <<'END');
	public the_answer
the_answer = 42
	ifdef __CPU_8080__		: defm "8080"		: endif
	ifdef __CPU_8085__		: defm "8085"		: endif
	ifdef __CPU_EZ80_ADL__	: defm "ez80"		: endif
	ifdef __CPU_EZ80_Z80__	: defm "ez80_z80"	: endif
	ifdef __CPU_GBZ80__		: defm "gbz80"		: endif
	ifdef __CPU_R800__		: defm "r800"		: endif
	ifdef __CPU_R2KA__		: defm "r2ka"		: endif
	ifdef __CPU_R3K__		: defm "r3k"		: endif
	ifdef __CPU_R4K__		: defm "r4k"		: endif
	ifdef __CPU_R5K__		: defm "r5k"		: endif
	ifdef __CPU_Z180__		: defm "z180"		: endif
	ifdef __CPU_Z80__		: defm "z80"		: endif
	ifdef __CPU_Z80_STRICT__: defm "z80_strict"	: endif
	ifdef __CPU_Z80N__		: defm "z80n" 		: endif
	ifdef __SWAP_IX_IY__	: defm "-IXIY"		: endif
END

for my $lib_ixiy ("", "-IXIY") {
	unlink("$test.1.lib");
	capture_ok("z88dk-z80asm $lib_ixiy -m\"*\" -x$test.1.lib $test.1.asm", "");
	ok -f "$test.1.lib", "$test.1.lib created";
	
	capture_ok("z88dk-z80nm -a $test.1.lib", <<'END');
Library file test_t_issue_2320_26.1.lib at $0000: Z80LMF18
Object  file test_t_issue_2320_26.1.lib at $0014: Z80RMF18
  Name: test_t_issue_2320_26.1
  CPU:  z80n 
  Section "": 4 bytes
    C $0000: 7A 38 30 6E
  Symbols:
    L C $0001: __CPU_Z80N__ (section "") (file test_t_issue_2320_26.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_26.1.asm:2)

Object  file test_t_issue_2320_26.1.lib at $0104: Z80RMF18
  Name: test_t_issue_2320_26.1
  CPU:  z80n (-IXIY)
  Section "": 9 bytes
    C $0000: 7A 38 30 6E 2D 49 58 49 59
  Symbols:
    L C $0001: __CPU_Z80N__ (section "") (file test_t_issue_2320_26.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320_26.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_26.1.asm:2)

Object  file test_t_issue_2320_26.1.lib at $022C: Z80RMF18
  Name: test_t_issue_2320_26.1
  CPU:  z80 
  Section "": 3 bytes
    C $0000: 7A 38 30
  Symbols:
    L C $0001: __CPU_Z80__ (section "") (file test_t_issue_2320_26.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_26.1.asm:2)

Object  file test_t_issue_2320_26.1.lib at $031C: Z80RMF18
  Name: test_t_issue_2320_26.1
  CPU:  z80 (-IXIY)
  Section "": 8 bytes
    C $0000: 7A 38 30 2D 49 58 49 59
  Symbols:
    L C $0001: __CPU_Z80__ (section "") (file test_t_issue_2320_26.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320_26.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_26.1.asm:2)

Object  file test_t_issue_2320_26.1.lib at $0440: Z80RMF18
  Name: test_t_issue_2320_26.1
  CPU:  ez80_z80 
  Section "": 8 bytes
    C $0000: 65 7A 38 30 5F 7A 38 30
  Symbols:
    L C $0001: __CPU_EZ80_Z80__ (section "") (file test_t_issue_2320_26.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_26.1.asm:2)

Object  file test_t_issue_2320_26.1.lib at $0538: Z80RMF18
  Name: test_t_issue_2320_26.1
  CPU:  ez80_z80 (-IXIY)
  Section "": 13 bytes
    C $0000: 65 7A 38 30 5F 7A 38 30 2D 49 58 49 59
  Symbols:
    L C $0001: __CPU_EZ80_Z80__ (section "") (file test_t_issue_2320_26.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320_26.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_26.1.asm:2)

Object  file test_t_issue_2320_26.1.lib at $0668: Z80RMF18
  Name: test_t_issue_2320_26.1
  CPU:  r800 
  Section "": 4 bytes
    C $0000: 72 38 30 30
  Symbols:
    L C $0001: __CPU_R800__ (section "") (file test_t_issue_2320_26.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_26.1.asm:2)

Object  file test_t_issue_2320_26.1.lib at $0758: Z80RMF18
  Name: test_t_issue_2320_26.1
  CPU:  r800 (-IXIY)
  Section "": 9 bytes
    C $0000: 72 38 30 30 2D 49 58 49 59
  Symbols:
    L C $0001: __CPU_R800__ (section "") (file test_t_issue_2320_26.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320_26.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_26.1.asm:2)

Object  file test_t_issue_2320_26.1.lib at $0880: Z80RMF18
  Name: test_t_issue_2320_26.1
  CPU:  z180 
  Section "": 4 bytes
    C $0000: 7A 31 38 30
  Symbols:
    L C $0001: __CPU_Z180__ (section "") (file test_t_issue_2320_26.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_26.1.asm:2)

Object  file test_t_issue_2320_26.1.lib at $0970: Z80RMF18
  Name: test_t_issue_2320_26.1
  CPU:  z180 (-IXIY)
  Section "": 9 bytes
    C $0000: 7A 31 38 30 2D 49 58 49 59
  Symbols:
    L C $0001: __CPU_Z180__ (section "") (file test_t_issue_2320_26.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320_26.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_26.1.asm:2)

Object  file test_t_issue_2320_26.1.lib at $0A98: Z80RMF18
  Name: test_t_issue_2320_26.1
  CPU:  z80_strict 
  Section "": 10 bytes
    C $0000: 7A 38 30 5F 73 74 72 69 63 74
  Symbols:
    L C $0001: __CPU_Z80_STRICT__ (section "") (file test_t_issue_2320_26.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_26.1.asm:2)

Object  file test_t_issue_2320_26.1.lib at $0B98: Z80RMF18
  Name: test_t_issue_2320_26.1
  CPU:  z80_strict (-IXIY)
  Section "": 15 bytes
    C $0000: 7A 38 30 5F 73 74 72 69 63 74 2D 49 58 49 59
  Symbols:
    L C $0001: __CPU_Z80_STRICT__ (section "") (file test_t_issue_2320_26.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320_26.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_26.1.asm:2)

Object  file test_t_issue_2320_26.1.lib at $0CC8: Z80RMF18
  Name: test_t_issue_2320_26.1
  CPU:  8085 
  Section "": 4 bytes
    C $0000: 38 30 38 35
  Symbols:
    L C $0001: __CPU_8085__ (section "") (file test_t_issue_2320_26.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_26.1.asm:2)

Object  file test_t_issue_2320_26.1.lib at $0DB8: Z80RMF18
  Name: test_t_issue_2320_26.1
  CPU:  8085 (-IXIY)
  Section "": 9 bytes
    C $0000: 38 30 38 35 2D 49 58 49 59
  Symbols:
    L C $0001: __CPU_8085__ (section "") (file test_t_issue_2320_26.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320_26.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_26.1.asm:2)

Object  file test_t_issue_2320_26.1.lib at $0EE0: Z80RMF18
  Name: test_t_issue_2320_26.1
  CPU:  r5k 
  Section "": 3 bytes
    C $0000: 72 35 6B
  Symbols:
    L C $0001: __CPU_R5K__ (section "") (file test_t_issue_2320_26.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_26.1.asm:2)

Object  file test_t_issue_2320_26.1.lib at $0FD0: Z80RMF18
  Name: test_t_issue_2320_26.1
  CPU:  r5k (-IXIY)
  Section "": 8 bytes
    C $0000: 72 35 6B 2D 49 58 49 59
  Symbols:
    L C $0001: __CPU_R5K__ (section "") (file test_t_issue_2320_26.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320_26.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_26.1.asm:2)

Object  file test_t_issue_2320_26.1.lib at $10F4: Z80RMF18
  Name: test_t_issue_2320_26.1
  CPU:  r4k 
  Section "": 3 bytes
    C $0000: 72 34 6B
  Symbols:
    L C $0001: __CPU_R4K__ (section "") (file test_t_issue_2320_26.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_26.1.asm:2)

Object  file test_t_issue_2320_26.1.lib at $11E4: Z80RMF18
  Name: test_t_issue_2320_26.1
  CPU:  r4k (-IXIY)
  Section "": 8 bytes
    C $0000: 72 34 6B 2D 49 58 49 59
  Symbols:
    L C $0001: __CPU_R4K__ (section "") (file test_t_issue_2320_26.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320_26.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_26.1.asm:2)

Object  file test_t_issue_2320_26.1.lib at $1308: Z80RMF18
  Name: test_t_issue_2320_26.1
  CPU:  r3k 
  Section "": 3 bytes
    C $0000: 72 33 6B
  Symbols:
    L C $0001: __CPU_R3K__ (section "") (file test_t_issue_2320_26.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_26.1.asm:2)

Object  file test_t_issue_2320_26.1.lib at $13F8: Z80RMF18
  Name: test_t_issue_2320_26.1
  CPU:  r3k (-IXIY)
  Section "": 8 bytes
    C $0000: 72 33 6B 2D 49 58 49 59
  Symbols:
    L C $0001: __CPU_R3K__ (section "") (file test_t_issue_2320_26.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320_26.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_26.1.asm:2)

Object  file test_t_issue_2320_26.1.lib at $151C: Z80RMF18
  Name: test_t_issue_2320_26.1
  CPU:  r2ka 
  Section "": 4 bytes
    C $0000: 72 32 6B 61
  Symbols:
    L C $0001: __CPU_R2KA__ (section "") (file test_t_issue_2320_26.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_26.1.asm:2)

Object  file test_t_issue_2320_26.1.lib at $160C: Z80RMF18
  Name: test_t_issue_2320_26.1
  CPU:  r2ka (-IXIY)
  Section "": 9 bytes
    C $0000: 72 32 6B 61 2D 49 58 49 59
  Symbols:
    L C $0001: __CPU_R2KA__ (section "") (file test_t_issue_2320_26.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320_26.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_26.1.asm:2)

Object  file test_t_issue_2320_26.1.lib at $1734: Z80RMF18
  Name: test_t_issue_2320_26.1
  CPU:  gbz80 
  Section "": 5 bytes
    C $0000: 67 62 7A 38 30
  Symbols:
    L C $0001: __CPU_GBZ80__ (section "") (file test_t_issue_2320_26.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_26.1.asm:2)

Object  file test_t_issue_2320_26.1.lib at $1828: Z80RMF18
  Name: test_t_issue_2320_26.1
  CPU:  gbz80 (-IXIY)
  Section "": 10 bytes
    C $0000: 67 62 7A 38 30 2D 49 58 49 59
  Symbols:
    L C $0001: __CPU_GBZ80__ (section "") (file test_t_issue_2320_26.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320_26.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_26.1.asm:2)

Object  file test_t_issue_2320_26.1.lib at $1950: Z80RMF18
  Name: test_t_issue_2320_26.1
  CPU:  ez80 
  Section "": 4 bytes
    C $0000: 65 7A 38 30
  Symbols:
    L C $0001: __CPU_EZ80_ADL__ (section "") (file test_t_issue_2320_26.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_26.1.asm:2)

Object  file test_t_issue_2320_26.1.lib at $1A44: Z80RMF18
  Name: test_t_issue_2320_26.1
  CPU:  ez80 (-IXIY)
  Section "": 9 bytes
    C $0000: 65 7A 38 30 2D 49 58 49 59
  Symbols:
    L C $0001: __CPU_EZ80_ADL__ (section "") (file test_t_issue_2320_26.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320_26.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_26.1.asm:2)

Object  file test_t_issue_2320_26.1.lib at $1B70: Z80RMF18
  Name: test_t_issue_2320_26.1
  CPU:  8080 
  Section "": 4 bytes
    C $0000: 38 30 38 30
  Symbols:
    L C $0001: __CPU_8080__ (section "") (file test_t_issue_2320_26.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_26.1.asm:2)

Object  file test_t_issue_2320_26.1.lib at $1C60: Z80RMF18
  Name: test_t_issue_2320_26.1
  CPU:  8080 (-IXIY)
  Section "": 9 bytes
    C $0000: 38 30 38 30 2D 49 58 49 59
  Symbols:
    L C $0001: __CPU_8080__ (section "") (file test_t_issue_2320_26.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320_26.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_26.1.asm:2)

END

	for my $code_ixiy ("", "-IXIY", "-IXIY-soft") {
		for my $code_cpu (@CPUS) {
			unlink("$test.bin");
			capture_ok("z88dk-z80asm -b -m$code_cpu $code_ixiy ".
							   "-l$test.1.lib $test.asm", "");
			ok -f "$test.bin", "$test.bin created";
			my %CODE_IXIY = (""=>"", "-IXIY"=>"-IXIY", "-IXIY-soft"=>"");
			check_bin_file("$test.bin", bytes(42).$code_cpu.$CODE_IXIY{$code_ixiy});
		}
	}
}


unlink_testfiles;
done_testing;
