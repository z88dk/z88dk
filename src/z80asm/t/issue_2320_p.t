#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/2320
# z80asm: do not link with object files built for a different cpu

#------------------------------------------------------------------------------
# make multi-cpu library
#------------------------------------------------------------------------------

unlink_testfiles;
spew("$test.asm", <<'END');
		extern the_answer
		defb the_answer
END

spew("$test.1.asm", <<'END');
	public the_answer
the_answer = 42
	ifdef __CPU_8080__		      : defm "8080 "		  : endif
	ifdef __CPU_8085__		      : defm "8085 "		  : endif
	ifdef __CPU_EZ80__		      : defm "ez80 "		  : endif
	ifdef __CPU_EZ80_Z80__	      : defm "ez80_z80 "	  : endif
	ifdef __CPU_GBZ80__		      : defm "gbz80 "		  : endif
	ifdef __CPU_R800__		      : defm "r800 "		  : endif
	ifdef __CPU_R2KA__		      : defm "r2ka "		  : endif
	ifdef __CPU_R3K__		      : defm "r3k "			  : endif
	ifdef __CPU_R4K__		      : defm "r4k "			  : endif
	ifdef __CPU_R5K__		      : defm "r5k "			  : endif
	ifdef __CPU_R6K__		      : defm "r6k "			  : endif
	ifdef __CPU_Z180__		      : defm "z180 "		  : endif
	ifdef __CPU_Z80__		      : defm "z80 "			  : endif
	ifdef __CPU_Z80N__		      : defm "z80n " 		  : endif
	ifdef __CPU_KC160__		      : defm "kc160 "		  : endif
	ifdef __CPU_KC160_Z80__	      : defm "kc160_z80 " 	  : endif
	ifdef __SWAP_IX_IY__	      : defm "-IXIY "		  : endif
END

