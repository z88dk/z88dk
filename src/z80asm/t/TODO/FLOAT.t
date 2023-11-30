#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;
use Math::Trig;

#-------------------------------------------------------------------------------
# errors
#-------------------------------------------------------------------------------
my $invalid_format_error = "invalid float format, expected: ".
	"genmath,math48,ieee16,ieee32,ieee64,z80,zx81,zx,z88,mbfs,mbf40,mbf64,am9511";

spew("${test}.asm", "");
capture_nok("z88dk-z80asm -float=x ${test}.asm", <<END);
error: $invalid_format_error
END

z80asm_nok("", "", <<END_ASM, <<END_ERR);
		float 
END_ASM
$test.asm:1: error: syntax error
  ^---- float
END_ERR

z80asm_nok("", "", <<END_ASM, <<END_ERR);
		setfloat 
END_ASM
$test.asm:1: error: syntax error
  ^---- setfloat
END_ERR

z80asm_nok("", "", <<END_ASM, <<END_ERR);
		setfloat xx
END_ASM
$test.asm:1: error: $invalid_format_error
  ^---- setfloat xx
END_ERR

#-------------------------------------------------------------------------------
# check that setfloat does not spill over to next file
#-------------------------------------------------------------------------------
spew("$test.1.asm", <<END);
		setfloat ieee16
		float 5.5
END
spew("$test.2.asm", <<END);
		float 5.5
END
run_ok("z88dk-z80asm -b $test.1.asm $test.2.asm");
check_bin_file("$test.1.bin", bytes(128,69, 0,0,0,0,48,131));

#-------------------------------------------------------------------------------
# check macro expansion in float line
#-------------------------------------------------------------------------------
z80asm_ok("", "", "", <<'END', bytes(128,69));
		defl ftype = ieee16
		setfloat ftype

		defl fconst = 5.5
		float fconst
END

#-------------------------------------------------------------------------------
# test against hand-crafted data
#-------------------------------------------------------------------------------
my @fdata = (1., -1., 255., -255., 256., -256.,
			 65535., -65535., 65536., -65536.,
			 5.5, -5.5, 5.5e1, 5.e-1);

for my $ftype ("", "genmath", "math48", "z80") {
	check_asm($ftype, \@fdata,
		[0,0,0,0,0,129,
		 0,0,0,0,128,129,
		 0,0,0,0,127,136,
		 0,0,0,0,255,136,
		 0,0,0,0,0,137,
		 0,0,0,0,128,137,
		 0,0,0,255,127,144,
		 0,0,0,255,255,144,
		 0,0,0,0,0,145,
		 0,0,0,0,128,145,
		 0,0,0,0,48,131,
		 0,0,0,0,176,131,
		 0,0,0,0,92,134,
		 0,0,0,0,0,128]
	);
}

check_asm("ieee16", \@fdata,
	[0,60,
	 0,188,
	 248,91,
	 248,219,
	 0,92,
	 0,220,
	 255,123,
	 255,251,
	 0,124,
	 0,252,
	 128,69,
	 128,197,
	 224,82,
	 0,56]
);

check_asm("ieee32", \@fdata,
	[0,0,128,63,
	 0,0,128,191,
	 0,0,127,67,
	 0,0,127,195,
	 0,0,128,67,
	 0,0,128,195,
	 0,255,127,71,
	 0,255,127,199,
	 0,0,128,71,
	 0,0,128,199,
	 0,0,176,64,
	 0,0,176,192,
	 0,0,92,66,
	 0,0,0,63]
);

check_asm("ieee64", \@fdata,
	[0,0,0,0,0,0,240,63,
	 0,0,0,0,0,0,240,191,
	 0,0,0,0,0,224,111,64,
	 0,0,0,0,0,224,111,192,
	 0,0,0,0,0,0,112,64,
	 0,0,0,0,0,0,112,192,
	 0,0,0,0,224,255,239,64,
	 0,0,0,0,224,255,239,192,
	 0,0,0,0,0,0,240,64,
	 0,0,0,0,0,0,240,192,
	 0,0,0,0,0,0,22,64,
	 0,0,0,0,0,0,22,192,
	 0,0,0,0,0,128,75,64,
	 0,0,0,0,0,0,224,63]
);

check_asm("zx81", \@fdata,
	[129,0,0,0,0,
	 129,128,0,0,0,
	 136,127,0,0,0,
	 136,255,0,0,0,
	 137,0,0,0,0,
	 137,128,0,0,0,
	 144,127,255,0,0,
	 144,255,255,0,0,
	 145,0,0,0,0,
	 145,128,0,0,0,
	 131,48,0,0,0,
	 131,176,0,0,0,
	 134,92,0,0,0,
	 128,0,0,0,0]
);

