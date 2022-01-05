#!/usr/bin/env perl

use Modern::Perl;
use Test::More;
use Capture::Tiny 'capture_merged';
use Path::Tiny;

my $OBJ_FILE_VERSION = "16";

use vars '$test';
$test = "test_".(($0 =~ s/\.t$//r) =~ s/[\.\/]/_/gr);

#------------------------------------------------------------------------------
sub check_bin_file {
    my($got_file, $exp) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    
    run_ok("xxd -g1 $got_file > $got_file.hex");
    
    my $exp_file = ($got_file =~ s/\.\w+$/.exp/ir);
    path($exp_file)->spew_raw($exp);
    run_ok("xxd -g1 $exp_file > $exp_file.hex");
    
    run_ok("diff $exp_file.hex $got_file.hex");
}

#------------------------------------------------------------------------------
sub check_txt_file {
    my($got_file, $exp) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    
    my $exp_file = ($got_file =~ s/\.\w+$/.exp/ir);
    path($exp_file)->spew($exp);
    
    run_ok("dos2unix -q $exp_file $got_file");
    run_ok("diff $exp_file $got_file");
}

#------------------------------------------------------------------------------
sub z80asm_ok {
    my($options, $files, $exp_warn, @pairs_asm_bin) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    
    # build $asm and $bin
    my($asm, $bin) = ("","");
    while (my($a, $b) = splice(@pairs_asm_bin, 0, 2)) {
        $asm .= "$a\n";
        $bin .= $b;
    }
    
    # save asm file
    my $asm_file = "${test}.asm";
    my $bin_file = "${test}.bin";
    path($asm_file)->spew($asm);
    unlink($bin_file);
    
    # assemble
    $options ||= "-b";
    $files ||= $asm_file;

    run_ok("./z88dk-z80asm $options $files 2> ${test}.stderr");
    check_bin_file($bin_file, $bin);
    check_txt_file("${test}.stderr", $exp_warn) if $exp_warn;
}

#------------------------------------------------------------------------------
sub z80asm_nok {
    my($options, $files, $asm, $exp_err) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    
    # save asm file
    my $asm_file = "${test}.asm";
    path($asm_file)->spew($asm);
    
    # assemble
    $options ||= "-b";
    $files ||= $asm_file;

    capture_nok("./z88dk-z80asm $options $files", $exp_err);
}

#------------------------------------------------------------------------------
sub capture_ok {
    my($cmd, $exp_out) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    
    run_ok($cmd." > ${test}.stdout");
    check_txt_file("${test}.stdout", $exp_out);
}

#------------------------------------------------------------------------------
sub capture_nok {
    my($cmd, $exp_err) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    run_nok($cmd." 2> ${test}.stderr");
    check_txt_file("${test}.stderr", $exp_err);
}

#------------------------------------------------------------------------------
sub run_ok {
    my($cmd) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    ok 0==system($cmd), $cmd;
}

#------------------------------------------------------------------------------
sub run_nok {
    my($cmd) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    ok 0!=system($cmd), $cmd;
}

#------------------------------------------------------------------------------
sub bytes { return pack("C*", map {$_ & 0xff} @_); }
sub words { return pack("v*", @_); }
sub words_be { return pack("n*", @_); }
sub pointers { return join('', map {pack("vC", $_ & 0xFFFF, ($_ >> 16) & 0xFF)} @_); }
sub dwords { return pack("V*", @_); }

sub unlink_testfiles {
    unlink(<${test}*>) 
        if Test::More->builder->is_passing;
}

# return object file binary representation
sub objfile {
	my(%args) = @_;

	exists($args{ORG}) and die;

	my $o = "Z80RMF".$OBJ_FILE_VERSION;

	# store empty pointers; mark position for later
	my $name_addr	 = length($o); $o .= pack("V", -1);
	my $expr_addr	 = length($o); $o .= pack("V", -1);
	my $symbols_addr = length($o); $o .= pack("V", -1);
	my $lib_addr	 = length($o); $o .= pack("V", -1);
	my $code_addr	 = length($o); $o .= pack("V", -1);

	# store expressions
	if ($args{EXPR}) {
		store_ptr(\$o, $expr_addr);
		for (@{$args{EXPR}}) {
			@$_ == 8 or die;
			my($type, $filename, $line_nr, $section, $asmptr, $ptr, $target_name, $text) = @$_;
			$o .= $type . pack_lstring($filename) . pack("V", $line_nr) .
			        pack_lstring($section) . pack("vv", $asmptr, $ptr) .
					pack_lstring($target_name) . pack_lstring($text);
		}
		$o .= "\0";
	}

	# store symbols
	if ($args{SYMBOLS}) {
		store_ptr(\$o, $symbols_addr);
		for (@{$args{SYMBOLS}}) {
			@$_ == 7 or die;
			my($scope, $type, $section, $value, $name, $def_filename, $line_nr) = @$_;
			$o .= $scope . $type . pack_lstring($section) .
					pack("V", $value) . pack_lstring($name) .
					pack_lstring($def_filename) . pack("V", $line_nr);
		}
		$o .= "\0";
	}

	# store library
	if ($args{LIBS}) {
		store_ptr(\$o, $lib_addr);
		for my $name (@{$args{LIBS}}) {
			$o .= pack_lstring($name);
		}
	}

	# store name
	store_ptr(\$o, $name_addr);
	$o .= pack_lstring($args{NAME});

	# store code
	if ( $args{CODE} ) {
		ref($args{CODE}) eq 'ARRAY' or die;
		store_ptr(\$o, $code_addr);
		for (@{$args{CODE}}) {
			@$_ == 4 or die;
			my($section, $org, $align, $code) = @$_;
			$o .= pack("V", length($code)) .
			        pack_lstring($section) .
					pack("VV", $org, $align) .
					$code;
		}
		$o .= pack("V", -1);
	}

	return $o;
}

#------------------------------------------------------------------------------
# store a pointer to the end of the binary object at the given address
sub store_ptr {
	my($robj, $addr) = @_;
	my $ptr = length($$robj);
	my $packed_ptr = pack("V", $ptr);
	substr($$robj, $addr, length($packed_ptr)) = $packed_ptr;
}

#------------------------------------------------------------------------------
sub pack_lstring {
	my($string) = @_;
	return pack("v", length($string)).$string;
}

#------------------------------------------------------------------------------
# return library file binary representation
sub libfile {
	my(@o_files) = @_;
	my $lib = "Z80LMF".$OBJ_FILE_VERSION;
	for my $i (0 .. $#o_files) {
		my $o_file = $o_files[$i];
		my $next_ptr = ($i == $#o_files) ?
						-1 : length($lib) + 4 + 4 + length($o_file);

		$lib .= pack("V", $next_ptr);
		$lib .= pack("V", length($o_file));
		$lib .= $o_file;
	}

	return $lib;
}

1;
