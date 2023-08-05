#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/2320
# z80asm: do not link with object files built for a different cpu

my @CPUS = qw( z80 z80_strict z80n z180 ez80 ez80_z80 r2ka r3k 8080 8085 gbz80 );


# link object files

for my $lib_ixiy ("", "-IXIY", "-IXIY-soft") {
	my $lib_ixiy_cpu = $lib_ixiy ? "($lib_ixiy)" : "";
	my %IXIY_ERROR = (""=>"(no option)", "-IXIY"=>"-IXIY", "-IXIY-soft"=>"-IXIY-soft");
		
	for my $lib_cpu (@CPUS) {
		
		spew("$test.1.asm", <<END);
				public the_answer
		the_answer = 42
END
		# make object file and library
		unlink("$test.1.o", "$test.1.lib");
		capture_ok("z88dk-z80asm -m$lib_cpu -x$test.1.lib $lib_ixiy $test.1.asm", "");
		ok -f "$test.1.o", "$test.1.o created";
		ok -f "$test.1.lib", "$test.1.lib created";
		ok unlink("$test.1.asm"), "remove $test.1.asm";
		
		
		capture_ok("z88dk-z80nm -a $test.1.o", <<END);
Object  file $test.1.o at \$0000: Z80RMF18
  Name: $test.1
  CPU:  $lib_cpu $lib_ixiy_cpu
  Symbols:
    G C \$002A the_answer (section "") (file $test.1.asm:2)
END

		capture_ok("z88dk-z80nm -a $test.1.lib", <<END);
Library file $test.1.lib at \$0000: Z80LMF18
Object  file $test.1.lib at \$0010: Z80RMF18
  Name: $test.1
  CPU:  $lib_cpu $lib_ixiy_cpu
  Symbols:
    G C \$002A the_answer (section "") (file $test.1.asm:2)

END

		# link with object and library
		spew("$test.asm", <<END);
				extern the_answer
				defb the_answer
END

		for my $code_ixiy ("", "-IXIY", "-IXIY-soft") {
			for my $code_cpu (@CPUS) {
				if (!cpu_compatible($code_cpu, $lib_cpu)) {
					capture_nok("z88dk-z80asm -b -m$code_cpu $code_ixiy ".
						    "$test.asm $test.1.o", <<END);
error: CPU incompatible: file $test.1.o compiled for $lib_cpu, incompatible with $code_cpu
END

					capture_nok("z88dk-z80asm -b -m$code_cpu $code_ixiy ".
						    "-l$test.1.lib $test.asm", <<END);
$test.asm:2: error: undefined symbol: the_answer
  ^---- the_answer
END
				}
				elsif (!ixiy_compatible($code_ixiy, $lib_ixiy)) {
					capture_nok("z88dk-z80asm -b -m$code_cpu $code_ixiy ".
						    "$test.asm $test.1.o", <<END);
error: -IXIY incompatible: file $test.1.o compiled with $IXIY_ERROR{$lib_ixiy}, incompatible with $IXIY_ERROR{$code_ixiy}
END

					capture_nok("z88dk-z80asm -b -m$code_cpu $code_ixiy ".
						    "-l$test.1.lib $test.asm", <<END);
$test.asm:2: error: undefined symbol: the_answer
  ^---- the_answer
END

				}
				else {
					unlink("$test.bin");
					capture_ok("z88dk-z80asm -b -m$code_cpu $code_ixiy ".
							"$test.asm $test.1.o", "");
					check_bin_file("$test.bin", bytes(42));
					
					unlink("$test.bin");
					capture_ok("z88dk-z80asm -b -m$code_cpu $code_ixiy ".
							"-l$test.1.lib $test.asm", "");
					check_bin_file("$test.bin", bytes(42));
				}
			}
		}
	}
}

# make multi-cpu library


spew("$test.asm", <<END);
		extern the_answer
		defb the_answer
END

spew("$test.1.asm", <<END);
	public the_answer
