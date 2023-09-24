#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# Test https://github.com/z88dk/z88dk/issues/2320
# z80asm: do not link with object files built for a different cpu


# link object files

unlink_testfiles;
for my $lib_ixiy ("", "-IXIY", "-IXIY-soft") {
	my $lib_ixiy_cpu = $lib_ixiy ? "($lib_ixiy)" : "";
	my %IXIY_ERROR = (""=>"(no option)", "-IXIY"=>"-IXIY", "-IXIY-soft"=>"-IXIY-soft");
		
	for my $lib_cpu (@CPUS) {
		spew("$test.1.asm", <<'END');
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
  Section "": 0 bytes
  Symbols:
    G C \$002A: the_answer (section "") (file $test.1.asm:2)
END

		capture_ok("z88dk-z80nm -a $test.1.lib", <<END);
Library file $test.1.lib at \$0000: Z80LMF18
Object  file $test.1.lib at \$0014: Z80RMF18
  Name: $test.1
  CPU:  $lib_cpu $lib_ixiy_cpu
  Section "": 0 bytes
  Symbols:
    G C \$002A: the_answer (section "") (file $test.1.asm:2)

END

		# link with object and library
		spew("$test.asm", <<'END');
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


unlink_testfiles;
done_testing;
