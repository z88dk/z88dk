#!/usr/bin/perl
#-----------------------------------------------------------------------------
# zobjcopy - manipulate z80asm object files
# Copyright (C) Paulo Custodio, 2011-2018
# License: http://www.perlfoundation.org/artistic_license_2_0
#-----------------------------------------------------------------------------

use Modern::Perl;
use Path::Tiny;
use Test::More;
use Capture::Tiny 'capture';

my $OBJ_FILE_VERSION = "11";

#------------------------------------------------------------------------------
# global test data
#------------------------------------------------------------------------------
my @objfile;
for my $version (1 .. $OBJ_FILE_VERSION) {
	$objfile[$version] = objfile(
		VERSION => $version,
		NAME => "file1",
		EXPRS => [
			# type, filename, line_nr, section, asmptr, ptr, target_name, text
			[ 'U', "file1.asm", 123, "text_1", 0, 1, "", "start % 256" ],
			[ 'S', "file1.asm", 132, "text_1", 0, 1, "", "start % 127" ],
			[ 'C', "file1.asm", 231, "text_1", 0, 1, "", "start" ],
			[ 'L', "file1.asm", 321, "text_1", 0, 1, "", "start" ],
			[ '=', "file1.asm", 321, "text_1", 0, 0, "_start", "start" ],
			[ 'B', "file1.asm", 231, "text_1", 0, 1, "", "start" ],
		],
		NAMES => [
			# scope, type, section, value, name, def_filename, line_nr
			[ 'L', 'A', "text_1", 0, "start", "file1.asm", 123 ],
			[ 'G', 'C', "text_1", 0, "main", "file1.asm", 231 ],
			[ 'G', '=', "text_1", 0, "_start", "file1.asm", 231 ],
		],
		EXTERNS => [
			# name, ...
			"ext1", "ext2"
		],
		CODES => [
			# section, org, align, code
			[ "text_1", 0, 1, "hello" ],
			[ "text_2", -1, 16, "world" ]
		],
	);
}

	my @expected;
	$expected[1] = <<'...';

File test.o at $0000: Z80RMF01
  Name: file1
  Org:  $0000
  Names:
    L A $0000 start
    G C $0000 main
  External names:
    U         ext1
    U         ext2
  Expressions:
    E Ub $0001: start % 256
    E Sb $0001: start % 127
    E Cw $0001: start
    E Ll $0001: start
  Code: 5 bytes
    C $0000: 68 65 6C 6C 6F
...
	$expected[2] = <<'...';

File test.o at $0000: Z80RMF02
  Name: file1
  Org:  $0000
  Names:
    L A $0000 start
    G C $0000 main
  External names:
    U         ext1
    U         ext2
  Expressions:
    E Ub $0001: start % 256
    E Sb $0001: start % 127
    E Cw $0001: start
    E Ll $0001: start
  Code: 5 bytes
    C $0000: 68 65 6C 6C 6F
...
	$expected[3] = <<'...';

File test.o at $0000: Z80RMF03
  Name: file1
  Org:  $0000
  Names:
    L A $0000 start
    G C $0000 main
  External names:
    U         ext1
    U         ext2
  Expressions:
    E Ub $0000 $0001: start % 256
    E Sb $0000 $0001: start % 127
    E Cw $0000 $0001: start
    E Ll $0000 $0001: start
  Code: 5 bytes
    C $0000: 68 65 6C 6C 6F
...
	$expected[4] = <<'...';

File test.o at $0000: Z80RMF04
  Name: file1
  Org:  $0000
  Names:
    L A $0000 start
    G C $0000 main
  External names:
    U         ext1
    U         ext2
  Expressions:
    E Ub (file1.asm:123) $0000 $0001: start % 256
    E Sb (file1.asm:132) $0000 $0001: start % 127
    E Cw (file1.asm:231) $0000 $0001: start
    E Ll (file1.asm:321) $0000 $0001: start
  Code: 5 bytes
    C $0000: 68 65 6C 6C 6F
...
	$expected[5] = <<'...';

