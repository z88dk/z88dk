#!/usr/bin/perl
#-----------------------------------------------------------------------------
# zobjcopy - manipulate z80asm object files
# Copyright (C) Paulo Custodio, 2011-2022
# License: http://www.perlfoundation.org/artistic_license_2_0
#-----------------------------------------------------------------------------

use Modern::Perl;
use Path::Tiny;
use Test::More;
use Capture::Tiny 'capture';
use Config;

my $OBJ_FILE_VERSION = "12";

$ENV{PATH} = join($Config{path_sep}, 
				".",
				"../z80nm",
				"../../bin",
				$ENV{PATH});

#------------------------------------------------------------------------------
# build tools
#------------------------------------------------------------------------------
ok 0 == system("make"), "make";
ok 0 == system("make -C ../z80nm"), "make -C ../z80nm";

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
			[ 'C', "file1.asm", 231, "data_1", 0, 1, "", "ext1" ],
			[ 'L', "file1.asm", 321, "data_2", 0, 1, "", "ext2" ],
			[ 'C', "file1.asm", 231, "data_1", 0, 1, "", "msg2-msg1" ],
			[ '=', "file1.asm", 321, "text_1", 0, 0, "_start", "start1" ],
			[ 'B', "file1.asm", 231, "text_1", 0, 1, "", "start1" ],
			[ 'J', "file1.asm", 456, "text_1", 0, 1, "", "start1" ],
		],
		NAMES => [
			# scope, type, section, value, name, def_filename, line_nr
			[ 'L', 'A', "text_1", 2, "start1", "file1.asm", 123 ],
			[ 'L', 'A', "text_2", 2, "start2", "file1.asm", 123 ],
			[ 'G', 'A', "data_1", 2, "msg1", "file1.asm", 123 ],
			[ 'G', 'A', "data_2", 2, "msg2", "file1.asm", 123 ],
			[ 'G', 'C', "text_1", 0, "main", "file1.asm", 231 ],
			[ 'G', '=', "text_1", 0, "_start", "file1.asm", 231 ],
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
ok run("zobjcopy", <<'...');
Usage: zobjcopy input [options] [output]
  -v|--verbose                          ; show what is going on
  -l|--list                             ; dump contents of file
     --hide-local                       ; in list don't show local symbols
     --hide-expr                        ; in list don't show expressions
     --hide-code                        ; in list don't show code dump
  -s|--section old-regexp=new-name      ; rename all sections that match
  -p|--add-prefix symbol-regexp,prefix  ; add prefix to all symbols that match
  -y|--symbol old-name=new-name         ; rename global and extern symbols
  -L|--local regexp                     ; make symbols that match local
  -G|--global regexp                    ; make symbols that match global
  -F|--filler nn|0xhh                   ; use nn as filler for align
  -O|--org section,nn|0xhh              ; change ORG of one section
  -A|--align section,nn|0xhh            ; change ALIGN of one section
...

path("test.o")->spew_raw($objfile[$OBJ_FILE_VERSION]);

ok run("zobjcopy --wrong-option", 					"", "error: invalid option -- 'wrong-option'\n", 		1);
ok run("zobjcopy -v",	 							"", "error: no input file\n", 							1);
ok run("zobjcopy -s",	 							"", "error: option requires an argument -- 's'\n",		1);
ok run("zobjcopy --section aaa",					"", "error: no '=' in --section argument 'aaa'\n",		1);
ok run("zobjcopy --section ?=aaa test.o test2.o",	"", "error: could not compile regex '?'\n",				1);
ok run("zobjcopy --add-prefix aaa",					"", "error: no ',' in --add-prefix argument 'aaa'\n",	1);
ok run("zobjcopy --add-prefix ?,aaa test.o test2.o","", "error: could not compile regex '?'\n",				1);
ok run("zobjcopy --symbol aaa",						"", "error: no '=' in --symbol argument 'aaa'\n",		1);
ok run("zobjcopy --local",							"", "error: option requires an argument -- 'local'\n",	1);
ok run("zobjcopy --global",							"", "error: option requires an argument -- 'global'\n",	1);
ok run("zobjcopy --filler",							"", "error: option requires an argument -- 'filler'\n",	1);
ok run("zobjcopy --org",							"", "error: option requires an argument -- 'org'\n",	1);
ok run("zobjcopy --org aaa",						"", "error: no ',' in --org argument 'aaa'\n",			1);
ok run("zobjcopy --align",							"", "error: option requires an argument -- 'align'\n",	1);
ok run("zobjcopy --align aaa",						"", "error: no ',' in --align argument 'aaa'\n",		1);
ok run("zobjcopy test1.o test2.o test3.o",			"", "error: too many arguments\n",						1);
ok run("zobjcopy -l test1.o test2.o",				"", "error: too many arguments\n",						1);
ok run("zobjcopy test.o",							"", "error: no output file\n",							1);

path("test.o")->spew_raw($objfile[1]);	
	
ok run("zobjcopy -v test.o test2.o", <<"...");
Reading file 'test.o': object version 1
Writing file 'test2.o': object version $OBJ_FILE_VERSION
...

unlink "test.o", "test2.o";

#------------------------------------------------------------------------------
# parse object file of each version
#------------------------------------------------------------------------------
for my $version (1 .. $OBJ_FILE_VERSION) {
	$objfile[$version] && $libfile[$version] 
		or die "Version $version not supported";
	
	path("test.o")->spew_raw($objfile[$version]); 
	unlink "test2.o";

	ok check_z80nm("test.o", 		sprintf("t/bmk_obj_%02d.txt", $version));
	ok check_zobjcopy("test.o", 	sprintf("t/bmk_obj_%02d.txt", $version));
	ok run("zobjcopy test.o test2.o");
	ok check_zobjcopy("test2.o", 	sprintf("t/bmk_obj_%02d_converted.txt", $version));
	unlink "test.o", "test2.o";
	
	path("test.lib")->spew_raw($libfile[$version]);
	unlink "test2.lib";
	
	ok check_z80nm("test.lib", 		sprintf("t/bmk_lib_%02d.txt", $version));
	ok check_zobjcopy("test.lib", 	sprintf("t/bmk_lib_%02d.txt", $version));
	ok run("zobjcopy test.lib test2.lib");
	ok check_zobjcopy("test2.lib", 	sprintf("t/bmk_lib_%02d_converted.txt", $version));
	unlink "test.lib", "test2.lib";
}

#------------------------------------------------------------------------------
# rename sections
#------------------------------------------------------------------------------
path("test.o")->spew_raw($objfile[$OBJ_FILE_VERSION]);
unlink "test2.o";

ok run("zobjcopy test.o --verbose -s text=text --section data=data test2.o", <<"...");
Reading file 'test.o': object version $OBJ_FILE_VERSION
File 'test.o': rename sections that match 'text' to 'text'
Block 'Z80RMF$OBJ_FILE_VERSION'
  skip section ""
  rename section text_1 -> text
  rename section text_2 -> text
  skip section base
  skip section data_1
  skip section data_2
File 'test.o': rename sections that match 'data' to 'data'
Block 'Z80RMF$OBJ_FILE_VERSION'
  skip section ""
  skip section text
  skip section base
  rename section data_1 -> data
  rename section data_2 -> data
Writing file 'test2.o': object version $OBJ_FILE_VERSION
...
ok check_zobjcopy("test2.o", 	sprintf("t/bmk_obj_%02d_sections1.txt", $OBJ_FILE_VERSION));
unlink "test.o", "test2.o";

path("test.lib")->spew_raw($libfile[$OBJ_FILE_VERSION]);
unlink "test2.lib";

ok run("zobjcopy test.lib --verbose -s text=text --section data=data test2.lib", <<"...");
Reading file 'test.lib': library version $OBJ_FILE_VERSION
File 'test.lib': rename sections that match 'text' to 'text'
Block 'Z80RMF$OBJ_FILE_VERSION'
  skip section ""
  rename section text_1 -> text
  rename section text_2 -> text
  skip section base
  skip section data_1
  skip section data_2
Block 'Z80RMF$OBJ_FILE_VERSION'
  skip section ""
  rename section text_1 -> text
  rename section text_2 -> text
  skip section base
  skip section data_1
  skip section data_2
File 'test.lib': rename sections that match 'data' to 'data'
Block 'Z80RMF$OBJ_FILE_VERSION'
  skip section ""
  skip section text
  skip section base
  rename section data_1 -> data
  rename section data_2 -> data
Block 'Z80RMF$OBJ_FILE_VERSION'
  skip section ""
  skip section text
  skip section base
  rename section data_1 -> data
  rename section data_2 -> data
Writing file 'test2.lib': library version $OBJ_FILE_VERSION
...
ok check_zobjcopy("test2.lib", 	sprintf("t/bmk_lib_%02d_sections1.txt", $OBJ_FILE_VERSION));
unlink "test.lib", "test2.lib";

path("test.o")->spew_raw($objfile[$OBJ_FILE_VERSION]);
unlink "test2.o";

ok run("zobjcopy -v test.o -s .=ram test2.o", <<"...");
Reading file 'test.o': object version $OBJ_FILE_VERSION
File 'test.o': rename sections that match '.' to 'ram'
Block 'Z80RMF$OBJ_FILE_VERSION'
  skip section ""
  rename section text_1 -> ram
  rename section text_2 -> ram
  rename section base -> ram
  rename section data_1 -> ram
  rename section data_2 -> ram
Writing file 'test2.o': object version $OBJ_FILE_VERSION
...
ok check_zobjcopy("test2.o", 	sprintf("t/bmk_obj_%02d_sections2.txt", $OBJ_FILE_VERSION));
unlink "test.o", "test2.o";

path("test.o")->spew_raw($objfile[$OBJ_FILE_VERSION]);
unlink "test2.o";

ok run("zobjcopy -v test.o -s ^text=rom_text -s ^data=ram_data test2.o", <<"...");
Reading file 'test.o': object version $OBJ_FILE_VERSION
File 'test.o': rename sections that match '^text' to 'rom_text'
Block 'Z80RMF$OBJ_FILE_VERSION'
  skip section ""
  rename section text_1 -> rom_text
  rename section text_2 -> rom_text
  skip section base
  skip section data_1
  skip section data_2
File 'test.o': rename sections that match '^data' to 'ram_data'
Block 'Z80RMF$OBJ_FILE_VERSION'
  skip section ""
  skip section rom_text
  skip section base
  rename section data_1 -> ram_data
  rename section data_2 -> ram_data
Writing file 'test2.o': object version $OBJ_FILE_VERSION
...
ok check_zobjcopy("test2.o", 	sprintf("t/bmk_obj_%02d_sections3.txt", $OBJ_FILE_VERSION));
unlink "test.o", "test2.o";

path("test.o")->spew_raw($objfile[$OBJ_FILE_VERSION]);
unlink "test2.o";

ok run("zobjcopy -v test.o -s ^data=base test2.o", <<"...");
Reading file 'test.o': object version $OBJ_FILE_VERSION
File 'test.o': rename sections that match '^data' to 'base'
Block 'Z80RMF$OBJ_FILE_VERSION'
  skip section ""
  skip section text_1
  skip section text_2
  rename section base -> base
  rename section data_1 -> base
  rename section data_2 -> base
Writing file 'test2.o': object version $OBJ_FILE_VERSION
...
ok check_zobjcopy("test2.o", 	sprintf("t/bmk_obj_%02d_sections4.txt", $OBJ_FILE_VERSION));
unlink "test.o", "test2.o";

path("test.o")->spew_raw($objfile[$OBJ_FILE_VERSION]);
unlink "test2.o";

ok run("zobjcopy -v test.o -s ^data=base -s ^text=base test2.o", <<"...");
Reading file 'test.o': object version $OBJ_FILE_VERSION
File 'test.o': rename sections that match '^data' to 'base'
Block 'Z80RMF$OBJ_FILE_VERSION'
  skip section ""
  skip section text_1
  skip section text_2
  rename section base -> base
  rename section data_1 -> base
  rename section data_2 -> base
File 'test.o': rename sections that match '^text' to 'base'
Block 'Z80RMF$OBJ_FILE_VERSION'
  skip section ""
  rename section text_1 -> base
  rename section text_2 -> base
  rename section base -> base
Writing file 'test2.o': object version $OBJ_FILE_VERSION
...
ok check_zobjcopy("test2.o", 	sprintf("t/bmk_obj_%02d_sections5.txt", $OBJ_FILE_VERSION));
unlink "test.o", "test2.o";

path("test.o")->spew_raw($objfile[$OBJ_FILE_VERSION]);
unlink "test2.o";

ok run("zobjcopy test.o --verbose --filler 0x55 -s text=text test2.o", <<"...");
Filler byte: \$55
Reading file 'test.o': object version $OBJ_FILE_VERSION
File 'test.o': rename sections that match 'text' to 'text'
Block 'Z80RMF$OBJ_FILE_VERSION'
  skip section ""
  rename section text_1 -> text
  rename section text_2 -> text
  skip section base
  skip section data_1
  skip section data_2
Writing file 'test2.o': object version $OBJ_FILE_VERSION
...
ok check_zobjcopy("test2.o", 	sprintf("t/bmk_obj_%02d_sections6.txt", $OBJ_FILE_VERSION));
unlink "test.o", "test2.o";

path("test.o")->spew_raw($objfile[$OBJ_FILE_VERSION]);
unlink "test2.o";

ok run("zobjcopy test.o --verbose -F 127 -s text=text test2.o", <<"...");
Filler byte: \$7F
Reading file 'test.o': object version $OBJ_FILE_VERSION
File 'test.o': rename sections that match 'text' to 'text'
Block 'Z80RMF$OBJ_FILE_VERSION'
  skip section ""
  rename section text_1 -> text
  rename section text_2 -> text
  skip section base
  skip section data_1
  skip section data_2
Writing file 'test2.o': object version $OBJ_FILE_VERSION
...
ok check_zobjcopy("test2.o", 	sprintf("t/bmk_obj_%02d_sections7.txt", $OBJ_FILE_VERSION));
unlink "test.o", "test2.o";

path("test.o")->spew_raw($objfile[$OBJ_FILE_VERSION]);
unlink "test2.o";

ok run("zobjcopy test.o --verbose -s .=text --org text,0x8000 --align text,64 test2.o", <<"...");
Reading file 'test.o': object version $OBJ_FILE_VERSION
File 'test.o': rename sections that match '.' to 'text'
Block 'Z80RMF$OBJ_FILE_VERSION'
  skip section ""
  rename section text_1 -> text
  rename section text_2 -> text
  rename section base -> text
  rename section data_1 -> text
  rename section data_2 -> text
File 'test.o': set section 'text' ORG to \$8000
Block 'Z80RMF$OBJ_FILE_VERSION'
  skip section ""
  section text ORG -> \$8000
File 'test.o': set section 'text' ALIGN to \$0040
Block 'Z80RMF$OBJ_FILE_VERSION'
  skip section ""
  section text ALIGN -> \$0040
Writing file 'test2.o': object version $OBJ_FILE_VERSION
...
ok check_zobjcopy("test2.o", 	sprintf("t/bmk_obj_%02d_sections8.txt", $OBJ_FILE_VERSION));
unlink "test.o", "test2.o";

path("test.o")->spew_raw($objfile[$OBJ_FILE_VERSION]);
unlink "test2.o";

ok run("zobjcopy test.o --verbose -s .=text -O text,0x8000 -A text,64 test2.o", <<"...");
Reading file 'test.o': object version $OBJ_FILE_VERSION
File 'test.o': rename sections that match '.' to 'text'
Block 'Z80RMF$OBJ_FILE_VERSION'
  skip section ""
  rename section text_1 -> text
  rename section text_2 -> text
  rename section base -> text
  rename section data_1 -> text
  rename section data_2 -> text
File 'test.o': set section 'text' ORG to \$8000
Block 'Z80RMF$OBJ_FILE_VERSION'
  skip section ""
  section text ORG -> \$8000
File 'test.o': set section 'text' ALIGN to \$0040
Block 'Z80RMF$OBJ_FILE_VERSION'
  skip section ""
  section text ALIGN -> \$0040
Writing file 'test2.o': object version $OBJ_FILE_VERSION
...
ok check_zobjcopy("test2.o", 	sprintf("t/bmk_obj_%02d_sections8.txt", $OBJ_FILE_VERSION));
unlink "test.o", "test2.o";

#------------------------------------------------------------------------------
# add prefix to symbols
#------------------------------------------------------------------------------
path("test.o")->spew_raw($objfile[$OBJ_FILE_VERSION]);
unlink "test2.o";

ok run("zobjcopy test.o --verbose --add-prefix .,lib_ test2.o", <<"...");
Reading file 'test.o': object version $OBJ_FILE_VERSION
File 'test.o': add prefix 'lib_' to symbols that match '.'
Block 'Z80RMF$OBJ_FILE_VERSION'
  rename symbol main -> lib_main
  rename symbol _start -> lib__start
  rename symbol msg1 -> lib_msg1
  rename symbol msg2 -> lib_msg2
Writing file 'test2.o': object version $OBJ_FILE_VERSION
...
ok check_zobjcopy("test2.o", 	sprintf("t/bmk_obj_%02d_add-prefix1.txt", $OBJ_FILE_VERSION));
unlink "test.o", "test2.o";

path("test.o")->spew_raw($objfile[$OBJ_FILE_VERSION]);
unlink "test2.o";

ok run("zobjcopy test.o --verbose -p m,lib_ test2.o", <<"...");
Reading file 'test.o': object version $OBJ_FILE_VERSION
File 'test.o': add prefix 'lib_' to symbols that match 'm'
Block 'Z80RMF$OBJ_FILE_VERSION'
  rename symbol main -> lib_main
  skip symbol _start
  rename symbol msg1 -> lib_msg1
  rename symbol msg2 -> lib_msg2
Writing file 'test2.o': object version $OBJ_FILE_VERSION
...
ok check_zobjcopy("test2.o", 	sprintf("t/bmk_obj_%02d_add-prefix2.txt", $OBJ_FILE_VERSION));
unlink "test.o", "test2.o";

#------------------------------------------------------------------------------
# rename symbol
#------------------------------------------------------------------------------
path("test.o")->spew_raw($objfile[$OBJ_FILE_VERSION]);
unlink "test2.o";

ok run("zobjcopy test.o --verbose --symbol ext1=ff_lib_ext1 -y ext=xxx -y msg1=MSG1 test2.o", <<"...");
Reading file 'test.o': object version $OBJ_FILE_VERSION
File 'test.o': rename symbol 'ext1' to 'ff_lib_ext1'
Block 'Z80RMF$OBJ_FILE_VERSION'
  rename symbol ext1 -> ff_lib_ext1
  skip symbol ext2
  skip symbol main
  skip symbol _start
  skip symbol msg1
  skip symbol msg2
File 'test.o': rename symbol 'ext' to 'xxx'
Block 'Z80RMF$OBJ_FILE_VERSION'
  skip symbol ff_lib_ext1
  skip symbol ext2
  skip symbol main
  skip symbol _start
  skip symbol msg1
  skip symbol msg2
File 'test.o': rename symbol 'msg1' to 'MSG1'
Block 'Z80RMF$OBJ_FILE_VERSION'
  skip symbol ff_lib_ext1
  skip symbol ext2
  skip symbol main
  skip symbol _start
  rename symbol msg1 -> MSG1
  skip symbol msg2
Writing file 'test2.o': object version $OBJ_FILE_VERSION
...
ok check_zobjcopy("test2.o", sprintf("t/bmk_obj_%02d_symbol1.txt", $OBJ_FILE_VERSION));
unlink "test.o", "test2.o";

#------------------------------------------------------------------------------
# make symbols local
#------------------------------------------------------------------------------
path("test.o")->spew_raw($objfile[$OBJ_FILE_VERSION]);
unlink "test2.o";

ok run("zobjcopy test.o --verbose --local \"^_\" -L msg test2.o", <<"...");
Reading file 'test.o': object version $OBJ_FILE_VERSION
File 'test.o': make symbols that match '^_' local
Block 'Z80RMF$OBJ_FILE_VERSION'
  skip symbol main
  change scope of symbol _start -> L
  skip symbol msg1
  skip symbol msg2
File 'test.o': make symbols that match 'msg' local
Block 'Z80RMF$OBJ_FILE_VERSION'
  skip symbol main
  change scope of symbol msg1 -> L
  change scope of symbol msg2 -> L
Writing file 'test2.o': object version $OBJ_FILE_VERSION
...
ok check_zobjcopy("test2.o", sprintf("t/bmk_obj_%02d_local1.txt", $OBJ_FILE_VERSION));
unlink "test.o", "test2.o";

#------------------------------------------------------------------------------
# make symbols global
#------------------------------------------------------------------------------
path("test.o")->spew_raw($objfile[$OBJ_FILE_VERSION]);
unlink "test2.o";

ok run("zobjcopy test.o --verbose --global start -G s test2.o", <<"...");
Reading file 'test.o': object version $OBJ_FILE_VERSION
File 'test.o': make symbols that match 'start' global
Block 'Z80RMF$OBJ_FILE_VERSION'
  change scope of symbol start1 -> G
  change scope of symbol start2 -> G
File 'test.o': make symbols that match 's' global
Block 'Z80RMF$OBJ_FILE_VERSION'
Writing file 'test2.o': object version $OBJ_FILE_VERSION
...
ok check_zobjcopy("test2.o", sprintf("t/bmk_obj_%02d_global1.txt", $OBJ_FILE_VERSION));
unlink "test.o", "test2.o";

#------------------------------------------------------------------------------
# list
#------------------------------------------------------------------------------
path("test.o")->spew_raw($objfile[$OBJ_FILE_VERSION]);
unlink "test2.o";

ok check_zobjcopy("test.o", sprintf("t/bmk_obj_%02d.txt", $OBJ_FILE_VERSION), "");
ok check_zobjcopy("test.o", sprintf("t/bmk_obj_%02d_list1.txt", $OBJ_FILE_VERSION), "--hide-local");
ok check_zobjcopy("test.o", sprintf("t/bmk_obj_%02d_list2.txt", $OBJ_FILE_VERSION), "--hide-expr");
ok check_zobjcopy("test.o", sprintf("t/bmk_obj_%02d_list3.txt", $OBJ_FILE_VERSION), "--hide-code");

ok check_z80nm("test.o", sprintf("t/bmk_obj_%02d.txt", $OBJ_FILE_VERSION), "-l -e -c");
ok check_z80nm("test.o", sprintf("t/bmk_obj_%02d_list1.txt", $OBJ_FILE_VERSION), "-e -c");
ok check_z80nm("test.o", sprintf("t/bmk_obj_%02d_list2.txt", $OBJ_FILE_VERSION), "-l -c");
ok check_z80nm("test.o", sprintf("t/bmk_obj_%02d_list3.txt", $OBJ_FILE_VERSION), "-l -e");

unlink "test.o";

#------------------------------------------------------------------------------
# handle the case with no sections
#------------------------------------------------------------------------------
path("test.asm")->spew(<<'...');
	public aa
	defc aa=2		; in section ''
	section text	; so that obj file has one section but no ''
...
ok run("z80asm test.asm");
ok run("zobjcopy -l test.o", <<"...");
Object  file test.o at \$0000: Z80RMF$OBJ_FILE_VERSION
  Name: test
  Section text: 0 bytes
  Symbols:
    G C \$0002 aa (section "") (file test.asm:2)
...

ok run("zobjcopy test.o test2.o");
ok run("zobjcopy -l test2.o", <<"...");
Object  file test2.o at \$0000: Z80RMF$OBJ_FILE_VERSION
  Name: test
  Section "": 0 bytes
  Section text: 0 bytes
  Symbols:
    G C \$0002 aa (section "") (file test.asm:2)
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
			next if $type eq 'J' && $args{VERSION} < 12;
			
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
	$exp_out //= "";
	$exp_err //= "";
	$exp_exit //= 0;	

	my $ok = Test::More->builder->is_passing;
	
	ok 1, $cmd;
	my($out, $err, $exit, @dummy) = capture {system $cmd};
	is $out, $exp_out, $cmd;
	is $err, $exp_err, $cmd;
	is !!$exit, !!$exp_exit, $cmd;
	
	return $ok && Test::More->builder->is_passing;
}

#------------------------------------------------------------------------------
sub check_zobjcopy_nm {
	my($cmd, $file, $bmk) = @_;
	
	my $ok = Test::More->builder->is_passing;
	
	(my $out = $bmk) =~ s/$/.out/;
	
	is 0, system("$cmd $file > $out"), "$cmd $file > $out";
	my $diff = system("diff -w $out $bmk");
	is 0, $diff;
	
	system("winmergeu $out $bmk") if $diff;
	unlink $out unless $diff;
	
	return $ok && Test::More->builder->is_passing;
}

sub check_zobjcopy {
	my($file, $bmk, $options) = @_;
	$options //= "";
	return check_zobjcopy_nm("zobjcopy -l $options", $file, $bmk);

}

sub check_z80nm {
	my($file, $bmk, $options) = @_;
	$options //= "-a";
	return check_zobjcopy_nm("z80nm $options", $file, $bmk);

}
