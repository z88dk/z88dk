#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;
use File::Copy;

# Test loading of z88dk-z80asm-*.lib

# check our RLD code is compiling

my @RLD_AT_0004 = map {hex} qw( 
	30 05 CD 0B 00 37 C9 07 07 07 07 CB 27
	CB 16 CE 00 17 CB 16 CE 00 17 CB 16 CE 00 17 CB
    16 CE 00 B7 C9 );

my @INTEL_RLD_AT_0004 = map {hex} qw( 
	D2 0C 00 CD 0C 00 37 C9 D5 E5 6E 26 00 57 E6 F0 
	5F 7A E6 0F 57 29 29 29 29 85 6F 7C 83 5D E1 73 
	D1 B7 C9  );

z80asm_ok("", "", "", <<END, bytes(0xCD, 0x04, 0x00, 0xC9, @RLD_AT_0004));
	extern	__z80asm__rld
	call 	__z80asm__rld
	ret
END

z80asm_ok("-b -mr2ka", "", "", <<END, bytes(0xCD, 0x04, 0x00, 0xC9, @RLD_AT_0004));
	rld
	ret
END

# setup sandbox
path("${test}dir")->remove_tree;
path("${test}dir/root/lib/config")->mkpath;

path("${test}.asm")->spew(<<END);
	extern	__z80asm__rld
	call 	__z80asm__rld
	ret
END

# run with lib in current directory
unlink("${test}.bin");

capture_ok("z88dk-z80asm -b -v ${test}.asm", <<END);
Reading library 'z88dk-z80asm-z80-.lib'
Predefined constant: __CPU_Z80__ = \$0001
Predefined constant: __CPU_ZILOG__ = \$0001
Predefined constant: __FLOAT_GENMATH__ = \$0001
Assembling '${test}.asm' to '${test}.o'
Reading '${test}.asm' = '${test}.asm'
Writing object file '${test}.o'
Module '${test}' size: 4 bytes

Linking library module 'rld'
Code size: 38 bytes (\$0000 to \$0025)
Section 'code_l_sccz80' size: 34 bytes (\$0004 to \$0025)
Creating binary '${test}.bin'
END

check_bin_file("${test}.bin", bytes(0xCD, 0x04, 0x00, 0xC9, @RLD_AT_0004));

# run with lib pointed by ZCCCFG
chdir("${test}dir") or die;
{
	local $ENV{PATH} = join($Config{path_sep}, 
				"..",
				"../../../bin",
				$ENV{PATH});

$ENV{ZCCCFG} = "root/lib/config";
copy('../z88dk-z80asm-z80-.lib', $ENV{ZCCCFG}.'/../z88dk-z80asm-z80-.lib');

capture_ok("z88dk-z80asm -b -v ../${test}.asm", <<END);
Library 'z88dk-z80asm-z80-.lib' not found
Library '/usr/local/share/z88dk/lib/z88dk-z80asm-z80-.lib' not found
Reading library 'root/lib/z88dk-z80asm-z80-.lib'
Predefined constant: __CPU_Z80__ = \$0001
Predefined constant: __CPU_ZILOG__ = \$0001
Predefined constant: __FLOAT_GENMATH__ = \$0001
Assembling '../${test}.asm' to '../${test}.o'
Reading '../${test}.asm' = '../${test}.asm'
Writing object file '../${test}.o'
Module '${test}' size: 4 bytes

Linking library module 'rld'
Code size: 38 bytes (\$0000 to \$0025)
Section 'code_l_sccz80' size: 34 bytes (\$0004 to \$0025)
Creating binary '../${test}.bin'
END

check_bin_file("../${test}.bin", bytes(0xCD, 0x04, 0x00, 0xC9, @RLD_AT_0004));

delete $ENV{ZCCCFG};

# point library with -L
unlink("../${test}.bin");

capture_ok("z88dk-z80asm -b -v -Lroot/lib ../${test}.asm", <<END);
Library 'z88dk-z80asm-z80-.lib' not found
Library '/usr/local/share/z88dk/lib/z88dk-z80asm-z80-.lib' not found
Reading library 'root/lib/z88dk-z80asm-z80-.lib'
Predefined constant: __CPU_Z80__ = \$0001
Predefined constant: __CPU_ZILOG__ = \$0001
Predefined constant: __FLOAT_GENMATH__ = \$0001
Assembling '../${test}.asm' to '../${test}.o'
Reading '../${test}.asm' = '../${test}.asm'
Writing object file '../${test}.o'
Module '${test}' size: 4 bytes

Linking library module 'rld'
Code size: 38 bytes (\$0000 to \$0025)
Section 'code_l_sccz80' size: 34 bytes (\$0004 to \$0025)
Creating binary '../${test}.bin'
END

check_bin_file("../${test}.bin", bytes(0xCD, 0x04, 0x00, 0xC9, @RLD_AT_0004));

# run without library
unlink("../${test}.bin");

run_nok("z88dk-z80asm -b -v ../${test}.asm > ../${test}.out 2> ../${test}.err");

check_text_file("../${test}.out", <<END);
Library 'z88dk-z80asm-z80-.lib' not found
Library '/usr/local/share/z88dk/lib/z88dk-z80asm-z80-.lib' not found
Library '/../z88dk-z80asm-z80-.lib' not found
Predefined constant: __CPU_Z80__ = \$0001
Predefined constant: __CPU_ZILOG__ = \$0001
Predefined constant: __FLOAT_GENMATH__ = \$0001
Assembling '../${test}.asm' to '../${test}.o'
Reading '../${test}.asm' = '../${test}.asm'
Writing object file '../${test}.o'
Module '${test}' size: 4 bytes

Code size: 4 bytes (\$0000 to \$0003)
END

check_text_file("../${test}.err", <<END);
../${test}.asm:2: error: undefined symbol: __z80asm__rld
  ^---- __z80asm__rld
END

}
chdir("..") or die;


