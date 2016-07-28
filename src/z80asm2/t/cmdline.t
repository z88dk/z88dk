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
eq_or_diff_text scalar($t->stdout), <<END;
$copyright

$usage
END
eq_or_diff_text scalar($t->stderr), "";
is $ret >> 8, 0;

# help option
for my $option ("-h", "--help") {
	$ret = $t->run(args => $option);
	eq_or_diff_text scalar($t->stdout), <<END;
$copyright

$usage

$help
END
	eq_or_diff_text scalar($t->stderr), "";
	is $ret >> 8, 0;
}

# option error
$ret = $t->run(args => '--no-such-option');
eq_or_diff_text scalar($t->stdout), "";
eq_or_diff_text scalar($t->stderr), <<END;
error: invalid option '--no-such-option', run z80asm2 -h for help
END
is $ret >> 8, 1;

# recursive lists with missing files
unlink 'test_1';
$ret = $t->run(args => '@test_1');
eq_or_diff_text scalar($t->stdout), "";
eq_or_diff_text scalar($t->stderr), <<END;
error: cannot read file 'test_1'
END
is $ret >> 8, 1;
unlink 'test_1';

unlink 'test_1', 'test_2', 'test_3';
path('test_1')->spew("\n".'@test_2');
path('test_2')->spew('@test_3');
$ret = $t->run(args => '@test_1');
eq_or_diff_text scalar($t->stdout), "";
eq_or_diff_text scalar($t->stderr), <<END;
error: cannot read file 'test_3'
"test_2" (1,1) : context: while reading file 'test_2'
\@test_3
 ^
"test_1" (2,1) : context: while reading file 'test_1'
\@test_2
 ^
END
is $ret >> 8, 1;
unlink 'test_1', 'test_2', 'test_3';

# verbose flag
path('test_1.asm')->spew("");
path('test_2.asm')->spew("");

$ret = $t->run(args => 'test_1 test_2');
eq_or_diff_text scalar($t->stdout), "";
eq_or_diff_text scalar($t->stderr), "";
is $ret >> 8, 0;

for my $option ("-v", "--verbose") {
	$ret = $t->run(args => "$option test_1 test_2");
	eq_or_diff_text scalar($t->stdout), <<END;
$copyright
parsing file 'test_1.asm'
parsing file 'test_2.asm'
END
	eq_or_diff_text scalar($t->stderr), "";
	is $ret >> 8, 0;
}
unlink 'test_1.asm', 'test_2.asm';

# assemble some source code
path('test.asm')->spew("nop ; test\n");
$ret = $t->run(args => '-v test');
eq_or_diff_text scalar($t->stdout), <<END;
$copyright
parsing file 'test.asm'
END
eq_or_diff_text scalar($t->stderr), "";
is $ret >> 8, 0;
#unlink 'test.asm';

done_testing;