File test.o at $0000: Z80RMF05
  Name: file1
  Org:  $0000
  Names:
    L A $0000 start (section text_1)
    G C $0000 main (section text_1)
  External names:
    U         ext1
    U         ext2
  Expressions:
    E Ub (file1.asm:123) $0000 $0001: start % 256 (section text_1)
    E Sb (file1.asm:132) $0000 $0001: start % 127 (section text_1)
    E Cw (file1.asm:231) $0000 $0001: start (section text_1)
    E Ll (file1.asm:321) $0000 $0001: start (section text_1)
  Code: 5 bytes (section text_1)
    C $0000: 68 65 6C 6C 6F
  Code: 5 bytes (section text_2)
    C $0000: 77 6F 72 6C 64
...
	$expected[6] = <<'...';

File test.o at $0000: Z80RMF06
  Name: file1
  Org:  $0000
  Names:
    L A $0000 start (section text_1)
    G C $0000 main (section text_1)
  External names:
    U         ext1
    U         ext2
  Expressions:
    E Ub (file1.asm:123) $0000 $0001: start % 256 (section text_1)
    E Sb (file1.asm:132) $0000 $0001: start % 127 (section text_1)
    E Cw (file1.asm:231) $0000 $0001: start (section text_1)
    E Ll (file1.asm:321) $0000 $0001: start (section text_1)
    E =  (file1.asm:321) $0000 $0000: _start := start (section text_1)
  Code: 5 bytes (section text_1)
    C $0000: 68 65 6C 6C 6F
  Code: 5 bytes (section text_2)
    C $0000: 77 6F 72 6C 64
...
	$expected[7] = <<'...';

File test.o at $0000: Z80RMF07
  Name: file1
  Org:  $0000
  Names:
    L A $0000 start (section text_1)
    G C $0000 main (section text_1)
    G = $0000 _start (section text_1)
  External names:
    U         ext1
    U         ext2
  Expressions:
    E Ub (file1.asm:123) $0000 $0001: start % 256 (section text_1)
    E Sb (file1.asm:132) $0000 $0001: start % 127 (section text_1)
    E Cw (file1.asm:231) $0000 $0001: start (section text_1)
    E Ll (file1.asm:321) $0000 $0001: start (section text_1)
    E =  (file1.asm:321) $0000 $0000: _start := start (section text_1)
  Code: 5 bytes (section text_1)
    C $0000: 68 65 6C 6C 6F
  Code: 5 bytes (section text_2)
    C $0000: 77 6F 72 6C 64
...
	$expected[8] = <<'...';

File test.o at $0000: Z80RMF08
  Name: file1
  Names:
    L A $0000 start (section text_1)
    G C $0000 main (section text_1)
    G = $0000 _start (section text_1)
  External names:
    U         ext1
    U         ext2
  Expressions:
    E Ub (file1.asm:123) $0000 $0001: start % 256 (section text_1)
    E Sb (file1.asm:132) $0000 $0001: start % 127 (section text_1)
    E Cw (file1.asm:231) $0000 $0001: start (section text_1)
    E Ll (file1.asm:321) $0000 $0001: start (section text_1)
    E =  (file1.asm:321) $0000 $0000: _start := start (section text_1)
  Code: 5 bytes, ORG $0000 (section text_1)
    C $0000: 68 65 6C 6C 6F
  Code: 5 bytes (section text_2)
    C $0000: 77 6F 72 6C 64
...
	$expected[9] = <<'...';

File test.o at $0000: Z80RMF09
  Name: file1
  Names:
    L A $0000 start (section text_1) file1.asm:123
    G C $0000 main (section text_1) file1.asm:231
    G = $0000 _start (section text_1) file1.asm:231
  External names:
    U         ext1
    U         ext2
  Expressions:
    E Ub (file1.asm:123) $0000 $0001: start % 256 (section text_1)
    E Sb (file1.asm:132) $0000 $0001: start % 127 (section text_1)
    E Cw (file1.asm:231) $0000 $0001: start (section text_1)
    E Ll (file1.asm:321) $0000 $0001: start (section text_1)
    E =  (file1.asm:321) $0000 $0000: _start := start (section text_1)
  Code: 5 bytes, ORG $0000 (section text_1)
    C $0000: 68 65 6C 6C 6F
  Code: 5 bytes (section text_2)
    C $0000: 77 6F 72 6C 64
