#!/usr/bin/env perl
#-----------------------------------------------------------------------------
# zobjcopy - manipulate z80asm object files
# Copyright (C) Paulo Custodio, 2011-2023
# License: http://www.perlfoundation.org/artistic_license_2_0
#-----------------------------------------------------------------------------

use Modern::Perl;
use Path::Tiny;
use Test::More;
use Capture::Tiny 'capture';
use Config;

my $OBJ_FILE_VERSION = "18";

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
			# type, filename, line_nr, section, asmptr, ptr, opcode_size, target_name, text
			[ 'U', "file1.asm", 123, "text_1", 0, 1, 2, "", "start1 % 256" ],
			[ 'S', "file1.asm", 132, "text_2", 0, 1, 2, "", "start2 % 127" ],
			[ 'u', "file1.asm", 123, "text_1", 0, 1, 2, "", "256" ],
			[ 's', "file1.asm", 132, "text_2", 0, 1, 2, "", "256" ],
			[ 'C', "file1.asm", 231, "data_1", 0, 1, 2, "", "msg1" ],
			[ 'L', "file1.asm", 321, "data_2", 0, 1, 2, "", "msg2" ],
			[ 'C', "file1.asm", 231, "data_1", 0, 1, 2, "", "ext1" ],
			[ 'L', "file1.asm", 321, "data_2", 0, 1, 2, "", "ext2" ],
			[ 'C', "file1.asm", 231, "data_1", 0, 1, 2, "", "msg2-msg1" ],
			[ '=', "file1.asm", 321, "text_1", 0, 0, 2, "_start", "start1" ],
			[ 'B', "file1.asm", 231, "text_1", 0, 1, 2, "", "start1" ],
			[ 'J', "file1.asm", 456, "text_1", 0, 1, 2, "", "start1" ],
			[ 'P', "file1.asm", 456, "text_1", 0, 1, 2, "", "start1" ],
			[ 'H', "file1.asm", 456, "text_1", 0, 1, 2, "", "0xff01" ],
		],
		SYMBOLS => [
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
		CODE => [
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
			OBJS => [$objfile[$version], $objfile[$version]],
			PUBLIC => ["data_1", "data_2", "text_1"]
	);
}

#------------------------------------------------------------------------------
# call zobjcopy
#------------------------------------------------------------------------------
ok run("z88dk-zobjcopy", <<'...');
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

ok run("z88dk-zobjcopy --wrong-option", 					"", "error: invalid option -- 'wrong-option'\n", 		1);
ok run("z88dk-zobjcopy -v",	 							"", "error: no input file\n", 							1);
ok run("z88dk-zobjcopy -s",	 							"", "error: option requires an argument -- 's'\n",		1);
ok run("z88dk-zobjcopy --section aaa",					"", "error: no '=' in --section argument 'aaa'\n",		1);
ok run("z88dk-zobjcopy --section ?=aaa test.o test2.o",	"", "error: could not compile regex '?'\n",				1);
ok run("z88dk-zobjcopy --add-prefix aaa",					"", "error: no ',' in --add-prefix argument 'aaa'\n",	1);
ok run("z88dk-zobjcopy --add-prefix ?,aaa test.o test2.o","", "error: could not compile regex '?'\n",				1);
ok run("z88dk-zobjcopy --symbol aaa",						"", "error: no '=' in --symbol argument 'aaa'\n",		1);
ok run("z88dk-zobjcopy --local",							"", "error: option requires an argument -- 'local'\n",	1);
ok run("z88dk-zobjcopy --global",							"", "error: option requires an argument -- 'global'\n",	1);
ok run("z88dk-zobjcopy --filler",							"", "error: option requires an argument -- 'filler'\n",	1);
ok run("z88dk-zobjcopy --org",							"", "error: option requires an argument -- 'org'\n",	1);
ok run("z88dk-zobjcopy --org aaa",						"", "error: no ',' in --org argument 'aaa'\n",			1);
ok run("z88dk-zobjcopy --align",							"", "error: option requires an argument -- 'align'\n",	1);
ok run("z88dk-zobjcopy --align aaa",						"", "error: no ',' in --align argument 'aaa'\n",		1);
ok run("z88dk-zobjcopy test1.o test2.o test3.o",			"", "error: too many arguments\n",						1);
ok run("z88dk-zobjcopy -l test1.o test2.o",				"", "error: too many arguments\n",						1);
ok run("z88dk-zobjcopy test.o",							"", "error: no output file\n",							1);

