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
use Config;

my $OBJ_FILE_VERSION = "11";

$ENV{PATH} = ".".$Config{path_sep}."../../bin".$Config{path_sep}.$ENV{PATH};

#------------------------------------------------------------------------------
# global test data
#------------------------------------------------------------------------------
my @objfile;
my @libfile;
for my $version (1 .. $OBJ_FILE_VERSION) {
	$objfile[$version] = objfile(
		VERSION => $version,
		NAME => "file1",
		EXPRS => [
			# type, filename, line_nr, section, asmptr, ptr, target_name, text
			[ 'U', "file1.asm", 123, "text_1", 0, 1, "", "start1 % 256" ],
			[ 'S', "file1.asm", 132, "text_2", 0, 1, "", "start2 % 127" ],
			[ 'C', "file1.asm", 231, "data_1", 0, 1, "", "msg1" ],
			[ 'L', "file1.asm", 321, "data_2", 0, 1, "", "msg2" ],
			[ '=', "file1.asm", 321, "text_1", 0, 0, "_start", "start1" ],
			[ 'B', "file1.asm", 231, "text_1", 0, 1, "", "start1" ],
		],
		NAMES => [
			# scope, type, section, value, name, def_filename, line_nr
			[ 'L', 'A', "text_1", 2, "start1", "file1.asm", 123 ],
			[ 'L', 'A', "text_2", 2, "start2", "file1.asm", 123 ],
			[ 'G', 'A', "data_1", 2, "msg1", "file1.asm", 123 ],
			[ 'G', 'A', "data_2", 2, "msg2", "file1.asm", 123 ],
			[ 'G', 'C', "text_1", 0, "main", "file1.asm", 231 ],
			[ 'L', '=', "text_1", 0, "_start", "file1.asm", 231 ],
		],
		EXTERNS => [
			# name, ...
			"ext1", "ext2"
		],
		CODES => [
			# section, org, align, code
			[ "text_1",      0,  1, pack("C*", 1..63) ],
			[ "text_2",     -1, 16, pack("C*", 1..64) ],
			[ "base",       -1,  1, pack("C*", (0xAA) x 16)],
			[ "data_1", 0x8000,  1, pack("C*",  1..10) ],
			[ "data_2",     -1,  1, pack("C*", 11..20) ],
		],
	);
	
	$libfile[$version] = libfile(
			VERSION => $version,
			OBJS => [$objfile[$version], $objfile[$version]]
	);
}

#------------------------------------------------------------------------------
# call zobjcopy
#------------------------------------------------------------------------------
ok run("zobjcopy", <<'...', "", 0);
Usage: zobjcopy input [options] [output]
  -v|--verbose                      ; show what is going on
  -l|--list                         ; dump contents of file
  -s|--section old-regexp=new-name  ; rename all sections that match
...

path("test.o")->spew_raw($objfile[$OBJ_FILE_VERSION]);

ok run("zobjcopy --wrong-option", 					"", "error: invalid option -- 'wrong-option'\n", 	1);
ok run("zobjcopy -v",	 							"", "error: no input file\n", 						1);
ok run("zobjcopy -s",	 							"", "error: option requires an argument -- 's'\n",	1);
ok run("zobjcopy --section aaa",					"", "error: no '=' in --section argument 'aaa'\n",	1);
ok run("zobjcopy --section ?=aaa test.o test2.o",	"", "error: could not compile regex '?'\n",			1);
ok run("zobjcopy test1.o test2.o test3.o",			"", "error: too many arguments\n",					1);
ok run("zobjcopy -l test1.o test2.o",				"", "error: too many arguments\n",					1);
ok run("zobjcopy test.o",							"", "error: no output file\n",						1);

path("test.o")->spew_raw($objfile[1]);

ok run("zobjcopy -v test.o test2.o",				<<"...", "",										0);
Reading file 'test.o': object version 1
Writing file 'test2.o': object version $OBJ_FILE_VERSION
...

unlink "test.o", "test2.o";