the_answer = 42
	ifdef __CPU_8080__		: defm "8080"		: endif
	ifdef __CPU_8085__		: defm "8085"		: endif
	ifdef __CPU_EZ80_ADL__	: defm "ez80"		: endif
	ifdef __CPU_EZ80_Z80__	: defm "ez80_z80"	: endif
	ifdef __CPU_GBZ80__		: defm "gbz80"		: endif
	ifdef __CPU_R2KA__		: defm "r2ka"		: endif
	ifdef __CPU_R3K__		: defm "r3k"		: endif
	ifdef __CPU_Z180__		: defm "z180"		: endif
	ifdef __CPU_Z80__		: defm "z80"		: endif
	ifdef __CPU_Z80_STRICT__: defm "z80_strict"	: endif
	ifdef __CPU_Z80N__		: defm "z80n" 		: endif
	ifdef __SWAP_IX_IY__	: defm "-IXIY"		: endif
END

spew("$test.asm", <<END);
	extern the_answer
	defb the_answer
END

for my $lib_ixiy ("", "-IXIY") {
	unlink("$test.1.lib");
	capture_ok("z88dk-z80asm $lib_ixiy -m\"*\" -x$test.1.lib $test.1.asm", "");
	ok -f "$test.1.lib", "$test.1.lib created";
	
	capture_ok("z88dk-z80nm -a $test.1.lib", <<END);
Library file $test.1.lib at \$0000: Z80LMF18
Object  file $test.1.lib at \$0010: Z80RMF18
  Name: $test.1
  CPU:  z80n 
  Section "": 4 bytes
    C \$0000: 7A 38 30 6E
  Symbols:
    L C \$0001 __CPU_Z80N__ (section "") (file $test.1.asm)
    G C \$002A the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$00CC: Z80RMF18
  Name: $test.1
  CPU:  z80n (-IXIY)
  Section "": 9 bytes
    C \$0000: 7A 38 30 6E 2D 49 58 49 59
  Symbols:
    L C \$0001 __CPU_Z80N__ (section "") (file $test.1.asm)
    L C \$0001 __SWAP_IX_IY__ (section "") (file $test.1.asm)
    G C \$002A the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$01C2: Z80RMF18
  Name: $test.1
  CPU:  z80 
  Section "": 3 bytes
    C \$0000: 7A 38 30
  Symbols:
    L C \$0001 __CPU_Z80__ (section "") (file $test.1.asm)
    G C \$002A the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$027C: Z80RMF18
  Name: $test.1
  CPU:  z80 (-IXIY)
  Section "": 8 bytes
    C \$0000: 7A 38 30 2D 49 58 49 59
  Symbols:
    L C \$0001 __CPU_Z80__ (section "") (file $test.1.asm)
    L C \$0001 __SWAP_IX_IY__ (section "") (file $test.1.asm)
    G C \$002A the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$0370: Z80RMF18
  Name: $test.1
  CPU:  ez80_z80 
  Section "": 8 bytes
    C \$0000: 65 7A 38 30 5F 7A 38 30
  Symbols:
    L C \$0001 __CPU_EZ80_Z80__ (section "") (file $test.1.asm)
    G C \$002A the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$0434: Z80RMF18
  Name: $test.1
  CPU:  ez80_z80 (-IXIY)
  Section "": 13 bytes
    C \$0000: 65 7A 38 30 5F 7A 38 30 2D 49 58 49 59
  Symbols:
    L C \$0001 __CPU_EZ80_Z80__ (section "") (file $test.1.asm)
    L C \$0001 __SWAP_IX_IY__ (section "") (file $test.1.asm)
    G C \$002A the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$0532: Z80RMF18
  Name: $test.1
  CPU:  z180 
  Section "": 4 bytes
    C \$0000: 7A 31 38 30
  Symbols:
    L C \$0001 __CPU_Z180__ (section "") (file $test.1.asm)
    G C \$002A the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$05EE: Z80RMF18
  Name: $test.1
  CPU:  z180 (-IXIY)
  Section "": 9 bytes
    C \$0000: 7A 31 38 30 2D 49 58 49 59
  Symbols:
    L C \$0001 __CPU_Z180__ (section "") (file $test.1.asm)
    L C \$0001 __SWAP_IX_IY__ (section "") (file $test.1.asm)
    G C \$002A the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$06E4: Z80RMF18
  Name: $test.1
  CPU:  z80_strict 
  Section "": 10 bytes
    C \$0000: 7A 38 30 5F 73 74 72 69 63 74
  Symbols:
    L C \$0001 __CPU_Z80_STRICT__ (section "") (file $test.1.asm)
    G C \$002A the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$07AC: Z80RMF18
  Name: $test.1
  CPU:  z80_strict (-IXIY)
  Section "": 15 bytes
    C \$0000: 7A 38 30 5F 73 74 72 69 63 74 2D 49 58 49 59
  Symbols:
    L C \$0001 __CPU_Z80_STRICT__ (section "") (file $test.1.asm)
    L C \$0001 __SWAP_IX_IY__ (section "") (file $test.1.asm)
    G C \$002A the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$08AE: Z80RMF18
  Name: $test.1
  CPU:  8085 
  Section "": 4 bytes
    C \$0000: 38 30 38 35
  Symbols:
    L C \$0001 __CPU_8085__ (section "") (file $test.1.asm)
    G C \$002A the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$096A: Z80RMF18
  Name: $test.1
  CPU:  8085 (-IXIY)
  Section "": 9 bytes
    C \$0000: 38 30 38 35 2D 49 58 49 59
  Symbols:
    L C \$0001 __CPU_8085__ (section "") (file $test.1.asm)
    L C \$0001 __SWAP_IX_IY__ (section "") (file $test.1.asm)
    G C \$002A the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$0A60: Z80RMF18
  Name: $test.1
  CPU:  r3k 
  Section "": 3 bytes
    C \$0000: 72 33 6B
  Symbols:
    L C \$0001 __CPU_R3K__ (section "") (file $test.1.asm)
    G C \$002A the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$0B1A: Z80RMF18
  Name: $test.1
  CPU:  r3k (-IXIY)
  Section "": 8 bytes
    C \$0000: 72 33 6B 2D 49 58 49 59
  Symbols:
    L C \$0001 __CPU_R3K__ (section "") (file $test.1.asm)
    L C \$0001 __SWAP_IX_IY__ (section "") (file $test.1.asm)
    G C \$002A the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$0C0E: Z80RMF18
  Name: $test.1
  CPU:  gbz80 
  Section "": 5 bytes
    C \$0000: 67 62 7A 38 30
  Symbols:
    L C \$0001 __CPU_GBZ80__ (section "") (file $test.1.asm)
    G C \$002A the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$0CCC: Z80RMF18
  Name: $test.1
  CPU:  gbz80 (-IXIY)
  Section "": 10 bytes
    C \$0000: 67 62 7A 38 30 2D 49 58 49 59
  Symbols:
    L C \$0001 __CPU_GBZ80__ (section "") (file $test.1.asm)
    L C \$0001 __SWAP_IX_IY__ (section "") (file $test.1.asm)
    G C \$002A the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$0DC4: Z80RMF18
  Name: $test.1
  CPU:  ez80 
  Section "": 4 bytes
    C \$0000: 65 7A 38 30
  Symbols:
    L C \$0001 __CPU_EZ80_ADL__ (section "") (file $test.1.asm)
    G C \$002A the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$0E84: Z80RMF18
  Name: $test.1
  CPU:  ez80 (-IXIY)
  Section "": 9 bytes
    C \$0000: 65 7A 38 30 2D 49 58 49 59
  Symbols:
    L C \$0001 __CPU_EZ80_ADL__ (section "") (file $test.1.asm)
    L C \$0001 __SWAP_IX_IY__ (section "") (file $test.1.asm)
    G C \$002A the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$0F7E: Z80RMF18
  Name: $test.1
  CPU:  r2ka 
  Section "": 4 bytes
    C \$0000: 72 32 6B 61
  Symbols:
    L C \$0001 __CPU_R2KA__ (section "") (file $test.1.asm)
    G C \$002A the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$103A: Z80RMF18
  Name: $test.1
  CPU:  r2ka (-IXIY)
  Section "": 9 bytes
    C \$0000: 72 32 6B 61 2D 49 58 49 59
  Symbols:
    L C \$0001 __CPU_R2KA__ (section "") (file $test.1.asm)
    L C \$0001 __SWAP_IX_IY__ (section "") (file $test.1.asm)
    G C \$002A the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$1130: Z80RMF18
  Name: $test.1
  CPU:  8080 
  Section "": 4 bytes
    C \$0000: 38 30 38 30
  Symbols:
    L C \$0001 __CPU_8080__ (section "") (file $test.1.asm)
    G C \$002A the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$11EC: Z80RMF18
  Name: $test.1
  CPU:  8080 (-IXIY)
  Section "": 9 bytes
    C \$0000: 38 30 38 30 2D 49 58 49 59
  Symbols:
    L C \$0001 __CPU_8080__ (section "") (file $test.1.asm)
    L C \$0001 __SWAP_IX_IY__ (section "") (file $test.1.asm)
    G C \$002A the_answer (section "") (file $test.1.asm:2)

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


# make -XIIY-soft library

unlink("$test.1.lib");
capture_ok("z88dk-z80asm -IXIY-soft -m\"*\" -x$test.1.lib $test.1.asm", "");
ok -f "$test.1.lib", "$test.1.lib created";

capture_ok("z88dk-z80nm -a $test.1.lib", <<END);
Library file $test.1.lib at \$0000: Z80LMF18
Object  file $test.1.lib at \$0010: Z80RMF18
  Name: $test.1
  CPU:  z80n (-IXIY-soft)
  Section "": 9 bytes
    C \$0000: 7A 38 30 6E 2D 49 58 49 59
  Symbols:
    L C \$0001 __CPU_Z80N__ (section "") (file $test.1.asm)
    L C \$0001 __SWAP_IX_IY__ (section "") (file $test.1.asm)
    G C \$002A the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$0106: Z80RMF18
  Name: $test.1
  CPU:  z80 (-IXIY-soft)
  Section "": 8 bytes
    C \$0000: 7A 38 30 2D 49 58 49 59
  Symbols:
    L C \$0001 __CPU_Z80__ (section "") (file $test.1.asm)
    L C \$0001 __SWAP_IX_IY__ (section "") (file $test.1.asm)
    G C \$002A the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$01FA: Z80RMF18
  Name: $test.1
  CPU:  ez80_z80 (-IXIY-soft)
  Section "": 13 bytes
    C \$0000: 65 7A 38 30 5F 7A 38 30 2D 49 58 49 59
  Symbols:
    L C \$0001 __CPU_EZ80_Z80__ (section "") (file $test.1.asm)
    L C \$0001 __SWAP_IX_IY__ (section "") (file $test.1.asm)
    G C \$002A the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$02F8: Z80RMF18
  Name: $test.1
  CPU:  z180 (-IXIY-soft)
  Section "": 9 bytes
    C \$0000: 7A 31 38 30 2D 49 58 49 59
  Symbols:
    L C \$0001 __CPU_Z180__ (section "") (file $test.1.asm)
    L C \$0001 __SWAP_IX_IY__ (section "") (file $test.1.asm)
    G C \$002A the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$03EE: Z80RMF18
  Name: $test.1
  CPU:  z80_strict (-IXIY-soft)
  Section "": 15 bytes
    C \$0000: 7A 38 30 5F 73 74 72 69 63 74 2D 49 58 49 59
  Symbols:
    L C \$0001 __CPU_Z80_STRICT__ (section "") (file $test.1.asm)
    L C \$0001 __SWAP_IX_IY__ (section "") (file $test.1.asm)
    G C \$002A the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$04F0: Z80RMF18
  Name: $test.1
  CPU:  8085 (-IXIY-soft)
  Section "": 9 bytes
    C \$0000: 38 30 38 35 2D 49 58 49 59
  Symbols:
    L C \$0001 __CPU_8085__ (section "") (file $test.1.asm)
    L C \$0001 __SWAP_IX_IY__ (section "") (file $test.1.asm)
    G C \$002A the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$05E6: Z80RMF18
  Name: $test.1
  CPU:  r3k (-IXIY-soft)
  Section "": 8 bytes
    C \$0000: 72 33 6B 2D 49 58 49 59
  Symbols:
    L C \$0001 __CPU_R3K__ (section "") (file $test.1.asm)
    L C \$0001 __SWAP_IX_IY__ (section "") (file $test.1.asm)
    G C \$002A the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$06DA: Z80RMF18
  Name: $test.1
  CPU:  gbz80 (-IXIY-soft)
  Section "": 10 bytes
    C \$0000: 67 62 7A 38 30 2D 49 58 49 59
  Symbols:
    L C \$0001 __CPU_GBZ80__ (section "") (file $test.1.asm)
    L C \$0001 __SWAP_IX_IY__ (section "") (file $test.1.asm)
    G C \$002A the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$07D2: Z80RMF18
  Name: $test.1
  CPU:  ez80 (-IXIY-soft)
  Section "": 9 bytes
    C \$0000: 65 7A 38 30 2D 49 58 49 59
  Symbols:
    L C \$0001 __CPU_EZ80_ADL__ (section "") (file $test.1.asm)
    L C \$0001 __SWAP_IX_IY__ (section "") (file $test.1.asm)
    G C \$002A the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$08CC: Z80RMF18
  Name: $test.1
  CPU:  r2ka (-IXIY-soft)
  Section "": 9 bytes
    C \$0000: 72 32 6B 61 2D 49 58 49 59
  Symbols:
    L C \$0001 __CPU_R2KA__ (section "") (file $test.1.asm)
    L C \$0001 __SWAP_IX_IY__ (section "") (file $test.1.asm)
    G C \$002A the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$09C2: Z80RMF18
  Name: $test.1
  CPU:  8080 (-IXIY-soft)
  Section "": 9 bytes
    C \$0000: 38 30 38 30 2D 49 58 49 59
  Symbols:
    L C \$0001 __CPU_8080__ (section "") (file $test.1.asm)
    L C \$0001 __SWAP_IX_IY__ (section "") (file $test.1.asm)
    G C \$002A the_answer (section "") (file $test.1.asm:2)

END


for my $code_ixiy ("", "-IXIY", "-IXIY-soft") {
	for my $code_cpu (@CPUS) {
		if ($code_ixiy ne "-IXIY") {
			unlink("$test.bin");
			capture_ok("z88dk-z80asm -b -m$code_cpu $code_ixiy ".
							   "-l$test.1.lib $test.asm", "");
			ok -f "$test.bin", "$test.bin created";
			check_bin_file("$test.bin", bytes(42).$code_cpu."-IXIY");
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


# check actual swapping
for my $code_ixiy ("", "-IXIY", "-IXIY-soft") {
	spew("$test.asm", <<END);
			ld ix, 0
END
	unlink("$test.bin");
	capture_ok("z88dk-z80asm -b $code_ixiy $test.asm", "");
	ok -f "$test.bin", "$test.bin created";
	my %PREFIX = (""=>0xDD, "-IXIY"=>0xFD, "-IXIY-soft"=>0xFD);
	check_bin_file("$test.bin", bytes($PREFIX{$code_ixiy}, 0x21, 0, 0));
}


unlink_testfiles;
done_testing;


sub cpu_compatible {
	my($code_cpu, $lib_cpu) = @_;
	if ($code_cpu eq $lib_cpu) {
		return 1;
	}
	elsif ($code_cpu eq "z80_strict" && $lib_cpu eq "8080") {
		return 1;
	}
	elsif ($code_cpu eq "z80" && ($lib_cpu eq "8080" || $lib_cpu eq "z80_strict")) {
		return 1;
	}
	elsif ($code_cpu eq "z80n" && ($lib_cpu eq "8080" || $lib_cpu eq "z80" || $lib_cpu eq "z80_strict")) {
		return 1;
	}
	elsif ($code_cpu eq "z180" && ($lib_cpu eq "8080" || $lib_cpu eq "z80_strict")) {
		return 1;
	}
	elsif ($code_cpu eq "ez80") {
		return 0;
	}
	elsif ($code_cpu eq "ez80_z80" && ($lib_cpu eq "8080" || $lib_cpu eq "z180" || $lib_cpu eq "z80_strict")) {
		return 1;
	}
	elsif ($code_cpu eq "r2ka") {
		return 0;
	}
	elsif ($code_cpu eq "r3k" && $lib_cpu eq "r2ka") {
		return 1;
	}
	elsif ($code_cpu eq "8080") {
		return 0;
	}
	elsif ($code_cpu eq "8085" && $lib_cpu eq "8080") {
		return 1;
	}
	elsif ($code_cpu eq "gbz80") {
		return 0;
	}
	else {
		return 0;
	}
}

sub ixiy_compatible {
	my($code_ixiy, $lib_ixiy) = @_;
	if ($code_ixiy eq $lib_ixiy) {
		return 1;
	}
	elsif ($code_ixiy eq "" && $lib_ixiy eq "-IXIY-soft") {
		return 1;
	}
	elsif ($code_ixiy eq "-IXIY-soft" && $lib_ixiy eq "") {
		return 1;
	}
	else {
		return 0;
	}
}
