#-----------------------------------------------------------------------------
# Test z80asm
# Copyright (c) Paulo Custodio, 2015-2016
# License: http://www.perlfoundation.org/artistic_license_2_0
#-----------------------------------------------------------------------------

use Modern::Perl;
use Test::Cmd;
use Test::More;
use Config;

my $copyright = "Z80 Module Assembler 3.0-alpha, (c) Paulo Custodio 2011-2016";
my @usage = split(/\r?\n/, <<'END');
Usage: z80asm2 [options] { @<modulefile> | <filename> }...

  To assemble 'fred.asm' use 'fred' or 'fred.asm'

  <modulefile> contains list of file names of all modules to be linked,
  one file or another @modulefile per line.

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

# no arguments - copyright
my $ret = $t->run(args => '');
is $t->stdout, join("\n", $copyright, "", $usage[0], "");
is $t->stderr, "";
is $ret >> 8, 0;

# help option
for my $option ("-h", "--help") {
	$ret = $t->run(args => $option);
	is $t->stdout, join("\n", $copyright, "", @usage, "");
	is $t->stderr, "";
	is $ret >> 8, 0;
}

# option error
my $ret = $t->run(args => '--no-such-option');
is $t->stdout, "";
is $t->stderr, "error: Invalid command line argumens, run z80asm2 -h for help\n";
is $ret >> 8, 1;

done_testing;