path("test.o")->spew_raw($objfile[1]);	
	
ok run("z88dk-zobjcopy -v test.o test2.o", <<"...");
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
	(Test::More->builder->is_passing) or die;

	ok check_zobjcopy("test.o", 	sprintf("t/bmk_obj_%02d.txt", $version));
	(Test::More->builder->is_passing) or die;

	ok run("z88dk-zobjcopy test.o test2.o");
	(Test::More->builder->is_passing) or die;

	ok check_zobjcopy("test2.o", 	sprintf("t/bmk_obj_%02d_converted.txt", $version));
	(Test::More->builder->is_passing) or die;

	unlink "test.o", "test2.o";
	
	path("test.lib")->spew_raw($libfile[$version]);
	unlink "test2.lib";
	
	ok check_z80nm("test.lib", 		sprintf("t/bmk_lib_%02d.txt", $version));
	(Test::More->builder->is_passing) or die;

	ok check_zobjcopy("test.lib", 	sprintf("t/bmk_lib_%02d.txt", $version));
	(Test::More->builder->is_passing) or die;

	ok run("z88dk-zobjcopy test.lib test2.lib");
	(Test::More->builder->is_passing) or die;

	ok check_zobjcopy("test2.lib", 	sprintf("t/bmk_lib_%02d_converted.txt", $version));
	(Test::More->builder->is_passing) or die;
	
	unlink "test.lib", "test2.lib";
}

#------------------------------------------------------------------------------
# rename sections
#------------------------------------------------------------------------------
path("test.o")->spew_raw($objfile[$OBJ_FILE_VERSION]);
unlink "test2.o";

ok run("z88dk-zobjcopy test.o --verbose -s text=text --section data=data test2.o", <<"...");
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

ok run("z88dk-zobjcopy test.lib --verbose -s text=text --section data=data test2.lib", <<"...");
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

ok run("z88dk-zobjcopy -v test.o -s .=ram test2.o", <<"...");
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

ok run("z88dk-zobjcopy -v test.o -s ^text=rom_text -s ^data=ram_data test2.o", <<"...");
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

ok run("z88dk-zobjcopy -v test.o -s ^data=base test2.o", <<"...");
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

ok run("z88dk-zobjcopy -v test.o -s ^data=base -s ^text=base test2.o", <<"...");
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

ok run("z88dk-zobjcopy test.o --verbose --filler 0x55 -s text=text test2.o", <<"...");
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

ok run("z88dk-zobjcopy test.o --verbose -F 127 -s text=text test2.o", <<"...");
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

ok run("z88dk-zobjcopy test.o --verbose -s .=text --org text,0x8000 --align text,64 test2.o", <<"...");
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

ok run("z88dk-zobjcopy test.o --verbose -s .=text -O text,0x8000 -A text,64 test2.o", <<"...");
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

ok run("z88dk-zobjcopy test.o --verbose --add-prefix .,lib_ test2.o", <<"...");
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

ok run("z88dk-zobjcopy test.o --verbose -p m,lib_ test2.o", <<"...");
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

ok run("z88dk-zobjcopy test.o --verbose --symbol ext1=ff_lib_ext1 -y ext=xxx -y msg1=MSG1 test2.o", <<"...");
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

ok run("z88dk-zobjcopy test.o --verbose --local \"^_\" -L msg test2.o", <<"...");
Reading file 'test.o': object version $OBJ_FILE_VERSION
File 'test.o': make symbols that match '^_' local
Block 'Z80RMF$OBJ_FILE_VERSION'
  skip symbol main
  change scope of symbol _start -> local
  skip symbol msg1
  skip symbol msg2
File 'test.o': make symbols that match 'msg' local
Block 'Z80RMF$OBJ_FILE_VERSION'
  skip symbol main
  change scope of symbol msg1 -> local
  change scope of symbol msg2 -> local
Writing file 'test2.o': object version $OBJ_FILE_VERSION
...
ok check_zobjcopy("test2.o", sprintf("t/bmk_obj_%02d_local1.txt", $OBJ_FILE_VERSION));
unlink "test.o", "test2.o";

#------------------------------------------------------------------------------
# make symbols global
#------------------------------------------------------------------------------
path("test.o")->spew_raw($objfile[$OBJ_FILE_VERSION]);
unlink "test2.o";

