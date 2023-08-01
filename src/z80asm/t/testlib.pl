#!/usr/bin/env perl

use Modern::Perl;
use Test::More;
use Config;
use Capture::Tiny 'capture_merged';
use Data::HexDump;
use Path::Tiny;
use Text::Diff;

$ENV{PATH} = join($Config{path_sep}, 
			".",
			"../../bin",
			$ENV{PATH});

my $OBJ_FILE_VERSION = "18";

use vars '$test', '$null';
$test = "test_".(($0 =~ s/\.t$//r) =~ s/[\.\/\\]/_/gr);
$null = ($^O eq 'MSWin32') ? 'nul' : '/dev/null';

unlink_testfiles();

#------------------------------------------------------------------------------
sub check_bin_file {
    my($got_file, $exp_bin) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    
	my $got_bin = slurp($got_file);
	my $got_hex = HexDump($got_bin);
	
	my $exp_hex = HexDump($exp_bin);
	
	my $diff = diff(\$exp_hex, \$got_hex, {STYLE => 'Context'});
	is $diff, "", "bin file $got_file ok";
	
	die if $ENV{DEBUG} && !Test::More->builder->is_passing;
}

#------------------------------------------------------------------------------
sub check_text_file {
    my($got_file, $exp_text) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    
	(my $got_text = slurp($got_file)) =~ s/\r\n/\n/g;
	$exp_text =~ s/\r\n/\n/g;
	
	my $diff = diff(\$exp_text, \$got_text, {STYLE => 'Context'});
	is $diff, "", "text file $got_file ok";
	
	die if $ENV{DEBUG} && !Test::More->builder->is_passing;
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
    spew($asm_file, $asm);
    unlink($bin_file);
    
    # assemble
    $options ||= "-b";
    $files ||= $asm_file;

    run_ok("z88dk-z80asm $options $files 2> ${test}.stderr");
    check_bin_file($bin_file, $bin);
    check_text_file("${test}.stderr", $exp_warn) if $exp_warn;
	
	die if $ENV{DEBUG} && !Test::More->builder->is_passing;
}

#------------------------------------------------------------------------------
sub z80asm_nok {
    my($options, $files, $asm, $exp_err) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    
    # save asm file
    my $asm_file = "${test}.asm";
	spew($asm_file, $asm);
    
    # assemble
    $options ||= "-b";
    $files ||= $asm_file;

    capture_nok("z88dk-z80asm $options $files", $exp_err);
	
	die if $ENV{DEBUG} && !Test::More->builder->is_passing;
}

#------------------------------------------------------------------------------
sub ticks {
	my($source, $options) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;

	spew("$test.asm", $source);
	run_ok("z88dk-z80asm $options -b -l $test.asm");
	
	my $cpu = ($options =~ /(?:-m=?)(\S+)/) ? $1 : "z80";
	$cpu = 'ez80_z80' if $cpu eq 'ez80';
	run_ok("z88dk-ticks $test.bin -m$cpu -output $test.out");

	my $bin = slurp("$test.out");
	my $mem = substr($bin, 0, 0x10000); $mem =~ s/\0+$//;
	my @mem = map {ord} split //, $mem;
	my @regs = map {ord} split //, substr($bin, 0x10000);
	my $ret = {
		mem 	=> \@mem, 
	};
	$ret->{F} = shift @regs;	$ret->{F_S}  = ($ret->{F} & 0x80) ? 1 : 0;
								$ret->{F_Z}  = ($ret->{F} & 0x40) ? 1 : 0;
								$ret->{F_H}  = ($ret->{F} & 0x10) ? 1 : 0;
								$ret->{F_PV} = ($ret->{F} & 0x04) ? 1 : 0;
								$ret->{F_N}  = ($ret->{F} & 0x02) ? 1 : 0;
								$ret->{F_C}  = ($ret->{F} & 0x01) ? 1 : 0;
	$ret->{A} = shift @regs;
	$ret->{C} = shift @regs;
	$ret->{B} = shift @regs;	$ret->{BC} = ($ret->{B} << 8) | $ret->{C};
	$ret->{L} = shift @regs;
	$ret->{H} = shift @regs;	$ret->{HL} = ($ret->{H} << 8) | $ret->{L};
	my $PCl = shift @regs;
	my $PCh = shift @regs;		$ret->{PC} = ($PCh << 8) | $PCl;
	my $SPl = shift @regs;
	my $SPh = shift @regs;		$ret->{SP} = ($SPh << 8) | $SPl;
	$ret->{I} = shift @regs;
	$ret->{R} = shift @regs;
	$ret->{E} = shift @regs;
	$ret->{D} = shift @regs;	$ret->{DE} = ($ret->{D} << 8) | $ret->{E};
	$ret->{C_} = shift @regs;
	$ret->{B_} = shift @regs;	$ret->{BC_} = ($ret->{B_} << 8) | $ret->{C_};
	$ret->{E_} = shift @regs;
	$ret->{D_} = shift @regs;	$ret->{DE_} = ($ret->{D_} << 8) | $ret->{E_};
	$ret->{L_} = shift @regs;
	$ret->{H_} = shift @regs;	$ret->{HL_} = ($ret->{H_} << 8) | $ret->{L_};
	$ret->{F_} = shift @regs;	$ret->{F__S}  = ($ret->{F_} & 0x80) ? 1 : 0;
								$ret->{F__Z}  = ($ret->{F_} & 0x40) ? 1 : 0;
								$ret->{F__H}  = ($ret->{F_} & 0x10) ? 1 : 0;
								$ret->{F__PV} = ($ret->{F_} & 0x04) ? 1 : 0;
								$ret->{F__N}  = ($ret->{F_} & 0x02) ? 1 : 0;
								$ret->{F__C}  = ($ret->{F_} & 0x01) ? 1 : 0;
	$ret->{A_} = shift @regs;
	my $IYl = shift @regs;
	my $IYh = shift @regs;		$ret->{IY} = ($IYh << 8) | $IYl;
	my $IXl = shift @regs;
	my $IXh = shift @regs;		$ret->{IX} = ($IXh << 8) | $IXl;
	$ret->{IFF} = shift @regs;
	$ret->{IM} = shift @regs;
	my $MPl = shift @regs;
	my $MPh = shift @regs;		$ret->{MP} = ($MPh << 8) | $MPl;
	@regs == 8 or die;
		
	die if $ENV{DEBUG} && !Test::More->builder->is_passing;

	return $ret;
}

sub parity {
	my($a) = @_;
	my $bits = 0;
	$bits++ if $a & 0x80;
	$bits++ if $a & 0x40;
	$bits++ if $a & 0x20;
	$bits++ if $a & 0x10;
	$bits++ if $a & 0x08;
	$bits++ if $a & 0x04;
	$bits++ if $a & 0x02;
	$bits++ if $a & 0x01;
	return ($bits & 1) == 0 ? 1 : 0;
}

#------------------------------------------------------------------------------
sub capture_ok {
    my($cmd, $exp_out) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    
    run_ok($cmd." > ${test}.stdout");
    check_text_file("${test}.stdout", $exp_out);
	
	die if $ENV{DEBUG} && !Test::More->builder->is_passing;
}

#------------------------------------------------------------------------------
sub capture_nok {
    my($cmd, $exp_err) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    run_nok($cmd." 2> ${test}.stderr");
    check_text_file("${test}.stderr", $exp_err);
	
	die if $ENV{DEBUG} && !Test::More->builder->is_passing;
}

#------------------------------------------------------------------------------
sub run_ok {
    my($cmd) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
	
	ok 1, "Running: $cmd";
    ok 0==system($cmd), $cmd;
	
	die if $ENV{DEBUG} && !Test::More->builder->is_passing;
}

#------------------------------------------------------------------------------
sub run_nok {
    my($cmd) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
	
	ok 1, "Running: $cmd";
    ok 0!=system($cmd), $cmd;
	
	die if $ENV{DEBUG} && !Test::More->builder->is_passing;
}

#------------------------------------------------------------------------------
sub bytes { return pack("C*", map {$_ & 0xff} @_); }
sub words { return pack("v*", @_); }
sub words_be { return pack("n*", @_); }
sub pointers { return join('', map {pack("vC", $_ & 0xFFFF, ($_ >> 16) & 0xFF)} @_); }
sub dwords { return pack("V*", @_); }

sub unlink_testfiles {
	my(@additional) = @_;
    unlink(<${test}*>, @additional) 
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

	# store CPU and -IXIY
	$o .= pack("VV", 1, 0);
	
	# store expressions
	if ($args{EXPR}) {
		store_ptr(\$o, $expr_addr);
		for (@{$args{EXPR}}) {
			@$_ == 9 or die;
			my($type, $filename, $line_nr, $section, $asmptr, $ptr, $opcode_size, 
			   $target_name, $text) = @$_;
			$o .= $type . pack_lstring($filename) . pack("V", $line_nr) .
			        pack_lstring($section) . pack("VVV", $asmptr, $ptr, $opcode_size) .
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
		my $next_ptr = length($lib) + 4 + 4 + length($o_file);

		$lib .= pack("V", $next_ptr);
		$lib .= pack("V", length($o_file));
		$lib .= $o_file;
	}
	$lib .= pack("V", -1);	# next
	$lib .= pack("V", 0);	# length = deleted

	return $lib;
}

#------------------------------------------------------------------------------
# quote command line argument with "" on Windows, '' otherwise
sub quote_os {
	my($txt) = @_;
	if ($^O eq 'MSWin32') {
		return '"'.$txt.'"';
	}
	else {
		return "'".$txt."'";
	}
}

#------------------------------------------------------------------------------
# path()->spew fails sometimes on Windows (race condition?) with 
# Error rename on 'test_t_ALIGN.asm37032647357911' -> 'test_t_ALIGN.asm': Permission denied
# replace by a simpler spew without renames
sub spew {
	my($file, @data) = @_;
	local $Test::Builder::Level = $Test::Builder::Level + 1;

	my $open_ok = open(my $fh, ">:raw", $file);
	ok $open_ok, "write $file"; 
	
	if ($open_ok) {
		print $fh join('', @data);
	}
	
	die if $ENV{DEBUG} && !Test::More->builder->is_passing;
}

#------------------------------------------------------------------------------
# and for simetry
sub slurp {
	my($file) = @_;
	local $Test::Builder::Level = $Test::Builder::Level + 1;

	my $open_ok = open(my $fh, "<:raw", $file);
	ok $open_ok, "read $file";
	
	if ($open_ok) {
		read($fh, my $data, -s $file);
		return $data;
	}
	else {
		return "";
	}
	
	die if $ENV{DEBUG} && !Test::More->builder->is_passing;
}

1;
