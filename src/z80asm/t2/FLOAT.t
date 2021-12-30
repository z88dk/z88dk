#!/usr/bin/env perl

BEGIN { use lib 't2'; require 'testlib.pl'; }

#-------------------------------------------------------------------------------
# errors
#-------------------------------------------------------------------------------
my $available = "Available float formats: genmath math48";

capture_nok("./z88dk-z80asm -float", <<END);
Error: invalid float format
$available
END

capture_nok("./z88dk-z80asm -float=xx", <<END);
Error: invalid float format
$available
END

z80asm_nok("", "", <<END_ASM, <<END_ERR);
		float 
END_ASM
Error at file '$test.asm' line 1: syntax error
END_ERR

z80asm_nok("", "", <<END_ASM, <<END_ERR);
		float xx
END_ASM
Error at file '$test.asm' line 1: invalid float format
$available
END_ERR

#-------------------------------------------------------------------------------
# generate floats in C and ASM and compare
#-------------------------------------------------------------------------------
my @fdata = (1., -1., 255., -255., 256., -256.,
			 65535., -65535., 65536., -65536.,
			 5.5, -5.5, 5.5e1, 5.e-1);

check_floats("-lm", 		"", @fdata);
check_floats("-lm", 		"-float=genmath", @fdata);
check_floats("-lmath48", 	"-float=math48", @fdata);
#check_floats("--math-bbc", 	"-float=z88", @fdata);

unlink_testfiles;
done_testing;

#-------------------------------------------------------------------------------
# Build C with float array, return float bytes
#-------------------------------------------------------------------------------
sub check_floats {
	my($c_opts, $asm_opts, @fdata) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;

	$fdata = join(",", @fdata);

	# build C code
	path("$test.c")->spew(<<END);
		float fdata[] = { $fdata };
		float fend = 0.0;
		int main() {}
END

	# compile
	run_ok("zcc +test -o$test.bin $c_opts --list -m -create-app $test.c");
	
	# extract _fdata and _fend addresses from map file
	my($fstart, $fend);
	for (path("$test.map")->lines) {
		/^_fdata\s+=\s+\$([0-9a-f]+)/i and $fstart = hex($1);
		/^_fend\s+=\s+\$([0-9a-f]+)/i and $fend = hex($1);
	}
	defined $fstart or die;
	defined $fend or die;
	my $fsize = ($fend-$fstart);

	# extract binary data
	my $bin_data = path("$test.bin")->slurp_raw;
	my $c_bytes = unpack("H*", substr($bin_data, $fstart, $fsize)); 

	# build asm code
	path("$test.asm")->spew(<<END);
		float $fdata
END

	# assemble
	run_ok("./z88dk-z80asm -b -l $asm_opts $test.asm");
	
	# extract binary data
	my $bin_data = path("$test.bin")->slurp_raw;
	my $asm_bytes = unpack("H*", $bin_data); 
	
	# compare
	is $asm_bytes, $c_bytes, "float data equal";
}
