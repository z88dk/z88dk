#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/2320
# z80asm: do not link with object files built for a different cpu

my @CPUS = qw( z80 z80n z180 ez80 ez80_z80 r2ka r3k 8080 8085 gbz80 );

# link object files

for my $ixiy ("", "-IXIY") {
	my $not_ixiy = $ixiy ? "" : "-IXIY";
	my $ixiy_error = $ixiy ? 
		"compiled for IX=IY, incompatible with IX=IX" :
		"compiled for IX=IX, incompatible with IX=IY";
	my $ixiy_cpu = $ixiy ? "(-IXIY)" : "";
	
	for my $lib_cpu (@CPUS) {
		
		spew("$test.1.asm", <<END);
				public the_answer
		the_answer = 42
END

		unlink("$test.1.o");
		capture_ok("z88dk-z80asm -m$lib_cpu $ixiy $test.1.asm", "");
		ok -f "$test.1.o", "$test.1.o created";
		ok unlink("$test.1.asm"), "remove $test.1.asm";
		
		capture_ok("z88dk-z80nm -a $test.1.o", <<END);
Object  file $test.1.o at \$0000: Z80RMF18
  Name: $test.1
  CPU:  $lib_cpu $ixiy_cpu
  Symbols:
    G C \$002A the_answer (section "") (file $test.1.asm:2)
END

		spew("$test.asm", <<END);
				extern the_answer
				defb the_answer
END

		for my $code_cpu (@CPUS) {
			unlink("$test.bin");
			if (cpu_compatible($code_cpu, $lib_cpu)) {
				capture_ok("z88dk-z80asm -b -m$code_cpu $ixiy ".
						   "$test.asm $test.1.asm", "");
				check_bin_file("$test.bin", bytes(42));
				
				capture_nok("z88dk-z80asm -b -m$code_cpu $not_ixiy ".
						    "$test.asm $test.1.asm", <<END);
error: -IXIY incompatible: file $test.1.o $ixiy_error
END
			}
			else {
				capture_nok("z88dk-z80asm -b -m$code_cpu $ixiy ".
						    "$test.asm $test.1.asm", <<END);
error: CPU incompatible: file $test.1.o compiled for $lib_cpu, incompatible with $code_cpu
END
			}
		}
	}
}

# link libraries

for my $ixiy ("", "-IXIY") {
	my $not_ixiy = $ixiy ? "" : "-IXIY";
	my $ixiy_error = $ixiy ? 
		"compiled for IX=IY, incompatible with IX=IX" :
		"compiled for IX=IX, incompatible with IX=IY";
	my $ixiy_cpu = $ixiy ? "(-IXIY)" : "";

	for my $lib_cpu (@CPUS) {
		
		spew("$test.1.asm", <<END);
				public the_answer
		the_answer = 42
END

		unlink("$test.1.o", "$test.1.lib");
		capture_ok("z88dk-z80asm -m$lib_cpu -x$test.1.lib $ixiy $test.1.asm", "");
		ok -f "$test.1.lib", "$test.1.lib created";
		ok unlink("$test.1.asm", "$test.1.o"), "remove $test.1.asm $test.1.o";

		capture_ok("z88dk-z80nm -a $test.1.lib", <<END);
Library file $test.1.lib at \$0000: Z80LMF18
Object  file $test.1.lib at \$0010: Z80RMF18
  Name: $test.1
  CPU:  $lib_cpu $ixiy_cpu
  Symbols:
    G C \$002A the_answer (section "") (file $test.1.asm:2)

END

		spew("$test.asm", <<END);
				extern the_answer
				defb the_answer
END

		for my $code_cpu (@CPUS) {
			unlink("$test.bin");
			if (cpu_compatible($code_cpu, $lib_cpu)) {
				capture_ok("z88dk-z80asm -b -m$code_cpu $ixiy -l$test.1.lib ".
						   "$test.asm", "");
				check_bin_file("$test.bin", bytes(42));
				
				capture_nok("z88dk-z80asm -b -m$code_cpu $not_ixiy -l$test.1.lib ".
							"$test.asm", <<END);
$test.asm:2: error: undefined symbol: the_answer
  ^---- the_answer
END
			}
			else {
				capture_nok("z88dk-z80asm -b -m$code_cpu $ixiy -l$test.1.lib ".
						    "$test.asm", <<END);
$test.asm:2: error: undefined symbol: the_answer
  ^---- the_answer
END
			}
		}
	}
}