# test loading of each different library for different CPUs
for my $cpu ("", qw(z80 z80n z180 gbz80 8080 8085 r2ka r3k)) {
	for my $ixiy (0, 1) {
		my $real_cpu = $cpu ? $cpu : "z80";
	
		my $cmd = "z88dk-z80asm ";
		$cmd .= "-m$cpu " if $cpu;
		$cmd .= "-b -v ";
		$cmd .= "-IXIY " if $ixiy;
		$cmd .= "${test}.asm";
		
		my $lib = "z88dk-z80asm-$real_cpu-";
		$lib .= "ixiy" if $ixiy;
		$lib .= ".lib";
		
		my @bytes = (0xCD, 0x04, 0x00, 0xC9);
		if ($cpu =~ /^80/) {
			push @bytes, @INTEL_RLD_AT_0004;
		}
		else {
			push @bytes, @RLD_AT_0004;
		}
		
		unlink("${test}.bin");
		capture_ok($cmd, exp_output($real_cpu, $ixiy, $lib));
		check_bin_file("${test}.bin", bytes(@bytes));
		
		die unless Test::More->builder->is_passing;
		
	}
}


path("${test}dir")->remove_tree;
unlink_testfiles;
done_testing;


sub exp_output {
	my($cpu, $ixiy, $library) = @_;
	
	my $CPU = uc($cpu);
	my $family = ($cpu =~ /^z/i)  ? "ZILOG" :
				 ($cpu =~ /^r/i)  ? "RABBIT" :
				 ($cpu =~ /^80/i) ? "INTEL" : "";

	my $out = 	"Reading library '$library'\n";
	$out .=		"Predefined constant: __CPU_${CPU}__ = \$0001\n";
	$out .= 	"Predefined constant: __CPU_${family}__ = \$0001\n" if $family;
	$out .= 	"Predefined constant: __SWAP_IX_IY__ = \$0001\n" if $ixiy;
	$out .= <<END;
Predefined constant: __FLOAT_GENMATH__ = \$0001
Assembling '${test}.asm' to '${test}.o'
Reading '${test}.asm' = '${test}.asm'
Writing object file '${test}.o'
Module '${test}' size: 4 bytes

Linking library module 'rld'
END

	if ($cpu =~ /^80/) {
		$out .= <<END;
Code size: 39 bytes (\$0000 to \$0026)
Section 'code_l_sccz80' size: 35 bytes (\$0004 to \$0026)
END
	}
	else {
		$out .= <<END;
Code size: 38 bytes (\$0000 to \$0025)
Section 'code_l_sccz80' size: 34 bytes (\$0004 to \$0025)
END
	}
	
	$out .= <<END;
Creating binary '${test}.bin'
END
	return $out;

}