ok run("z88dk-zobjcopy test.o --verbose --global start -G s test2.o", <<"...");
Reading file 'test.o': object version $OBJ_FILE_VERSION
File 'test.o': make symbols that match 'start' global
Block 'Z80RMF$OBJ_FILE_VERSION'
  change scope of symbol start1 -> global
  change scope of symbol start2 -> global
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
	defb aa
...
ok run("z88dk-z80asm test.asm");
ok run("z88dk-zobjcopy -l test.o", <<"...");
Object  file test.o at \$0000: Z80RMF$OBJ_FILE_VERSION
  Name: test
  CPU:  z80 
  Section "": 0 bytes
  Section text: 1 bytes
    C \$0000: 00
  Symbols:
    G C \$0002: aa (section "") (file test.asm:2)
  Expressions:
    E U \$0000 \$0000 1: aa (section text) (file test.asm:4)
...

ok run("z88dk-zobjcopy test.o test2.o");
ok run("z88dk-zobjcopy -l test2.o", <<"...");
Object  file test2.o at \$0000: Z80RMF$OBJ_FILE_VERSION
  Name: test
  CPU:  z80 
  Section "": 0 bytes
  Section text: 1 bytes
    C \$0000: 00
  Symbols:
    G C \$0002: aa (section "") (file test.asm:2)
  Expressions:
    E U \$0000 \$0000 1: aa (section text) (file test.asm:4)
...

unlink "test.asm", "test.o", "test2.o" if Test::More->builder->is_passing;

done_testing;

#------------------------------------------------------------------------------
# string table
{
	package ST;
	use Object::Tiny::RW qw( hash list );
	
	sub new {
		my($class) = shift;
		return bless {
			hash => {"" => 0},
			list => [""] }, $class;
	}
	
	sub add {
		my($self, $str) = @_;
		return $self->hash->{$str} if exists $self->hash->{$str};
		my $id = $self->count;
		$self->hash->{$str} = $id;
		push @{$self->list}, $str;
		return $id;
	}
	
	sub lookup {
		my($self, $id) = @_;
		return $self->list->[$id];
	}
	
	sub count {
		my($self) = @_;
		return scalar @{$self->list};
	}
	
	sub store {
		my($self) = @_;
		
		# build list of strings and indexes
		my $strings = "";
		my @index;
		for my $id (0 .. $self->count - 1) {
			push @index, length($strings);
			$strings .= $self->lookup($id) . pack("C", 0);
		}
		my $aligned = (length($strings)+3) & ~3;
		$strings .= pack("C*", (0) x ($aligned - length($strings)));
		
		# write sizes
		my $o = pack("VV", $self->count, length($strings));
		
		# write indexes
		$o .= pack("V*", @index);
		
		# write strings
		$o .= $strings;
		
		return $o;
	}
}	

