#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/2320
# z80asm: do not link with object files built for a different cpu


# make -XIIY-soft library

unlink_testfiles;
spew("$test.asm", <<'END');
		extern the_answer
		defb the_answer
END

spew("$test.1.asm", <<'END');
	public the_answer
the_answer = 42
	ifdef __CPU_8080__		: defm "8080 "		: endif
	ifdef __CPU_8085__		: defm "8085 "		: endif
	ifdef __CPU_EZ80__		: defm "ez80 "		: endif
	ifdef __CPU_EZ80_ADL__	: defm "ez80_adl "	: endif
	ifdef __CPU_EZ80_Z80__	: defm "ez80_z80 "	: endif
	ifdef __CPU_GBZ80__		: defm "gbz80 "		: endif
	ifdef __CPU_R800__		: defm "r800 "		: endif
	ifdef __CPU_R2KA__		: defm "r2ka "		: endif
	ifdef __CPU_R3K__		: defm "r3k "		: endif
	ifdef __CPU_R4K__		: defm "r4k "		: endif
	ifdef __CPU_R5K__		: defm "r5k "		: endif
	ifdef __CPU_Z180__		: defm "z180 "		: endif
	ifdef __CPU_Z80__		: defm "z80 "		: endif
	ifdef __CPU_Z80_STRICT__: defm "z80_strict ": endif
	ifdef __CPU_Z80N__		: defm "z80n " 		: endif
	ifdef __CPU_KC160__		: defm "kc160 " 	: endif
	ifdef __CPU_KC160_EXT__	: defm "kc160_ext "	: endif
	ifdef __CPU_KC160_Z80__	: defm "kc160_z80 " : endif
	ifdef __SWAP_IX_IY__	: defm "-IXIY "		: endif
END

unlink("$test.1.lib");
capture_ok("z88dk-z80asm -IXIY-soft -m\"*\" -x$test.1.lib $test.1.asm", "");
ok -f "$test.1.lib", "$test.1.lib created";

capture_ok("z88dk-z80nm -a $test.1.lib", <<'END');
Library file test_t_issue_2320_27.1.lib at $0000: Z80LMF18
Object  file test_t_issue_2320_27.1.lib at $0014: Z80RMF18
  Name: test_t_issue_2320_27.1
  CPU:  z80n (-IXIY-soft)
  Section "": 11 bytes
    C $0000: 7A 38 30 6E 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_Z80N__ (section "") (file test_t_issue_2320_27.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320_27.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_27.1.asm:2)

Object  file test_t_issue_2320_27.1.lib at $013C: Z80RMF18
  Name: test_t_issue_2320_27.1
  CPU:  z80 (-IXIY-soft)
  Section "": 10 bytes
    C $0000: 7A 38 30 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_Z80__ (section "") (file test_t_issue_2320_27.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320_27.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_27.1.asm:2)

Object  file test_t_issue_2320_27.1.lib at $0264: Z80RMF18
  Name: test_t_issue_2320_27.1
  CPU:  z180 (-IXIY-soft)
  Section "": 11 bytes
    C $0000: 7A 31 38 30 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_Z180__ (section "") (file test_t_issue_2320_27.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320_27.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_27.1.asm:2)

Object  file test_t_issue_2320_27.1.lib at $038C: Z80RMF18
  Name: test_t_issue_2320_27.1
  CPU:  r800 (-IXIY-soft)
  Section "": 11 bytes
    C $0000: 72 38 30 30 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_R800__ (section "") (file test_t_issue_2320_27.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320_27.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_27.1.asm:2)

Object  file test_t_issue_2320_27.1.lib at $04B4: Z80RMF18
  Name: test_t_issue_2320_27.1
  CPU:  kc160_z80 (-IXIY-soft)
  Section "": 16 bytes
    C $0000: 6B 63 31 36 30 5F 7A 38 30 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_KC160_Z80__ (section "") (file test_t_issue_2320_27.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320_27.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_27.1.asm:2)

Object  file test_t_issue_2320_27.1.lib at $05E4: Z80RMF18
  Name: test_t_issue_2320_27.1
  CPU:  z80_strict (-IXIY-soft)
  Section "": 17 bytes
    C $0000: 7A 38 30 5F 73 74 72 69 63 74 20 2D 49 58 49 59
    C $0010: 20
  Symbols:
    L C $0001: __CPU_Z80_STRICT__ (section "") (file test_t_issue_2320_27.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320_27.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_27.1.asm:2)