...
	$expected[10] = <<'...';

File test.o at $0000: Z80RMF10
  Name: file1
  Names:
    L A $0000 start (section text_1) file1.asm:123
    G C $0000 main (section text_1) file1.asm:231
    G = $0000 _start (section text_1) file1.asm:231
  External names:
    U         ext1
    U         ext2
  Expressions:
    E Ub (file1.asm:123) $0000 $0001: start % 256 (section text_1)
    E Sb (file1.asm:132) $0000 $0001: start % 127 (section text_1)
    E Cw (file1.asm:231) $0000 $0001: start (section text_1)
    E Ll (file1.asm:321) $0000 $0001: start (section text_1)
    E =  (file1.asm:321) $0000 $0000: _start := start (section text_1)
  Code: 5 bytes, ORG $0000 (section text_1)
    C $0000: 68 65 6C 6C 6F
  Code: 5 bytes, ALIGN 16 (section text_2)
    C $0000: 77 6F 72 6C 64
...
	$expected[11] = <<'...';

File test.o at $0000: Z80RMF11
  Name: file1
  Names:
    L A $0000 start (section text_1) file1.asm:123
    G C $0000 main (section text_1) file1.asm:231
    G = $0000 _start (section text_1) file1.asm:231
  External names:
    U         ext1
    U         ext2
  Expressions:
    E Ub (file1.asm:123) $0000 $0001: start % 256 (section text_1)
    E Sb (file1.asm:132) $0000 $0001: start % 127 (section text_1)
    E Cw (file1.asm:231) $0000 $0001: start (section text_1)
    E Ll (file1.asm:321) $0000 $0001: start (section text_1)
    E =  (file1.asm:321) $0000 $0000: _start := start (section text_1)
    E BW (file1.asm:231) $0000 $0001: start (section text_1)
  Code: 5 bytes, ORG $0000 (section text_1)
    C $0000: 68 65 6C 6C 6F
  Code: 5 bytes, ALIGN 16 (section text_2)
    C $0000: 77 6F 72 6C 64
...

#------------------------------------------------------------------------------
# call zobjcopy
#------------------------------------------------------------------------------
my($out, $err, $exit, @dummy) = capture {system "zobjcopy"};
is $out, <<'...';
Usage: zobjcopy [options] input [output]
  -v|--verbose          show what is going on
  -l|--list             dump contents of file
...
is $err, "";
is !!$exit, !!0;

#------------------------------------------------------------------------------
($out, $err, $exit, @dummy) = capture {system "zobjcopy --wrong-option"};
is $out, "";
is $err, "error: invalid option -- 'wrong-option'\n";
is !!$exit, !!1;

#------------------------------------------------------------------------------
($out, $err, $exit, @dummy) = capture {system "zobjcopy -v"};
is $out, "";
is $err, "error: no input file\n";
is !!$exit, !!1;

#------------------------------------------------------------------------------
($out, $err, $exit, @dummy) = capture {system "zobjcopy test1.o test2.o test3.o"};
is $out, "";
is $err, "error: too many arguments\n";
is !!$exit, !!1;

#------------------------------------------------------------------------------
# parse object file of each version
#------------------------------------------------------------------------------
for my $version (1 .. $OBJ_FILE_VERSION) {
	$objfile[$version] && $expected[$version] 
		or die "Version $version not supported";
		
	path("test.o")->spew_raw($objfile[$version]);	
	($out, $err, $exit, @dummy) = capture {system "z80nm -a test.o"};
	is $out, $expected[$version];
	is $err, "";
	is !!$exit, !!0;

	($out, $err, $exit, @dummy) = capture {system "zobjcopy -l test.o"};
	is $out, $expected[$version];
	is $err, "";
	is !!$exit, !!0;
}