#------------------------------------------------------------------------------
# return object file binary representation
sub objfile {
	my(%args) = @_;
	
	my $st = ST->new;				# string table
	
	exists($args{ORG}) and die;
	
	my $o = "Z80RMF".sprintf("%02d",($args{VERSION} || $OBJ_FILE_VERSION));
	
	# CPU version
	if ($args{VERSION} >= 18) {
		$o .= pack("V", $args{CPU} // 1);
		$o .= pack("V", $args{IXIY} // 0);
	}

	# global ORG (for old versions)
	my $org = $args{CODE}[0][1] // -1;
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
	my $st_addr		 = length($o); $o .= pack("V", -1) if $args{VERSION} >= 18;

	# store expressions
	if ($args{EXPRS}) {
		store_ptr(\$o, $expr_addr);
		for (@{$args{EXPRS}}) {
			@$_ == 9 or die;
			my($type, $filename, $line_nr, $section, $asmpc, $patch_ptr, $opcode_size, 
			   $target_name, $text) = @$_;
			next if $type eq '=' && $args{VERSION} < 6;
			next if $type eq 'B' && $args{VERSION} < 11;
			next if $type eq 'J' && $args{VERSION} < 12;
			next if $type eq 'u' && $args{VERSION} < 13;
			next if $type eq 's' && $args{VERSION} < 13;
			next if $type eq 'P' && $args{VERSION} < 14;
			next if $type eq 'H' && $args{VERSION} < 15;
			
			my %TYPES = ( 	"J"=>1, "U"=>2, "S"=>3, 
							"W"=>4, "C"=>4, # was C until v17, after is W
							"B"=>5, "L"=>6, "u"=>7, "s"=>8, 
							"P"=>9, "H"=>10, "="=>11 );
			die "invalid type $type" unless exists $TYPES{$type};
			if ($args{VERSION} >= 18) {
				$o .= pack("V", $TYPES{$type});
			}
			else {
				$o .= $type;
			}
			
			if ($args{VERSION} >= 4) {
				if ($args{VERSION} >= 18) {
					$o .= pack("V", $st->add($filename));
				}
				else {
					$o .= pack_lstring($filename);
				}
				$o .= pack("V", $line_nr);
			}
			
			if ($args{VERSION} >= 5) {
				if ($args{VERSION} >= 18) {
					$o .= pack("V", $st->add($section));
				}
				elsif ($args{VERSION} >= 16) {
					$o .= pack_lstring($section);
				}
				else {
					$o .= pack_string($section);
				}
			}
			
			if ($args{VERSION} >= 3) {
				if ($args{VERSION} < 17) {
					$o .= pack("v", $asmpc);
				}
				else {
					$o .= pack("V", $asmpc);
				}
			}
			
			if ($args{VERSION} < 17) {
				$o .= pack("v", $patch_ptr);
			}
			else {
				$o .= pack("V", $patch_ptr);
			}
			
			$o .= pack("V", $opcode_size) if $args{VERSION} >= 17;
			
			if ($args{VERSION} >= 6) {
				if ($args{VERSION} >= 18) {
					$o .= pack("V", $st->add($target_name));
				}
				elsif ($args{VERSION} >= 16) {
					$o .= pack_lstring($target_name);
				}
				else {
					$o .= pack_string($target_name);
				}
			}
			
			if ($args{VERSION} >= 18) {
				$o .= pack("V", $st->add($text));
			}
			elsif ($args{VERSION} >= 4) {
				$o .= pack_lstring($text);
			}
			else {
				$o .= pack_string($text) . pack("C", 0);
			}
		}
		
		if ($args{VERSION} >= 18) {
			$o .= pack("V", 0);
		}
		elsif ($args{VERSION} >= 4) {
			$o .= pack("C", 0)
		}
	}

	# store symbols
	if ($args{SYMBOLS}) {
		store_ptr(\$o, $symbols_addr);
		for (@{$args{SYMBOLS}}) {
			@$_ == 7 or die;
			my($scope, $type, $section, $value, $name, $def_filename, $line_nr) = @$_;
			next if $type eq '=' && $args{VERSION} < 7;

			my %SCOPES = ("L"=>1, "G"=>2);
			die "invalid scope $scope" unless exists $SCOPES{$scope};

			my %TYPES = ("C"=>1, "A"=>2, "="=>3);
			die "invalid scope $type" unless exists $TYPES{$type};

			if ($args{VERSION} >= 18) {
				$o .= pack("V", $SCOPES{$scope});
				$o .= pack("V", $TYPES{$type});
			}
			else {
				$o .= $scope;
				$o .= $type;
			}

			if ($args{VERSION} >= 5) {
				if ($args{VERSION} >= 18) {
					$o .= pack("V", $st->add($section));
				}
				elsif ($args{VERSION} >= 16) {
					$o .= pack_lstring($section);
				}
				else {
					$o .= pack_string($section);
				}
			}
			
			$o .= pack("V", $value);
			
			if ($args{VERSION} >= 18) {
				$o .= pack("V", $st->add($name));
			}
			elsif ($args{VERSION} >= 16) {
				$o .= pack_lstring($name);
			}
			else {
				$o .= pack_string($name);
			}
			
			if ($args{VERSION} >= 9) {
				if ($args{VERSION} >= 18) {
					$o .= pack("V", $st->add($def_filename)) . pack("V", $line_nr);
				}
				elsif ($args{VERSION} >= 16) {
					$o .= pack_lstring($def_filename) . pack("V", $line_nr);
				}
				else {
					$o .= pack_string($def_filename) . pack("V", $line_nr);
				}
			}
		}
		
		if ($args{VERSION} >= 18) {
			$o .= pack("V", 0);
		} 
		elsif ($args{VERSION} >= 5) {
			$o .= pack("C", 0);
		}
	}

	# store externals
	if ($args{EXTERNS}) {
		store_ptr(\$o, $extern_addr);
		for my $name (@{$args{EXTERNS}}) {
			if ($args{VERSION} >= 18) {
				$o .= pack("V", $st->add($name));
			}
			elsif ($args{VERSION} >= 16) {
				$o .= pack_lstring($name);
			}
			else {
				$o .= pack_string($name);
			}
		}
		if ($args{VERSION} >= 18) {
			$o .= pack("V", $st->add(""));		# end marker
		}
	}

	# store name
	store_ptr(\$o, $name_addr);
	if ($args{VERSION} >= 18) {
		$o .= pack("V", $st->add($args{NAME}));
	}
	elsif ($args{VERSION} >= 16) {
		$o .= pack_lstring($args{NAME});
	}
	else {
		$o .= pack_string($args{NAME});
	}

	# store code
	if ( $args{CODE} ) {
		ref($args{CODE}) eq 'ARRAY' or die;
		store_ptr(\$o, $code_addr);
		for (@{$args{CODE}}) {
			@$_ == 4 or die;
			my($section, $org, $align, $code) = @$_;
			
			if ($args{VERSION} >= 5) {
				$o .= pack("V", length($code));
				
				if ($args{VERSION} >= 18) {
					$o .= pack("V", $st->add($section));
				}
				elsif ($args{VERSION} >= 16) {
					$o .= pack_lstring($section);
				}
				else {
					$o .= pack_string($section);
				}
				
				$o .= pack("V", $org)		if $args{VERSION} >= 8;
				$o .= pack("V", $align)		if $args{VERSION} >= 10;
				
				$o .= $code;				

				if ($args{VERSION} >= 18) {		# align to dword size
					my $aligned_size = (length($code) + 3) & ~3;
					my $extra_bytes = $aligned_size - length($code);
					$o .= pack("C*", (0) x $extra_bytes);
				}				
			}
			else {
				$o .= pack("v", length($code) & 0xFFFF) . $code;
				last;					# only one code block
			}
		}
		$o .= pack("V", -1) if $args{VERSION} >= 5;
	}
	
	# store string table
	if ($args{VERSION} >= 18) {
		store_ptr(\$o, $st_addr);
		$o .= $st->store;
	}
	
	return $o;
}

#------------------------------------------------------------------------------
# return library file binary representation
sub libfile {
	my(%args) = @_;

	my $o = "Z80LMF".sprintf("%02d",($args{VERSION} || $OBJ_FILE_VERSION));
	
	# string table pointer
	my $st_addr		 = length($o); $o .= pack("V", -1) if $args{VERSION} >= 18;

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
		store_ptr(\$o, $next_pos);
	}
	
	# store end marker
	$o .= pack("VV", -1, 0);

	# store string table
	if ($args{VERSION} >= 18) {
		my $st = ST->new();
		for (@{$args{PUBLIC}}) {
			$st->add($_);
		}
		
		store_ptr(\$o, $st_addr);
		$o .= $st->store;
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
	local $Test::Builder::Level = $Test::Builder::Level + 1;
	$exp_out //= "";
	$exp_err //= "";
	$exp_exit //= 0;	

	my $ok = Test::More->builder->is_passing;
	
	ok 1, $cmd;
	my($out, $err, $exit, @dummy) = capture {system $cmd};
	for ($exp_out, $exp_err, $out, $err) {
		s/\r\n/\n/g;
	}
	is $out, $exp_out, "$cmd: stdout";
	is $err, $exp_err, "$cmd: stderr";
	is !!$exit, !!$exp_exit, "$cmd: exit";
	
	return $ok && Test::More->builder->is_passing;
}

#------------------------------------------------------------------------------
sub check_zobjcopy_nm {
	my($cmd, $file, $bmk) = @_;
	local $Test::Builder::Level = $Test::Builder::Level + 1;
	
	(my $out = $bmk) =~ s/$/.out/;
	
	is 0, system("$cmd $file > $out"), "$cmd $file > $out";
	my $diff = system("diff -w $out $bmk");
	is 0, $diff, "diff -w $out $bmk";
	unlink $out unless $diff;
	
	if ($diff != 0 && $ENV{DEBUG}) {
		system("'/c/Program Files/WinMerge/WinMergeU.exe' $out $bmk");
	}
	
	die if $ENV{DEBUG} && !Test::More->builder->is_passing;
	
	return Test::More->builder->is_passing;
}

sub check_zobjcopy {
	my($file, $bmk, $options) = @_;
	local $Test::Builder::Level = $Test::Builder::Level + 1;
	$options //= "";
	return check_zobjcopy_nm("z88dk-zobjcopy -l $options", $file, $bmk);

}

sub check_z80nm {
	my($file, $bmk, $options) = @_;
	local $Test::Builder::Level = $Test::Builder::Level + 1;
	$options //= "-a";
	return check_zobjcopy_nm("z88dk-z80nm $options", $file, $bmk);
}
