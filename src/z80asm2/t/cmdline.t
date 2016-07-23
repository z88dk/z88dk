#-----------------------------------------------------------------------------
# Test z80asm2
# Copyright (c) Paulo Custodio, 2015-2016
# License: http://www.perlfoundation.org/artistic_license_2_0
#-----------------------------------------------------------------------------

use strict;
use warnings;
use Config;
use Path::Tiny;
use Test::Cmd;
use Test::More;
use Test::Differences; 

my $copyright = 'Z80 Module Assembler 3.0-alpha, (c) Paulo Custodio 2011-2016';
my $usage = 'Usage: z80asm2 [options] { @<modulefile> | <filename> }...';
my $help = join("\n", split(/\r?\n/, <<'END'));
Using z80asm2:

  To assemble 'fred.asm' use 'fred' or 'fred.asm'

  <modulefile> contains list of file names of all modules to be linked,
  one file per line. 
  Empty lines or lines starting with ';' or '#' are ignored.
  Lines starting with '@' are expanded recursively.

  File types recognized or created by z80asm:
    .asm = source file (default), or alternative -e<ext>
    .obj = object file (default), or alternative -M<ext>
    .lis = list file
    .bin = Z80 binary file
    .sym = symbols file
    .map = map file
    .reloc = reloc file
    .def = global address definition file
    .err = error file

Help Options:
  -h, --help             Show help options
  -v, --verbose          Be verbose

Input / Output File Options:
  -e, --asm-ext=EXT      Assembly file extension excluding '.'
  -M, --obj-ext=EXT      Object file extension excluding '.'
  -o, --output=FILE      Output binary file

Code Generation Options:
  --RCMX000              Assemble for RCM2000/RCM3000 series of Z80-like CPU
  --ti83plus             Interpret 'Invoke' as RST 28h
  --IXIY                 Swap IX and IY registers
  -C, --line-mode        Enable LINE directive

Environment:
  -I, --inc-path=PATH    Add directory to include search path
  -L, --lib-path=PATH    Add directory to library search path
  -D, --define=SYMBOL    Define a static symbol

Libraries:
  -x, --make-lib=FILE    Create a library file.lib
  -i, --use-lib=FILE     Link library file.lib

Binary Output:
  -b, --make-bin         Assemble and link/relocate to file.bin
  --split-bin            Create one binary file per section
  -d, --date-stamp       Assemble only updated files
  -r, --origin=ADDR      Relocate binary file to given address (decimal or hex)
  -R, --relocatable      Create relocatable code
  --reloc-info           Geneate binary file relocation information

Output File Options:
  -s, --symtable         Create symbol table file.sym
  -l, --list             Create listing file.lis
  -m, --map              Create address map file.map
  -g, --globaldef        Create global definition file.def
END

my $t = Test::Cmd->new(prog => "z80asm2$Config{_exe}", workdir => '');
my $ret;

# no arguments - copyright
$ret = $t->run(args => '');
eq_or_diff_text scalar($t->stdout), join("\n", $copyright, "", $usage, "");
eq_or_diff_text scalar($t->stderr), "";
is $ret >> 8, 0;

# help option
for my $option ("-h", "--help") {
	$ret = $t->run(args => $option);
	eq_or_diff_text scalar($t->stdout), join("\n", $copyright, "", $usage, "", $help, "");
	eq_or_diff_text scalar($t->stderr), "";
	is $ret >> 8, 0;
}

# option error
$ret = $t->run(args => '--no-such-option');
eq_or_diff_text scalar($t->stdout), "";
eq_or_diff_text scalar($t->stderr), "error: invalid option '--no-such-option', run z80asm2 -h for help\n";
is $ret >> 8, 1;

# recursive lists with missing files
unlink 'test.1';
$ret = $t->run(args => '@test.1');
eq_or_diff_text scalar($t->stdout), "";
eq_or_diff_text scalar($t->stderr), "error: cannot read file 'test.1'\n";
is $ret >> 8, 1;
unlink 'test.1';

unlink 'test.1', 'test.2', 'test.3';
path('test.1')->spew("\n".'@test.2');
path('test.2')->spew('@test.3');
$ret = $t->run(args => '@test.1');
eq_or_diff_text scalar($t->stdout), "";
eq_or_diff_text scalar($t->stderr), 
			"error: cannot read file 'test.3'\n".
			"\"test.2\" (1,1) : context: while reading file 'test.2'\n".
			"\@test.3\n".
			" ^\n".
			"\"test.1\" (2,1) : context: while reading file 'test.1'\n".
			"\@test.2\n".
			" ^\n";
is $ret >> 8, 1;
unlink 'test.1', 'test.2', 'test.3';

# verbose flag
path('test.1.asm')->spew("");
path('test.2.asm')->spew("");

$ret = $t->run(args => 'test.1 test.2');
eq_or_diff_text scalar($t->stdout), "";
eq_or_diff_text scalar($t->stderr), "";
is $ret >> 8, 0;

for my $option ("-v", "--verbose") {
	$ret = $t->run(args => "$option test.1 test.2");
	eq_or_diff_text scalar($t->stdout), join("\n", $copyright, 
											"parsing file 'test.1'",
											"parsing file 'test.2'", 
											"");
	eq_or_diff_text scalar($t->stderr), "";
	is $ret >> 8, 0;
}
unlink 'test.1.asm', 'test.2.asm';

done_testing;
