#!/usr/bin/env perl

#------------------------------------------------------------------------------
# Z80 assembler
# Copyright (C) Paulo Custodio, 2011-2026
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

use Modern::Perl;
use lib '.';
use ObjModule;
use Preproc::Tiny;
use Path::Tiny;
use Data::Dump 'dump';

my $input = join( "", <DATA> );
my $dir   = path($0)->parent;

my @cpus;
for ( path("../z80asm/cpu.def")->lines ) {
    if (/^ \s* X\( \s* (\d+) \s*,\s* \w+ \s*,\s* "(\w+)" /x) {
        $cpus[$1] = $2;
    }
}

my @range;
for ( path("../z80asm/obj_range_type.def")->lines ) {
    if (
        /^ \s* X\( \s* (\d+) \s*,\s* \w+ \s*,\s* (0|'.') 
		   \s*,\s* "[^"]*" \s*,\s* -?\d+ \s*,\s* "([^"]+)"/x
        )
    {
        $range[$1] = [ $2, $3 ];
    }
}

for my $version ( Obj::min_version .. Obj::cur_version ) {
    my $vv = sprintf "%02d", $version;

    # build templating code
    my $text =
          '@@ my $version = '
        . $version . ";\n"
        . '@@ my $vv      = "'
        . $vv . '";' . "\n"
        . '@@ my @cpus    = '
        . ( dump(@cpus) =~ s/\n/ /gr ) . ";\n"
        . '@@ my @range   = '
        . ( dump(@range) =~ s/\n/ /gr ) . ";\n"
        . $input;
    my $result = pp_text($text);
    path( $dir, "obj_v$vv.txt" )->spew_raw($result);
}

__DATA__
z80asm File formats (v[@> $vv @])
=========================

This document describes the object and library formats used by *z80asm*.

@@ if ($version >= 18) {
*NOTE:* v18 is the version used in production; v19 is the version
for the new z80asm in development.

@@ }
The object and library files are stored in binary form as a set of 
contiguous sections, i.e. each section follows the previous one. 

The files start with a signature that includes a version number and is 
verified by the assembler before trying to parse the file.

A set of file pointers at the start of the object file point to the 
start of each section existing the in the file, or contain *0xFFFFFFFF* 
(-1) if that section does not exist.


Data types
----------

The following object types exist in the file:

* *char* : one signed 8-bit value containing an ASCII character;

* *byte* : one unsigned 8-bit value;

@@ if ($version < 18) {
* *word* : one 16-bit value, stored in low byte - high byte order;

@@ }
* *dword* :	one signed 32-bit value, stored in low byte - high byte order;

@@ if ($version < 16) {
* *string* : one byte containing the string length followed by the 
             characters of the string.

@@ }
@@ if ($version >= 4 && $version < 18) {
* *lstring* : one word containing the string length followed by the
              characters of the string.

@@ }
@@ if ($version >= 18) {
* *strid* : one signed 32-bit value indicating the string index in the 
            string table; index 0 always points to an empty string;

@@ }

Object file format
------------------

The format of the object file is as follows:

@@
@@ #---------------------------------------------------------------------------
@@ # Header
@@ #---------------------------------------------------------------------------
@@
|Addr|Type   | Object
|----|----   | ------
|    |       | **File header**
|   0|8 chars| 'Z80RMF[@> $vv @]' - file signature and version
|    |       |
@@ if ($version >= 18) {
|    | dword | *cpu_id* : CPU id:
@@ for my $cpu (0 .. $#cpus) { 
@@     next unless $cpus[$cpu];
@@     next if $version < 19 && $cpu >= 33;
@@     $OUT .= "|    |       |     ".sprintf("%2d : %s\n", $cpu, $cpus[$cpu]);
@@ }
|    |       |
|    | dword | *swap_ixiy* : -IXIY option used in the assembly:
|    |       |     0 : no -IXIY option used
|    |       |     1 : -IXIY option used
|    |       |
@@ }
@@ if ($version >= 8) {
@@ } elsif ($version >= 5) {
|    | dword | ORG Address:
|    |       | contains the ORG address for the linked machine code
|    |       | or -1 for no ORG address defined
|    |       |
@@ } else {
|    | word  | ORG Address:
|    |       | contains the ORG address for the linked machine code
|    |       | or *0xFFFF* for no ORG address defined
|    |       |
@@ }
|    | dword | File pointer to *Module Name*
|    | dword | File pointer to *Expressions*, may be -1
@@ if ($version >= 19) {
|    | dword | File pointer to *Relocations*, may be -1
@@ }
|    | dword | File pointer to *Defined Symbols*, may be -1
|    | dword | File pointer to *External Symbols*, may be -1
@@ if ($version >= 5) {
|    | dword | File pointer to *Sections*, may be -1
@@ } else {
|    | dword | File pointer to *Machine Code*, may be -1
@@ }
@@ if ($version >= 18) {
|    | dword | File pointer to *String Table*
@@ }
|    |       |
@@
@@ #---------------------------------------------------------------------------
@@ # Expressions
@@ #---------------------------------------------------------------------------
@@
|    |       | **Expressions**
|    |       | List of expressions defined in this module:
@@ if ($version >= 18) {
|    | dword | *range* Range type: 
@@ } else {
|    | char  | *range* Range type: 
@@ }
@@ for my $id (0 .. $#range) { 
@@     my($old_id, $text) = @{$range[$id]};
@@     next if $version < 4 && $id == 0;
@@     $OUT .= "|    |       |     ";
@@     if ($version >= 18) {
@@         $OUT .= sprintf("%2d : %s\n", $id, $text);
@@     } else {
@@         $OUT .= sprintf("%-3s : %s\n", $old_id, $text);
@@     }
@@ }
@@ if ($version >= 18) {
|    | strid | *file* : Source file name where expression was used
@@ } elsif ($version >= 4 ) {
|    |lstring| *file* : Source file name where expression was used
|    |       |         empty string to reuse the previous expression source file
@@ } else { }
@@ if ($version >= 4) {
|    | dword | *line* : Line number in source file where expression was used
@@ }
@@ if ($version >= 18) {
|    | strid | *section* : Section name where expression was used
@@ } elsif ($version >= 16) {
|    |lstring| *section* : Section name where expression was used
@@ } elsif ($version >= 5) {
|    | string| *section* : Section name where expression was used
@@ } else { }
@@ if ($version >= 17) {
|    | dword | *ASMPC* : relative module code address of the start of the
|    |       |         assembly instruction to be used as *ASMPC* during
|    |       |         expression evaluation
@@ } elsif ($version >= 3) {
|    | word  | *ASMPC* : relative module code address of the start of the
|    |       |         assembly instruction to be used as *ASMPC* during
|    |       |         expression evaluation
@@ } else { }
@@ if ($version >= 17) {
|    | dword | *patchptr* : relative module code patch pointer to store 
|    |       |         the result of evaluating the expression
@@ } else {
|    | word  | *patchptr* : relative module code patch pointer to store 
|    |       |         the result of evaluating the expression
@@ }
@@ if ($version >= 17) {
|    | dword | *opcode_size* : size of the instruction using this expression, 
|    |       |         needed to compute relative jumps
@@ }
@@ if ($version >= 18) {
|    | strid | *target_name* : name of the symbol that receives the result
|    |       |         of evaluating the expression, only used for type 11 
|    |       |         expressions, empty string for the other types
@@ } elsif ($version >= 16) {
|    |lstring| *target_name* : name of the symbol that receives the result
|    |       |         of evaluating the expression, only used for type '=' 
|    |       |         expressions, empty string for the other types
@@ } elsif ($version >= 6) {
|    | string| *target_name* : name of the symbol that receives the result
|    |       |         of evaluating the expression, only used for type '=' 
|    |       |         expressions, empty string for the other types
@@ } else { }
@@ if ($version >= 18) {
|    | strid | *text* : expression text as parsed from the source file
@@ } elsif ($version >= 4) {
|    |lstring| *text* : expression text as parsed from the source file
@@ } else {
|    | string| *text* : expression text as parsed from the source file
|    | byte  | *0* : terminator
@@ }
|    |       |