# make multi-cpu library

spew("$test.1.asm", <<END);
			public the_answer
	the_answer = 42
END

unlink("$test.1.lib");
capture_ok("z88dk-z80asm -m\"*\" -x$test.1.lib $test.1.asm", "");
ok -f "$test.1.lib", "$test.1.lib created";
capture_ok("z88dk-z80nm -a $test.1.lib", <<END);
Library file $test.1.lib at \$0000: Z80LMF18
Object  file $test.1.lib at \$0010: Z80RMF18
  Name: $test.1
  CPU:  z80 
  Symbols:
    G C \$002A the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$0083: Z80RMF18
  Name: $test.1
  CPU:  z80 (-IXIY)
  Symbols:
    G C \$002A the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$00F6: Z80RMF18
  Name: $test.1
  CPU:  z80n 
  Symbols:
    G C \$002A the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$0169: Z80RMF18
  Name: $test.1
  CPU:  z80n (-IXIY)
  Symbols:
    G C \$002A the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$01DC: Z80RMF18
  Name: $test.1
  CPU:  z180 
  Symbols:
    G C \$002A the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$024F: Z80RMF18
  Name: $test.1
  CPU:  z180 (-IXIY)
  Symbols:
    G C \$002A the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$02C2: Z80RMF18
  Name: $test.1
  CPU:  ez80 
  Symbols:
    G C \$002A the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$0335: Z80RMF18
  Name: $test.1
  CPU:  ez80 (-IXIY)
  Symbols:
    G C \$002A the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$03A8: Z80RMF18
  Name: $test.1
  CPU:  ez80_z80 
  Symbols:
    G C \$002A the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$041B: Z80RMF18
  Name: $test.1
  CPU:  ez80_z80 (-IXIY)
  Symbols:
    G C \$002A the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$048E: Z80RMF18
  Name: $test.1
  CPU:  r2ka 
  Symbols:
    G C \$002A the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$0501: Z80RMF18
  Name: $test.1
  CPU:  r2ka (-IXIY)
  Symbols:
    G C \$002A the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$0574: Z80RMF18
  Name: $test.1
  CPU:  r3k 
  Symbols:
    G C \$002A the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$05E7: Z80RMF18
  Name: $test.1
  CPU:  r3k (-IXIY)
  Symbols:
    G C \$002A the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$065A: Z80RMF18
  Name: $test.1
  CPU:  8080 
  Symbols:
    G C \$002A the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$06CD: Z80RMF18
  Name: $test.1
  CPU:  8080 (-IXIY)
  Symbols:
    G C \$002A the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$0740: Z80RMF18
  Name: $test.1
  CPU:  8085 
  Symbols:
    G C \$002A the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$07B3: Z80RMF18
  Name: $test.1
  CPU:  8085 (-IXIY)
  Symbols:
    G C \$002A the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$0826: Z80RMF18
  Name: $test.1
  CPU:  gbz80 
  Symbols:
    G C \$002A the_answer (section "") (file $test.1.asm:2)

Object  file $test.1.lib at \$0899: Z80RMF18
  Name: $test.1
  CPU:  gbz80 (-IXIY)
  Symbols:
    G C \$002A the_answer (section "") (file $test.1.asm:2)

END

for my $ixiy ("", "-IXIY") {
	for my $code_cpu (@CPUS) {
		unlink("$test.bin");
		capture_ok("z88dk-z80asm -b -m$code_cpu $ixiy ".
						   "-l$test.1.lib $test.asm", "");
		ok -f "$test.bin", "$test.bin created";
		check_bin_file("$test.bin", bytes(42));
	}
}


unlink_testfiles;
done_testing;


sub cpu_compatible {
	my($code_cpu, $lib_cpu) = @_;
	if ($code_cpu eq $lib_cpu) {
		return 1;
	}
	elsif ($code_cpu eq "z80" && $lib_cpu eq "8080") {
		return 1;
	}
	elsif ($code_cpu eq "z80n" && ($lib_cpu eq "8080" || $lib_cpu eq "z80")) {
		return 1;
	}
	elsif ($code_cpu eq "z180" && $lib_cpu eq "8080") {
		return 1;
	}
	elsif ($code_cpu eq "ez80") {
		return 0;
	}
	elsif ($code_cpu eq "ez80_z80" && ($lib_cpu eq "8080" || $lib_cpu eq "z180")) {
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