check_asm("zx", \@fdata,
	[0,0,1,0,0,
	 0,255,255,255,0,
	 0,0,255,0,0,
	 0,255,1,255,0,
	 0,0,0,1,0,
	 0,255,0,255,0,
	 0,0,255,255,0,
	 0,255,1,0,0,
	 145,0,0,0,0,
	 145,128,0,0,0,
	 131,48,0,0,0,
	 131,176,0,0,0,
	 0,0,55,0,0,
	 128,0,0,0,0]	 
);

check_asm("z88", \@fdata,
	[0,0,0,0,0,128,
	 0,0,0,0,128,128,
	 0,0,0,0,127,135,
	 0,0,0,0,255,135,
	 0,0,0,0,0,136,
	 0,0,0,0,128,136,
	 0,0,0,255,127,143,
	 0,0,0,255,255,143,
	 0,0,0,0,0,144,
	 0,0,0,0,128,144,
	 0,0,0,0,48,130,
	 0,0,0,0,176,130,
	 0,0,0,0,92,133,
	 0,0,0,0,0,127]
);

check_asm("mbfs", \@fdata,
	[0,0,0,129,
	 0,0,128,129,
	 0,0,127,136,
	 0,0,255,136,
	 0,0,0,137,
	 0,0,128,137,
	 0,255,127,144,
	 0,255,255,144,
	 0,0,0,145,
	 0,0,128,145,
	 0,0,48,131,
	 0,0,176,131,
	 0,0,92,134,
	 0,0,0,128]	 
);

check_asm("mbf40", \@fdata,
	[0,0,0,0,129,0,
	 0,0,0,128,129,0,
	 0,0,0,127,136,0,
	 0,0,0,255,136,0,
	 0,0,0,0,137,0,
	 0,0,0,128,137,0,
	 0,0,255,127,144,0,
	 0,0,255,255,144,0,
	 0,0,0,0,145,0,
	 0,0,0,128,145,0,
	 0,0,0,48,131,0,
	 0,0,0,176,131,0,
	 0,0,0,92,134,0,
	 0,0,0,0,128,0]	 
);

check_asm("mbf64", \@fdata,
	[0,0,0,0,0,0,0,129,
	 0,0,0,0,0,0,128,129,
	 0,0,0,0,0,0,127,136,
	 0,0,0,0,0,0,255,136,
	 0,0,0,0,0,0,0,137,
	 0,0,0,0,0,0,128,137,
	 0,0,0,0,0,255,127,144,
	 0,0,0,0,0,255,255,144,
	 0,0,0,0,0,0,0,145,
	 0,0,0,0,0,0,128,145,
	 0,0,0,0,0,0,48,131,
	 0,0,0,0,0,0,176,131,
	 0,0,0,0,0,0,92,134,
	 0,0,0,0,0,0,0,128]	 
);

check_asm("am9511", \@fdata,
	[0,0,128,1,
	 0,0,128,129,
	 0,0,255,8,
	 0,0,255,136,
	 0,0,128,9,
	 0,0,128,137,
	 0,255,255,16,
	 0,255,255,144,
	 0,0,128,17,
	 0,0,128,145,
	 0,0,176,3,
	 0,0,176,131,
	 0,0,220,6,
	 0,0,128,0]	 
);

#-------------------------------------------------------------------------------
# compare C and ASM representations
#-------------------------------------------------------------------------------
check_c("-lm", 				"",					"float",	\@fdata);
check_c("-lm", 				"-float=genmath",	"float",	\@fdata);
check_c("-lmath48", 		"",					"float",	\@fdata);
check_c("-fp-mode=z80", 	"",					"float",	\@fdata);
check_c("--math32",			"-float=ieee32",	"float",	\@fdata);
check_c("-fp-mode=ieee",	"-float=ieee32",	"float",	\@fdata);
check_c("--math16",			"-float=ieee16",	"_Float16",	\@fdata);
check_c("-math-z88",		"-float=z88",		"float",	\@fdata);
check_c("-fp-mode=z88",		"-float=z88",		"float",	\@fdata);
check_c("-fp-mode=mbf32",	"-float=mbfs",		"float",	\@fdata);
check_c("-fp-mode=mbf40",	"-float=mbf40",		"float",	\@fdata);
check_c("-fp-mode=mbf64",	"-float=mbf64",		"float",	\@fdata);
check_c("-fp-mode=am9511",	"-float=am9511",	"float",	\@fdata);

