#!perl

#     ZZZZZZZZZZZZZZZZZZZZ    8888888888888       00000000000
#   ZZZZZZZZZZZZZZZZZZZZ    88888888888888888    0000000000000
#                ZZZZZ      888           888  0000         0000
#              ZZZZZ        88888888888888888  0000         0000
#            ZZZZZ            8888888888888    0000         0000       AAAAAA         SSSSSSSSSSS   MMMM       MMMM
#          ZZZZZ            88888888888888888  0000         0000      AAAAAAAA      SSSS            MMMMMM   MMMMMM
#        ZZZZZ              8888         8888  0000         0000     AAAA  AAAA     SSSSSSSSSSS     MMMMMMMMMMMMMMM
#      ZZZZZ                8888         8888  0000         0000    AAAAAAAAAAAA      SSSSSSSSSSS   MMMM MMMMM MMMM
#    ZZZZZZZZZZZZZZZZZZZZZ  88888888888888888    0000000000000     AAAA      AAAA           SSSSS   MMMM       MMMM
#  ZZZZZZZZZZZZZZZZZZZZZ      8888888888888       00000000000     AAAA        AAAA  SSSSSSSSSSS     MMMM       MMMM
#
# Copyright (C) Gunther Strube, InterLogic 1993-99
# Copyright (C) Paulo Custodio, 2011-2015
#
# Output test YAML structure
#
# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/tt/utils/make_yaml.pl,v 1.1 2015-08-03 23:08:13 pauloscustodio Exp $

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