#------------------------------------------------------------------------------
# parse object file of each version
#------------------------------------------------------------------------------
my $bmk;
my $bmk2;
for my $version (1 .. $OBJ_FILE_VERSION) {
	$objfile[$version] && $libfile[$version] 
		or die "Version $version not supported";
	
	path("test.o")->spew_raw($objfile[$version]);
	unlink "test2.o";

	$bmk = sprintf("t/bmk_obj_%02d.txt", $version);
	$bmk2 = sprintf("t/bmk_obj_%02d_converted.txt", $version);
	my $out = sprintf("t/out_obj_%02d.txt", $version);
	
	is 0, system("z80nm -a test.o > $out"), "z80nm -a test.o > $out";
	is 0, system("diff -w $out $bmk"), "diff -w $out $bmk";
	
	system("winmergeu $out $bmk") unless Test::More->builder->is_passing;
	die unless Test::More->builder->is_passing;

	is 0, system("zobjcopy -l test.o > $out"), "zobjcopy -l test.o > $out";
	is 0, system("diff -w $out $bmk"), "diff -w $out $bmk";
	
	system("winmergeu $out $bmk") unless Test::More->builder->is_passing;
	die unless Test::More->builder->is_passing;

	is 0, system("zobjcopy test.o test2.o"), "zobjcopy test.o test2.o";
	is 0, system("zobjcopy -l test2.o > $out"), "zobjcopy -l test2.o > $out";
	is 0, system("diff -w $out $bmk2"), "diff -w $out $bmk2";
	
	system("winmergeu $out $bmk2") unless Test::More->builder->is_passing;
	die unless Test::More->builder->is_passing;

	unlink "test.o", "test2.o", $out;
	
	path("test.lib")->spew_raw($libfile[$version]);
	unlink "test2.lib";
	
	$bmk = sprintf("t/bmk_lib_%02d.txt", $version);
	$bmk2 = sprintf("t/bmk_lib_%02d_converted.txt", $version);
	$out = sprintf("t/out_lib_%02d.txt", $version);
	
	is 0, system("z80nm -a test.lib > $out"), "z80nm -a test.lib > $out";
	is 0, system("diff -w $out $bmk"), "diff -w $out $bmk";
	
	system("winmergeu $out $bmk") unless Test::More->builder->is_passing;
	die unless Test::More->builder->is_passing;

	is 0, system("zobjcopy -l test.lib > $out"), "zobjcopy -l test.lib > $out";
	is 0, system("diff -w $out $bmk"), "diff -w $out $bmk";

	system("winmergeu $out $bmk") unless Test::More->builder->is_passing;
	die unless Test::More->builder->is_passing;

	is 0, system("zobjcopy test.lib test2.lib"), "zobjcopy test.lib test2.lib";
	is 0, system("zobjcopy -l test2.lib > $out"), "zobjcopy -l test2.lib > $out";
	is 0, system("diff -w $out $bmk2"), "diff -w $out $bmk2";
	
	system("winmergeu $out $bmk2") unless Test::More->builder->is_passing;
	die unless Test::More->builder->is_passing;

	unlink "test.lib", "test2.lib", $out;
}

die unless Test::More->builder->is_passing;

#------------------------------------------------------------------------------
# rename sections
#------------------------------------------------------------------------------
path("test.o")->spew_raw($objfile[$OBJ_FILE_VERSION]);
unlink "test2.o";

my $cmd = "zobjcopy test.o --verbose -s text=text --section data=data test2.o";
ok 1, $cmd;
my($out, $err, $exit, @dummy) = capture {system $cmd};
is $out, <<'...';
Reading file 'test.o': object version 11
Renaming sections in file 'test.o' that match 'text' to 'text'
Block 'Z80RMF11'
  skip section ""
  rename section text_1 -> text
  rename section text_2 -> text
  skip section base
  skip section data_1
  skip section data_2
Renaming sections in file 'test.o' that match 'data' to 'data'
Block 'Z80RMF11'
  skip section ""
  skip section text
  skip section base
  rename section data_1 -> data
  rename section data_2 -> data
Writing file 'test2.o': object version 11
...
is $err, "";
is !!$exit, !!0;

$bmk = sprintf("t/bmk_obj_%02d_sections1.txt", $OBJ_FILE_VERSION);
$out = sprintf("t/out_obj_%02d.txt", $OBJ_FILE_VERSION);

is 0, system("zobjcopy -l test2.o > $out"), "zobjcopy -l test2.o > $out";
is 0, system("diff -w $out $bmk"), "diff -w $out $bmk";

system("winmergeu $out $bmk") unless Test::More->builder->is_passing;
die unless Test::More->builder->is_passing;

unlink "test.o", "test2.o", $out;


path("test.lib")->spew_raw($libfile[$OBJ_FILE_VERSION]);
unlink "test2.lib";