#-------------------------------------------------------------------------------
# check float expressions
#-------------------------------------------------------------------------------
check_float_expr(1, 1);
check_float_expr("pi", pi);
check_float_expr("e", exp(1));
check_float_expr("1+.5", 1.5);
check_float_expr("1-.5", 0.5);
check_float_expr("1+-.5", 0.5);
check_float_expr("2*4", 8);
check_float_expr("2/4", 0.5);
check_float_expr("2*-4", -8);
check_float_expr("2**8", 256);
check_float_expr("4**3**2", 262144);
check_float_expr("(4**3)**2", 4096);
check_float_expr("4**(0.5)", 2);
check_float_expr("+4", 4);
check_float_expr("++4", 4);
check_float_expr("++-4", -4);
check_float_expr("++--4", 4);
check_float_expr("2+3*4", 14);
check_float_expr("(2+3)*4", 20);
check_float_expr("2*3+4", 10);
check_float_expr("2*(3+4)", 14);
for my $func (qw(sin cos tan sinh cosh tanh)) {
	check_float_expr("$func(0.5)", eval "$func(0.5)");
	check_float_expr("a$func($func(0.5))", 0.5);
}
check_float_expr("atan2(0.5,0.5)", atan2(0.5,0.5));
check_float_expr("log(2.7)", log(2.7));
check_float_expr("log2(2.5)", log(2.5)/log(2));
check_float_expr("log10(15)", log(15)/log(10));
check_float_expr("exp(2)", exp(2));
check_float_expr("exp2(2)", 4);
check_float_expr("pow(2,4)", 16);
check_float_expr("sqrt(4)", 2);
check_float_expr("cbrt(8)", 2);
check_float_expr("ceil(2.5)", 3);
check_float_expr("ceil(-2.5)", -2);
check_float_expr("floor(2.5)", 2);
check_float_expr("floor(-2.5)", -3);
check_float_expr("trunc(2.5)", 2);
check_float_expr("trunc(-2.5)", -2);
check_float_expr("abs(2.5)", 2.5);
check_float_expr("abs(-2.5)", 2.5);
check_float_expr("hypot(2,3)", sqrt(2*2+3*3));
check_float_expr("fmod(10,3)", 1);
check_float_expr("fmod(10,-3)", 1);
check_float_expr("fmod(-10,3)", -1);
check_float_expr("fmod(-10,-3)", -1);

unlink_testfiles;
done_testing;
exit 0;

#-------------------------------------------------------------------------------
# functions
#-------------------------------------------------------------------------------
sub check_c {
	my($c_opts, $asm_opts, $c_type, $fdata) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;

	$fdata = join(",", @fdata);

	# build C code
	spew("$test.c", <<END);
		$c_type fdata[] = { $fdata };
		$c_type fend = 0.0;
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
	my $bin_data = slurp("$test.bin");
	my $c_bytes = unpack("H*", substr($bin_data, $fstart, $fsize)); 

	# build asm code
	spew("$test.asm", <<END);
		float $fdata
END

	# assemble
	run_ok("z88dk-z80asm -b -l $asm_opts $test.asm");
	
	# extract binary data
	$bin_data = slurp("$test.bin");
	my $asm_bytes = unpack("H*", $bin_data); 
	
	# compare
	is $asm_bytes, $c_bytes, "float data equal";
}

sub check_asm {
	my($ftype, $fdata, $bytes) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;

	# check via command line option
	my $opt = $ftype ? "-float=$ftype" : "";
	z80asm_ok("-b $opt", "", "", 
			  "float ".join(",", @$fdata),
			  bytes(@$bytes));

	$opt = $ftype ? "-float$ftype" : "";
	z80asm_ok("-b $opt", "", "", 
			  "float ".join(",", @$fdata),
			  bytes(@$bytes));
			  
	# check via setfloat
	my $setfloat = $ftype ? "setfloat $ftype" : "";
	z80asm_ok("-b", "", "", 
			  "$setfloat\n".
			  "float ".join(",", @$fdata),
			  bytes(@$bytes));
}

sub check_float_expr {
	my($expr, $expected) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;

	# assemble with verbose list file
	spew("$test.asm", "float $expr");
	run_ok("z88dk-z80asm -l -v $test.asm > $null");
	
	# parse "+ defb 0,0,0,0,0,129;float.genmath(1.000000)" from list file
	my $list = slurp("$test.lis");
	$list =~ /\+ defb [\d,]+;float\.genmath\(([0-9.e+-]+)\)/i 
		or die "float not found in $list";
	my $found = $1;
	
	ok abs($expected-$found)<1e-6, "expr $expr = $expected = $found";
}
