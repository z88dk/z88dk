#!perl

# Z88DK Z80 Macro Assembler
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2017
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
# Repository: https://github.com/pauloscustodio/z88dk-z80asm
#
# Output test YAML structure

use Modern::Perl;
use YAML;

my $data = 
{
  errors => [
{ Atype => 'ErrInfo', Bfunc => 'info_total_errors', Cargs => 'void', Dmessage => q{"%d errors occurred during assembly" , get_num_errors()} },



{ Atype => 'ErrError', Bfunc => 'error_read_file', Cargs => 'char *filename', Dmessage => q{"cannot read file '%s'" , filename} },

{ Atype => 'ErrError', Bfunc => 'error_write_file', Cargs => 'char *filename', Dmessage => q{"cannot write file '%s'" , filename} },

{ Atype => 'ErrError', Bfunc => 'error_include_recursion', Cargs => 'char *filename', Dmessage => q{"cannot include file '%s' recursively" , filename} },

  ],
};

print Dump($data);