$cmd = "zobjcopy test.lib --verbose -s text=text --section data=data test2.lib";
ok 1, $cmd;
($out, $err, $exit, @dummy) = capture {system $cmd};
is $out, <<'...';
Reading file 'test.lib': library version 11
Renaming sections in file 'test.lib' that match 'text' to 'text'
Block 'Z80RMF11'
  skip section ""
  rename section text_1 -> text
  rename section text_2 -> text
  skip section base
  skip section data_1
  skip section data_2
Block 'Z80RMF11'
  skip section ""
  rename section text_1 -> text
  rename section text_2 -> text
  skip section base
  skip section data_1
  skip section data_2
Renaming sections in file 'test.lib' that match 'data' to 'data'
Block 'Z80RMF11'
  skip section ""
  skip section text
  skip section base
  rename section data_1 -> data
  rename section data_2 -> data
Block 'Z80RMF11'
  skip section ""
  skip section text
  skip section base
  rename section data_1 -> data
  rename section data_2 -> data
Writing file 'test2.lib': library version 11
...
is $err, "";
is !!$exit, !!0;

$bmk = sprintf("t/bmk_lib_%02d_sections1.txt", $OBJ_FILE_VERSION);
$out = sprintf("t/out_lib_%02d.txt", $OBJ_FILE_VERSION);

is 0, system("zobjcopy -l test2.lib > $out"), "zobjcopy -l test2.lib > $out";
is 0, system("diff -w $out $bmk"), "diff -w $out $bmk";

system("winmergeu $out $bmk") unless Test::More->builder->is_passing;
die unless Test::More->builder->is_passing;

unlink "test.lib", "test2.lib", $out;


path("test.o")->spew_raw($objfile[$OBJ_FILE_VERSION]);
unlink "test2.o";

$cmd = "zobjcopy -v test.o -s .=ram test2.o";
ok 1, $cmd;
($out, $err, $exit, @dummy) = capture {system $cmd};
is $out, <<'...';
Reading file 'test.o': object version 11
Renaming sections in file 'test.o' that match '.' to 'ram'
Block 'Z80RMF11'
  skip section ""
  rename section text_1 -> ram
  rename section text_2 -> ram
  rename section base -> ram
  rename section data_1 -> ram
  rename section data_2 -> ram
Writing file 'test2.o': object version 11
...
is $err, "";
is !!$exit, !!0;

$bmk = sprintf("t/bmk_obj_%02d_sections2.txt", $OBJ_FILE_VERSION);
$out = sprintf("t/out_obj_%02d.txt", $OBJ_FILE_VERSION);

is 0, system("zobjcopy -l test2.o > $out"), "zobjcopy -l test2.o > $out";
is 0, system("diff -w $out $bmk"), "diff -w $out $bmk";

system("winmergeu $out $bmk") unless Test::More->builder->is_passing;
die unless Test::More->builder->is_passing;

unlink "test.o", "test2.o", $out;


path("test.o")->spew_raw($objfile[$OBJ_FILE_VERSION]);
unlink "test2.o";

$cmd = "zobjcopy -v test.o -s ^text=rom_text -s ^data=ram_data test2.o";
ok 1, $cmd;
($out, $err, $exit, @dummy) = capture {system $cmd};
is $out, <<'...';
Reading file 'test.o': object version 11
Renaming sections in file 'test.o' that match '^text' to 'rom_text'
Block 'Z80RMF11'
  skip section ""
  rename section text_1 -> rom_text
  rename section text_2 -> rom_text
  skip section base
  skip section data_1
  skip section data_2
Renaming sections in file 'test.o' that match '^data' to 'ram_data'
Block 'Z80RMF11'
  skip section ""
  skip section rom_text
  skip section base
  rename section data_1 -> ram_data
  rename section data_2 -> ram_data
Writing file 'test2.o': object version 11
...
is $err, "";
is !!$exit, !!0;

$bmk = sprintf("t/bmk_obj_%02d_sections3.txt", $OBJ_FILE_VERSION);
$out = sprintf("t/out_obj_%02d.txt", $OBJ_FILE_VERSION);

is 0, system("zobjcopy -l test2.o > $out"), "zobjcopy -l test2.o > $out";
is 0, system("diff -w $out $bmk"), "diff -w $out $bmk";

system("winmergeu $out $bmk") unless Test::More->builder->is_passing;
die unless Test::More->builder->is_passing;

unlink "test.o", "test2.o", $out;


path("test.o")->spew_raw($objfile[$OBJ_FILE_VERSION]);
unlink "test2.o";