unlink "test.o";
done_testing;

#------------------------------------------------------------------------------
# return object file binary representation
sub objfile {
	my(%args) = @_;

	exists($args{ORG}) and die;
	
	my $o = "Z80RMF".sprintf("%02d",($args{VERSION} || $OBJ_FILE_VERSION));
	
	my $org = $args{CODES}[0][1] // -1;
	if ($args{VERSION} >= 8) {
		# no global ORG
	}
	elsif ($args{VERSION} >= 5) {
		$o .= pack("V", $org);
	}
	else {
		$o .= pack("v", $org);
	}
	
	# store empty pointers; mark position for later
	my $name_addr	 = length($o); $o .= pack("V", -1);
	my $expr_addr	 = length($o); $o .= pack("V", -1);
	my $symbols_addr = length($o); $o .= pack("V", -1);
	my $extern_addr	 = length($o); $o .= pack("V", -1);
	my $code_addr	 = length($o); $o .= pack("V", -1);

	# store expressions
	if ($args{EXPRS}) {
		store_ptr(\$o, $expr_addr);
		for (@{$args{EXPRS}}) {
			@$_ == 8 or die;
			my($type, $filename, $line_nr, $section, $asmpc, $patch_ptr, $target_name, $text) = @$_;
			next if $type eq '=' && $args{VERSION} < 6;
			next if $type eq 'B' && $args{VERSION} < 11;
			
			$o .= $type;
			$o .= pack_lstring($filename) . pack("V", $line_nr) if $args{VERSION} >= 4;
			$o .= pack_string($section)							if $args{VERSION} >= 5;
			$o .= pack("v", $asmpc)								if $args{VERSION} >= 3;
			$o .= pack("v", $patch_ptr);
			$o .= pack_string($target_name)						if $args{VERSION} >= 6;
			if ($args{VERSION} >= 4) {
				$o .= pack_lstring($text);
			}
			else {
				$o .= pack_string($text) . pack("C", 0);
			}
		}
		$o .= pack("C", 0) if $args{VERSION} >= 4;
	}

	# store symbols
	if ($args{NAMES}) {
		store_ptr(\$o, $symbols_addr);
		for (@{$args{NAMES}}) {
			@$_ == 7 or die;
			my($scope, $type, $section, $value, $name, $def_filename, $line_nr) = @$_;
			next if $type eq '=' && $args{VERSION} < 7;

			$o .= $scope . $type;
			$o .= pack_string($section)								if $args{VERSION} >= 5;
			$o .= pack("V", $value) . pack_string($name);
			$o .= pack_string($def_filename) . pack("V", $line_nr)	if $args{VERSION} >= 9;
		}
		$o .= pack("C", 0) if $args{VERSION} >= 5;
	}

	# store externals
	if ($args{EXTERNS}) {
		store_ptr(\$o, $extern_addr);
		for my $name (@{$args{EXTERNS}}) {
			$o .= pack_string($name);
		}
	}

	# store name
	store_ptr(\$o, $name_addr);
	$o .= pack_string($args{NAME});

	# store code
	if ( $args{CODES} ) {
		ref($args{CODES}) eq 'ARRAY' or die;
		store_ptr(\$o, $code_addr);
		for (@{$args{CODES}}) {
			@$_ == 4 or die;
			my($section, $org, $align, $code) = @$_;
			
			if ($args{VERSION} >= 5) {
				$o .= pack("V", length($code)) . pack_string($section);
				$o .= pack("V", $org)		if $args{VERSION} >= 8;
				$o .= pack("V", $align)		if $args{VERSION} >= 10;
				$o .= $code;				
			}
			else {
				$o .= pack("v", length($code) & 0xFFFF) . $code;
				last;					# only one code block
			}
		}
		$o .= pack("V", -1) if $args{VERSION} >= 5;
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
sub pack_string {
	my($string) = @_;
	return pack("C", length($string)).$string;
}

#------------------------------------------------------------------------------
sub pack_lstring {
	my($string) = @_;
	return pack("v", length($string)).$string;
}