Object  file test_t_issue_2320_27.1.lib at $0718: Z80RMF18
  Name: test_t_issue_2320_27.1
  CPU:  r3k (-IXIY-soft)
  Section "": 10 bytes
    C $0000: 72 33 6B 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_R3K__ (section "") (file test_t_issue_2320_27.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320_27.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_27.1.asm:2)

Object  file test_t_issue_2320_27.1.lib at $0840: Z80RMF18
  Name: test_t_issue_2320_27.1
  CPU:  8085 (-IXIY-soft)
  Section "": 11 bytes
    C $0000: 38 30 38 35 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_8085__ (section "") (file test_t_issue_2320_27.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320_27.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_27.1.asm:2)

Object  file test_t_issue_2320_27.1.lib at $0968: Z80RMF18
  Name: test_t_issue_2320_27.1
  CPU:  r5k (-IXIY-soft)
  Section "": 10 bytes
    C $0000: 72 35 6B 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_R5K__ (section "") (file test_t_issue_2320_27.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320_27.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_27.1.asm:2)

Object  file test_t_issue_2320_27.1.lib at $0A90: Z80RMF18
  Name: test_t_issue_2320_27.1
  CPU:  ez80_z80 (-IXIY-soft)
  Section "": 15 bytes
    C $0000: 65 7A 38 30 5F 7A 38 30 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_EZ80_Z80__ (section "") (file test_t_issue_2320_27.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320_27.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_27.1.asm:2)

Object  file test_t_issue_2320_27.1.lib at $0BC0: Z80RMF18
  Name: test_t_issue_2320_27.1
  CPU:  ez80 (-IXIY-soft)
  Section "": 11 bytes
    C $0000: 65 7A 38 30 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_EZ80__ (section "") (file test_t_issue_2320_27.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320_27.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_27.1.asm:2)

Object  file test_t_issue_2320_27.1.lib at $0CE8: Z80RMF18
  Name: test_t_issue_2320_27.1
  CPU:  r2ka (-IXIY-soft)
  Section "": 11 bytes
    C $0000: 72 32 6B 61 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_R2KA__ (section "") (file test_t_issue_2320_27.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320_27.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_27.1.asm:2)

Object  file test_t_issue_2320_27.1.lib at $0E10: Z80RMF18
  Name: test_t_issue_2320_27.1
  CPU:  gbz80 (-IXIY-soft)
  Section "": 12 bytes
    C $0000: 67 62 7A 38 30 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_GBZ80__ (section "") (file test_t_issue_2320_27.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320_27.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_27.1.asm:2)

Object  file test_t_issue_2320_27.1.lib at $0F38: Z80RMF18
  Name: test_t_issue_2320_27.1
  CPU:  8080 (-IXIY-soft)
  Section "": 11 bytes
    C $0000: 38 30 38 30 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_8080__ (section "") (file test_t_issue_2320_27.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320_27.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_27.1.asm:2)

Object  file test_t_issue_2320_27.1.lib at $1060: Z80RMF18
  Name: test_t_issue_2320_27.1
  CPU:  r4k (-IXIY-soft)
  Section "": 10 bytes
    C $0000: 72 34 6B 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_R4K__ (section "") (file test_t_issue_2320_27.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320_27.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_27.1.asm:2)

Object  file test_t_issue_2320_27.1.lib at $1188: Z80RMF18
  Name: test_t_issue_2320_27.1
  CPU:  kc160 (-IXIY-soft)
  Section "": 12 bytes
    C $0000: 6B 63 31 36 30 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_KC160__ (section "") (file test_t_issue_2320_27.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320_27.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_27.1.asm:2)

END


for my $code_ixiy ("", "-IXIY", "-IXIY-soft") {
	for my $code_cpu (@CPUS) {
		if ($code_ixiy ne "-IXIY") {
			unlink("$test.bin");
			capture_ok("z88dk-z80asm -b -m$code_cpu $code_ixiy ".
							   "-l$test.1.lib $test.asm", "");
			ok -f "$test.bin", "$test.bin created";
			check_bin_file("$test.bin", bytes(42).$code_cpu." -IXIY ");
		}
		else {
			capture_nok("z88dk-z80asm -b -m$code_cpu -IXIY ".
					"-l$test.1.lib $test.asm", <<END);
$test.asm:2: error: undefined symbol: the_answer
  ^---- the_answer
END
		}
	}
}


unlink_testfiles;
done_testing;