ok run("zobjcopy -v test.o -s ^data=base test2.o", <<'...', "", 0);
Reading file 'test.o': object version 11
Renaming sections in file 'test.o' that match '^data' to 'base'
Block 'Z80RMF11'
  skip section ""
  skip section text_1
  skip section text_2
  rename section base -> base
  rename section data_1 -> base
  rename section data_2 -> base
Writing file 'test2.o': object version 11
...

$bmk = sprintf("t/bmk_obj_%02d_sections4.txt", $OBJ_FILE_VERSION);
$out = sprintf("t/out_obj_%02d.txt", $OBJ_FILE_VERSION);

is 0, system("zobjcopy -l test2.o > $out"), "zobjcopy -l test2.o > $out";
is 0, system("diff -w $out $bmk"), "diff -w $out $bmk";

system("winmergeu $out $bmk") unless Test::More->builder->is_passing;
die unless Test::More->builder->is_passing;

unlink "test.o", "test2.o", $out;


path("test.o")->spew_raw($objfile[$OBJ_FILE_VERSION]);
unlink "test2.o";

ok run("zobjcopy -v test.o -s ^data=base -s ^text=base test2.o", <<'...', "", 0);
Reading file 'test.o': object version 11
Renaming sections in file 'test.o' that match '^data' to 'base'
Block 'Z80RMF11'
  skip section ""
  skip section text_1
  skip section text_2
  rename section base -> base
  rename section data_1 -> base
  rename section data_2 -> base
Renaming sections in file 'test.o' that match '^text' to 'base'
Block 'Z80RMF11'
  skip section ""
  rename section text_1 -> base
  rename section text_2 -> base
  rename section base -> base
Writing file 'test2.o': object version 11
...

$bmk = sprintf("t/bmk_obj_%02d_sections5.txt", $OBJ_FILE_VERSION);
$out = sprintf("t/out_obj_%02d.txt", $OBJ_FILE_VERSION);

is 0, system("zobjcopy -l test2.o > $out"), "zobjcopy -l test2.o > $out";
is 0, system("diff -w $out $bmk"), "diff -w $out $bmk";

system("winmergeu $out $bmk") unless Test::More->builder->is_passing;
die unless Test::More->builder->is_passing;

unlink "test.o", "test2.o", $out;

#------------------------------------------------------------------------------
# handle the case with no sections
#------------------------------------------------------------------------------
path("test.asm")->spew(<<'...');
	public aa
	defc aa=2		; in section ''
	section text	; so that obj file has one section but no ''
...
ok run("z80asm test.asm", "", "", 0);
ok run("zobjcopy -l test.o", <<'...', "", 0);
Object  file test.o at $0000: Z80RMF11
  Name: test
  Section text: 0 bytes
  Symbols:
    G C $0002 aa (section "") (file test.asm:2)
...

ok run("zobjcopy test.o test2.o", "", "", 0);
ok run("zobjcopy -l test2.o", <<'...', "", 0);
Object  file test2.o at $0000: Z80RMF11
  Name: test
  Section "": 0 bytes
  Section text: 0 bytes
  Symbols:
    G C $0002 aa (section "") (file test.asm:2)
...

unlink "test.asm", "test.o", "test2.o";

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
# return library file binary representation
sub libfile {
	my(%args) = @_;

	my $o = "Z80LMF".sprintf("%02d",($args{VERSION} || $OBJ_FILE_VERSION));
	my $next_pos;
	my @objs = @{$args{OBJS}};
	for (0 .. $#objs) {
		my $obj = $objs[$_];
		
		# save a "deleted" copy
		$next_pos = length($o); $o .= pack("V", -1);
		$o .= pack("V", 0);
		$o .= $obj;
		store_ptr(\$o, $next_pos);

		# save a a not-deleted copy
		$next_pos = length($o); $o .= pack("V", -1);
		$o .= pack("V", length($obj));
		$o .= $obj;
		store_ptr(\$o, $next_pos) if $_ != $#objs;
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

#------------------------------------------------------------------------------
sub run {
	my($cmd, $exp_out, $exp_err, $exp_exit) = @_;

	my $ok = Test::More->builder->is_passing;
	
	ok 1, $cmd;
	my($out, $err, $exit, @dummy) = capture {system $cmd};
	is $out, $exp_out, $cmd;
	is $err, $exp_err, $cmd;
	is !!$exit, !!$exp_exit, $cmd;
	
	return $ok && Test::More->builder->is_passing;
}
