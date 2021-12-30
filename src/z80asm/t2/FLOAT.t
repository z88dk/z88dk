#!/usr/bin/env perl

BEGIN { use lib 't2'; require 'testlib.pl'; }

#-------------------------------------------------------------------------------
# errors
#-------------------------------------------------------------------------------
my $invalid_format_error = 
"invalid float format, expected one of: genmath,math48,ieee16,ieee32,ieee64,zx81,zx";

capture_nok("./z88dk-z80asm -float", <<END);
Error: $invalid_format_error
END

capture_nok("./z88dk-z80asm -float=xx", <<END);
Error: $invalid_format_error
END

z80asm_nok("", "", <<END_ASM, <<END_ERR);
		float 
END_ASM
Error at file '$test.asm' line 1: syntax error
END_ERR

z80asm_nok("", "", <<END_ASM, <<END_ERR);
		float xx
END_ASM
Error at file '$test.asm' line 1: $invalid_format_error
END_ERR

#-------------------------------------------------------------------------------
# test against hand-crafted data
#-------------------------------------------------------------------------------
my @fdata = (1., -1., 255., -255., 256., -256.,
			 65535., -65535., 65536., -65536.,
			 5.5, -5.5, 5.5e1, 5.e-1);

for my $opts ("", "-float=genmath", "-float=math48") {
	check_asm("$opts", \@fdata,
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

check_asm("-float=ieee16", \@fdata,
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

check_asm("-float=ieee32", \@fdata,
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

check_asm("-float=ieee64", \@fdata,
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

check_asm("-float=zx81", \@fdata,
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

check_asm("-float=zx", \@fdata,
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

#-------------------------------------------------------------------------------
# compare C and ASM representations
#-------------------------------------------------------------------------------
check_c("-lm", 		"",					"float",	\@fdata);
check_c("-lm", 		"-float=genmath",	"float",	\@fdata);
check_c("-lmath48", "",					"float",	\@fdata);
check_c("-lmath48", "-float=genmath",	"float",	\@fdata);
check_c("--math32",	"-float=ieee32",	"float",	\@fdata);
check_c("--math16",	"-float=ieee16",	"_Float16",	\@fdata);

unlink_testfiles;
done_testing;
exit 0;


sub check_c {
	my($c_opts, $asm_opts, $c_type, $fdata) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;

	$fdata = join(",", @fdata);

	# build C code
	path("$test.c")->spew(<<END);
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

sub check_asm {
	my($opts, $fdata, $bytes) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;

	z80asm_ok("-b $opts", "", "", 
			  "float ".join(",", @$fdata),
			  bytes(@$bytes));
}