for my $lib_ixiy ("", "-IXIY") {
	unlink("$test.1.lib");
	capture_ok("z88dk-z80asm $lib_ixiy -m\"*\" -x$test.1.lib $test.1.asm", "");
	ok -f "$test.1.lib", "$test.1.lib created";
	
	capture_ok("z88dk-z80nm -a $test.1.lib", <<'END');
Library file test_t_issue_2320_p.1.lib at $0000: Z80LMF18
Object  file test_t_issue_2320_p.1.lib at $0014: Z80RMF18
  Name: test_t_issue_2320_p.1
  CPU:  z80n 
  Section "": 5 bytes
    C $0000: 7A 38 30 6E 20
  Symbols:
    L C $0001: __CPU_Z80N__ (section "") (file test_t_issue_2320_p.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_p.1.asm:2)

Object  file test_t_issue_2320_p.1.lib at $0108: Z80RMF18
  Name: test_t_issue_2320_p.1
  CPU:  z80n (-IXIY)
  Section "": 11 bytes
    C $0000: 7A 38 30 6E 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_Z80N__ (section "") (file test_t_issue_2320_p.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320_p.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_p.1.asm:2)

Object  file test_t_issue_2320_p.1.lib at $022C: Z80RMF18
  Name: test_t_issue_2320_p.1
  CPU:  r6k 
  Section "": 4 bytes
    C $0000: 72 36 6B 20
  Symbols:
    L C $0001: __CPU_R6K__ (section "") (file test_t_issue_2320_p.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_p.1.asm:2)

Object  file test_t_issue_2320_p.1.lib at $0318: Z80RMF18
  Name: test_t_issue_2320_p.1
  CPU:  r6k (-IXIY)
  Section "": 10 bytes
    C $0000: 72 36 6B 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_R6K__ (section "") (file test_t_issue_2320_p.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320_p.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_p.1.asm:2)

Object  file test_t_issue_2320_p.1.lib at $043C: Z80RMF18
  Name: test_t_issue_2320_p.1
  CPU:  z80 
  Section "": 4 bytes
    C $0000: 7A 38 30 20
  Symbols:
    L C $0001: __CPU_Z80__ (section "") (file test_t_issue_2320_p.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_p.1.asm:2)

Object  file test_t_issue_2320_p.1.lib at $0528: Z80RMF18
  Name: test_t_issue_2320_p.1
  CPU:  z80 (-IXIY)
  Section "": 10 bytes
    C $0000: 7A 38 30 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_Z80__ (section "") (file test_t_issue_2320_p.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320_p.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_p.1.asm:2)

Object  file test_t_issue_2320_p.1.lib at $064C: Z80RMF18
  Name: test_t_issue_2320_p.1
  CPU:  z180 
  Section "": 5 bytes
    C $0000: 7A 31 38 30 20
  Symbols:
    L C $0001: __CPU_Z180__ (section "") (file test_t_issue_2320_p.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_p.1.asm:2)

Object  file test_t_issue_2320_p.1.lib at $0740: Z80RMF18
  Name: test_t_issue_2320_p.1
  CPU:  z180 (-IXIY)
  Section "": 11 bytes
    C $0000: 7A 31 38 30 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_Z180__ (section "") (file test_t_issue_2320_p.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320_p.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_p.1.asm:2)

Object  file test_t_issue_2320_p.1.lib at $0864: Z80RMF18
  Name: test_t_issue_2320_p.1
  CPU:  r3k 
  Section "": 4 bytes
    C $0000: 72 33 6B 20
  Symbols:
    L C $0001: __CPU_R3K__ (section "") (file test_t_issue_2320_p.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_p.1.asm:2)

Object  file test_t_issue_2320_p.1.lib at $0950: Z80RMF18
  Name: test_t_issue_2320_p.1
  CPU:  r3k (-IXIY)
  Section "": 10 bytes
    C $0000: 72 33 6B 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_R3K__ (section "") (file test_t_issue_2320_p.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320_p.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_p.1.asm:2)

Object  file test_t_issue_2320_p.1.lib at $0A74: Z80RMF18
  Name: test_t_issue_2320_p.1
  CPU:  8085 
  Section "": 5 bytes
    C $0000: 38 30 38 35 20
  Symbols:
    L C $0001: __CPU_8085__ (section "") (file test_t_issue_2320_p.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_p.1.asm:2)

Object  file test_t_issue_2320_p.1.lib at $0B68: Z80RMF18
  Name: test_t_issue_2320_p.1
  CPU:  8085 (-IXIY)
  Section "": 11 bytes
    C $0000: 38 30 38 35 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_8085__ (section "") (file test_t_issue_2320_p.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320_p.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_p.1.asm:2)

Object  file test_t_issue_2320_p.1.lib at $0C8C: Z80RMF18
  Name: test_t_issue_2320_p.1
  CPU:  r800 
  Section "": 5 bytes
    C $0000: 72 38 30 30 20
  Symbols:
    L C $0001: __CPU_R800__ (section "") (file test_t_issue_2320_p.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_p.1.asm:2)

Object  file test_t_issue_2320_p.1.lib at $0D80: Z80RMF18
  Name: test_t_issue_2320_p.1
  CPU:  r800 (-IXIY)
  Section "": 11 bytes
    C $0000: 72 38 30 30 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_R800__ (section "") (file test_t_issue_2320_p.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320_p.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_p.1.asm:2)

Object  file test_t_issue_2320_p.1.lib at $0EA4: Z80RMF18
  Name: test_t_issue_2320_p.1
  CPU:  r5k 
  Section "": 4 bytes
    C $0000: 72 35 6B 20
  Symbols:
    L C $0001: __CPU_R5K__ (section "") (file test_t_issue_2320_p.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_p.1.asm:2)

Object  file test_t_issue_2320_p.1.lib at $0F90: Z80RMF18
  Name: test_t_issue_2320_p.1
  CPU:  r5k (-IXIY)
  Section "": 10 bytes
    C $0000: 72 35 6B 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_R5K__ (section "") (file test_t_issue_2320_p.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320_p.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_p.1.asm:2)

Object  file test_t_issue_2320_p.1.lib at $10B4: Z80RMF18
  Name: test_t_issue_2320_p.1
  CPU:  kc160_z80 
  Section "": 10 bytes
    C $0000: 6B 63 31 36 30 5F 7A 38 30 20
  Symbols:
    L C $0001: __CPU_KC160_Z80__ (section "") (file test_t_issue_2320_p.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_p.1.asm:2)

Object  file test_t_issue_2320_p.1.lib at $11B0: Z80RMF18
  Name: test_t_issue_2320_p.1
  CPU:  kc160_z80 (-IXIY)
  Section "": 16 bytes
    C $0000: 6B 63 31 36 30 5F 7A 38 30 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_KC160_Z80__ (section "") (file test_t_issue_2320_p.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320_p.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_p.1.asm:2)

Object  file test_t_issue_2320_p.1.lib at $12E0: Z80RMF18
  Name: test_t_issue_2320_p.1
  CPU:  ez80_z80 
  Section "": 9 bytes
    C $0000: 65 7A 38 30 5F 7A 38 30 20
  Symbols:
    L C $0001: __CPU_EZ80_Z80__ (section "") (file test_t_issue_2320_p.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_p.1.asm:2)

Object  file test_t_issue_2320_p.1.lib at $13DC: Z80RMF18
  Name: test_t_issue_2320_p.1
  CPU:  ez80_z80 (-IXIY)
  Section "": 15 bytes
    C $0000: 65 7A 38 30 5F 7A 38 30 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_EZ80_Z80__ (section "") (file test_t_issue_2320_p.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320_p.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_p.1.asm:2)

Object  file test_t_issue_2320_p.1.lib at $1508: Z80RMF18
  Name: test_t_issue_2320_p.1
  CPU:  ez80 
  Section "": 5 bytes
    C $0000: 65 7A 38 30 20
  Symbols:
    L C $0001: __CPU_EZ80__ (section "") (file test_t_issue_2320_p.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_p.1.asm:2)

Object  file test_t_issue_2320_p.1.lib at $15FC: Z80RMF18
  Name: test_t_issue_2320_p.1
  CPU:  ez80 (-IXIY)
  Section "": 11 bytes
    C $0000: 65 7A 38 30 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_EZ80__ (section "") (file test_t_issue_2320_p.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320_p.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_p.1.asm:2)

Object  file test_t_issue_2320_p.1.lib at $1720: Z80RMF18
  Name: test_t_issue_2320_p.1
  CPU:  r2ka 
  Section "": 5 bytes
    C $0000: 72 32 6B 61 20
  Symbols:
    L C $0001: __CPU_R2KA__ (section "") (file test_t_issue_2320_p.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_p.1.asm:2)

Object  file test_t_issue_2320_p.1.lib at $1814: Z80RMF18
  Name: test_t_issue_2320_p.1
  CPU:  r2ka (-IXIY)
  Section "": 11 bytes
    C $0000: 72 32 6B 61 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_R2KA__ (section "") (file test_t_issue_2320_p.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320_p.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_p.1.asm:2)

Object  file test_t_issue_2320_p.1.lib at $1938: Z80RMF18
  Name: test_t_issue_2320_p.1
  CPU:  gbz80 
  Section "": 6 bytes
    C $0000: 67 62 7A 38 30 20
  Symbols:
    L C $0001: __CPU_GBZ80__ (section "") (file test_t_issue_2320_p.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_p.1.asm:2)

Object  file test_t_issue_2320_p.1.lib at $1A2C: Z80RMF18
  Name: test_t_issue_2320_p.1
  CPU:  gbz80 (-IXIY)
  Section "": 12 bytes
    C $0000: 67 62 7A 38 30 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_GBZ80__ (section "") (file test_t_issue_2320_p.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320_p.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_p.1.asm:2)

Object  file test_t_issue_2320_p.1.lib at $1B54: Z80RMF18
  Name: test_t_issue_2320_p.1
  CPU:  8080 
  Section "": 5 bytes
    C $0000: 38 30 38 30 20
  Symbols:
    L C $0001: __CPU_8080__ (section "") (file test_t_issue_2320_p.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_p.1.asm:2)

Object  file test_t_issue_2320_p.1.lib at $1C48: Z80RMF18
  Name: test_t_issue_2320_p.1
  CPU:  8080 (-IXIY)
  Section "": 11 bytes
    C $0000: 38 30 38 30 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_8080__ (section "") (file test_t_issue_2320_p.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320_p.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_p.1.asm:2)

Object  file test_t_issue_2320_p.1.lib at $1D6C: Z80RMF18
  Name: test_t_issue_2320_p.1
  CPU:  r4k 
  Section "": 4 bytes
    C $0000: 72 34 6B 20
  Symbols:
    L C $0001: __CPU_R4K__ (section "") (file test_t_issue_2320_p.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_p.1.asm:2)

Object  file test_t_issue_2320_p.1.lib at $1E58: Z80RMF18
  Name: test_t_issue_2320_p.1
  CPU:  r4k (-IXIY)
  Section "": 10 bytes
    C $0000: 72 34 6B 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_R4K__ (section "") (file test_t_issue_2320_p.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320_p.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_p.1.asm:2)

Object  file test_t_issue_2320_p.1.lib at $1F7C: Z80RMF18
  Name: test_t_issue_2320_p.1
  CPU:  kc160 
  Section "": 6 bytes
    C $0000: 6B 63 31 36 30 20
  Symbols:
    L C $0001: __CPU_KC160__ (section "") (file test_t_issue_2320_p.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_p.1.asm:2)

Object  file test_t_issue_2320_p.1.lib at $2070: Z80RMF18
  Name: test_t_issue_2320_p.1
  CPU:  kc160 (-IXIY)
  Section "": 12 bytes
    C $0000: 6B 63 31 36 30 20 2D 49 58 49 59 20
  Symbols:
    L C $0001: __CPU_KC160__ (section "") (file test_t_issue_2320_p.1.asm)
    L C $0001: __SWAP_IX_IY__ (section "") (file test_t_issue_2320_p.1.asm)
    G C $002A: the_answer (section "") (file test_t_issue_2320_p.1.asm:2)

END

	for my $code_ixiy ("", "-IXIY", "-IXIY-soft") {
		for my $code_cpu (@CPUS) {
            (my $linked_cpu = $code_cpu) =~ s/_strict$//;
			unlink("$test.bin");
			capture_ok("z88dk-z80asm -b -m$code_cpu $code_ixiy ".
							   "-l$test.1.lib $test.asm", "");
			ok -f "$test.bin", "$test.bin created";
			my %CODE_IXIY = (""=>"", "-IXIY"=>"-IXIY ", "-IXIY-soft"=>"");
			check_bin_file("$test.bin", bytes(42).$linked_cpu." ".$CODE_IXIY{$code_ixiy});
		}
	}
}

unlink_testfiles;
done_testing;
