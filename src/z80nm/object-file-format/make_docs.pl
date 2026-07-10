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

my @scope;
for ( path("../z80asm/obj_symbol_scope.def")->lines ) {
    if (
        /^ \s* X\( \s* (\d+) \s*,\s* \w+ \s*,\s* (0|'.') 
		   \s*,\s* "([^"]*)"/x
        )
    {
        $scope[$1] = [ $2, $3 ];
    }
}

my @type;
for ( path("../z80asm/obj_symbol_type.def")->lines ) {
    if (
        /^ \s* X\( \s* (\d+) \s*,\s* \w+ \s*,\s* (0|'.') 
		   \s*,\s* "([^"]*)"/x
        )
    {
        $type[$1] = [ $2, $3 ];
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
        . '@@ my @scope   = '
        . ( dump(@scope) =~ s/\n/ /gr ) . ";\n"
        . '@@ my @type   = '
        . ( dump(@type) =~ s/\n/ /gr ) . ";\n"
        . $input;
    my $result = pp_text($text);
    path( $dir, "obj_v$vv.txt" )->spew_raw($result);
}

__DATA__
@@
@@ #---------------------------------------------------------------------------
@@ # Documentation
@@ #---------------------------------------------------------------------------
@@
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
|    | dword | * *cpu_id* : CPU id:
@@ for my $cpu (0 .. $#cpus) { 
@@     next unless $cpus[$cpu];
@@     next if $version < 19 && $cpu >= 33;
@@     $OUT .= "|    |       |   ".sprintf("%2d : %s\n", $cpu, $cpus[$cpu]);
@@ }
|    |       |
|    | dword | * *swap_ixiy* : -IXIY option used in the assembly:
|    |       |   0 : no -IXIY option used
|    |       |   1 : -IXIY option used
|    |       |
@@ }
@@ if ($version >= 8) {
@@ } elsif ($version >= 5) {
|    | dword | * ORG Address:
|    |       |   contains the ORG address for the linked machine code
|    |       |   or -1 for no ORG address defined
|    |       |
@@ } else {
|    | word  | * ORG Address:
|    |       |   contains the ORG address for the linked machine code
|    |       |   or *0xFFFF* for no ORG address defined
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
|    |       | List of expressions used in this module:
@@ if ($version >= 18) {
|    | dword | * *range* Range type: 
@@ } else {
|    | char  | * *range* Range type: 
@@ }
@@ for my $id (0 .. $#range) { 
@@     my($old_id, $text) = @{$range[$id]};
@@     next if $version < 4 && $id == 0;
@@     last if $old_id eq "'='" && $version < 7;
@@     last if $old_id eq "'H'" && $version < 15;
@@     $OUT .= "|    |       |   ";
@@     if ($version >= 18) {
@@         $OUT .= sprintf("%2d : %s\n", $id, $text);
@@     } else {
@@         $OUT .= sprintf("%-3s : %s\n", $old_id, $text);
@@     }
@@ }
@@ if ($version >= 18) {
|    | strid | * *file* : Source file name where expression was used
@@ } elsif ($version >= 4 ) {
|    |lstring| * *file* : Source file name where expression was used;
|    |       |   empty string to reuse the previous expression source file
@@ } else { }
@@ if ($version >= 4) {
|    | dword | * *line* : Line number in source file where expression was used
@@ }
@@ if ($version >= 18) {
|    | strid | * *section* : Section name where expression was used
@@ } elsif ($version >= 16) {
|    |lstring| * *section* : Section name where expression was used
@@ } elsif ($version >= 5) {
|    | string| * *section* : Section name where expression was used
@@ } else { }
@@ if ($version >= 17) {
|    | dword | * *ASMPC* : relative module code address of the start of the
|    |       |   assembly instruction to be used as *ASMPC* during
|    |       |   expression evaluation
@@ } elsif ($version >= 3) {
|    | word  | * *ASMPC* : relative module code address of the start of the
|    |       |   assembly instruction to be used as *ASMPC* during
|    |       |   expression evaluation
@@ } else { }
@@ if ($version >= 17) {
|    | dword | * *patchptr* : relative module code patch pointer to store 
|    |       |   the result of evaluating the expression
@@ } else {
|    | word  | * *patchptr* : relative module code patch pointer to store 
|    |       |   the result of evaluating the expression
@@ }
@@ if ($version >= 17) {
|    | dword | * *opcode_size* : size of the instruction using this expression, 
|    |       |   needed to compute relative jumps
@@ }
@@ if ($version >= 18) {
|    | strid | * *target_name* : name of the symbol that receives the result
|    |       |   of evaluating the expression, only used for type 11 
|    |       |   expressions, empty string for the other types
@@ } elsif ($version >= 16) {
|    |lstring| * *target_name* : name of the symbol that receives the result
|    |       |   of evaluating the expression, only used for type '=' 
|    |       |   expressions, empty string for the other types
@@ } elsif ($version >= 6) {
|    | string| * *target_name* : name of the symbol that receives the result
|    |       |   of evaluating the expression, only used for type '=' 
|    |       |   expressions, empty string for the other types
@@ } else { }
@@ if ($version >= 18) {
|    | strid | * *text* : expression text as parsed from the source file
@@ } elsif ($version >= 4) {
|    |lstring| * *text* : expression text as parsed from the source file
@@ } else {
|    | string| * *text* : expression text as parsed from the source file
|    | byte  | * 0 : terminator
@@ }
|... |  ...  |   ...
|    |       |
@@
@@ #---------------------------------------------------------------------------
@@ # Relocations
@@ #---------------------------------------------------------------------------
@@
@@ if ($version >= 19) {
|    |       | **Relocations**
|    |       | List of relocations used in this module:
|    | dword | * *range* Range type: 
@@     for my $id (0 .. $#range) { 
@@         my($old_id, $text) = @{$range[$id]};
@@         $OUT .= "|    |       |   ".
@@                 sprintf("%2d : %s\n", $id, $text);
@@     }
|    | strid | * *file* : Source file name where relocation was used
|    | dword | * *line* : Line number in source file where relocation was used
|    | strid | * *section* : Section name where relocation was used
|    | dword | * *patchptr* : Relative module code patch pointer to store 
|    |       |   the result of evaluating the relocation
|    | string| * *symbol* : Name of the symbol base of the relocation
|    | dword | * *addend* : Value to add the the symbol to obtain the relocation
|... |  ...  |   ...
|    |       |
@@ }
@@
@@ #---------------------------------------------------------------------------
@@ # Defined Symbols
@@ #---------------------------------------------------------------------------
@@
|    |       | **Defined Symbols**
|    |       | List of symbols defined in this module:
@@ if ($version >= 18) {
|    | dword | * *scope* : Scope of the symbol:
@@ } else {
|    | char  | * *scope* : Scope of the symbol:
@@ }
@@ for my $id (0 .. $#scope) { 
@@     my($old_id, $text) = @{$scope[$id]};
@@     next if $version < 4 && $id == 0;
@@     $OUT .= "|    |       |   ";
@@     if ($version >= 18) {
@@         $OUT .= sprintf("%2d : %s\n", $id, $text);
@@     } else {
@@         $OUT .= sprintf("%-3s : %s\n", $old_id, $text);
@@     }
@@ }
@@ if ($version < 3) {
|    |       |   'X' : global library
@@ }
@@ if ($version >= 18) {
|    | dword | * *type* : Type of symbol:
@@ } else {
|    | char  | * *type* : Type of symbol:
@@ }
@@ for my $id (0 .. $#type) { 
@@     my($old_id, $text) = @{$type[$id]};
@@     next if $id == 0;
@@     next if $old_id eq "'='" && $version < 7;
@@     $OUT .= "|    |       |   ";
@@     if ($version >= 18) {
@@         $OUT .= sprintf("%2d : %s\n", $id, $text);
@@     } else {
@@         $OUT .= sprintf("%-3s : %s\n", $old_id, $text);
@@     }
@@ }
@@ if ($version >= 18) {
|    | strid | * *section* : Section name where symbol was defined
@@ } elsif ($version >= 16) {
|    |lstring| * *section* : Section name where symbol was defined
@@ } elsif ($version >= 5) {
|    | string| * *section* : Section name where symbol was defined
@@ } else { }
|    | dword | * *value* : Absolute value for a constant, or the relative 
|    |       |   address to the start of the section for a relocatable address
@@ if ($version >= 18) {
|    | strid | * *name* : Symbol name
@@ } elsif ($version >= 16) {
|    |lstring| * *name* : Symbol name
@@ } else {
|    | string| * *name* : Symbol name
@@ }
@@ if ($version >= 18) {
|    | strid | * *file* : Source file name where symbol was defined
@@ } elsif ($version >= 16) {
|    |lstring| * *file* : Source file name where symbol was defined
@@ } elsif ($version >= 9) {
|    | string| * *file* : Source file name where symbol was defined
@@ } else { }
@@ if ($version >= 9) {
|    | dword | * *line* : Line number in source file where symbol was defined
@@ }
|... |  ...  |   ...
|    |       |
@@
@@ #---------------------------------------------------------------------------
@@ # External Symbols
@@ #---------------------------------------------------------------------------
@@
|    |       | ** External Symbols **
|    |       | List of external symbol names referred by this module:
@@ if ($version >= 18) {
|    | strid | * *name* : external symbol name, empty string to signal last
@@ } elsif ($version >= 16) {
|    |lstring| * *name* : external symbol name, empty string to signal last
@@ } else {
|    | string| * *name* : external symbol name, empty string to signal last
@@ }
|... | ...   | ...
|    |       |
@@
@@ #---------------------------------------------------------------------------
@@ # Module Name
@@ #---------------------------------------------------------------------------
@@
|    |       | ** Module Name **
|    |       | Base name of the object file
@@ if ($version >= 18) {
|    | strid | * *name* : module name
@@ } elsif ($version >= 16) {
|    |lstring| * *name* : module name
@@ } else {
|    | string| * *name* : module name
@@ }
|    |       |
@@
@@ #---------------------------------------------------------------------------
@@ # Sections
@@ #---------------------------------------------------------------------------
@@
@@ if ($version >= 5) {
|    |       | **Sections**
|    |       | Contains the binary code of each section of the module
@@ } else {
|    |       | **Machine Code**
|    |       | Contains the binary code of the module
@@ }
@@ if ($version >= 5) {
|    | dword | * *size* : defines the total code size, -1 to signal the end
@@ } else {
|    | word  | * *size* : defines the total code size, 0 for a 64K size
@@ }
@@ if ($version >= 18) {
|    | strid | * *section* : source file section name
@@ } elsif ($version >= 16) {
|    |lstring| * *section* : source file section name
@@ } elsif ($version >= 5) {
|    | string| * *section* : source file section name
@@ }
@@ if ($version >= 8) {
|    | dword | * *ORG Address* : contains the user defined ORG address for the
|    |       |   start of this section, or:
|    |       |     -1 for no ORG address was defined, or
|    |       |     -2 to split section to a different binary file
|    |       |   If multiple sections are given with an ORG address each, 
|    |       |   the assembler generates one binary file for each section with
|    |       |   a defined ORG, followed by all sections without one
@@ }
@@ if ($version >= 10) {
|    | dword | * *ALIGN* : defines the address alignment of this section, or
|    |       |   -1 if not defined
|    |       |   The previous section is padded to align the start address of
|    |       |   this section
@@ }
|    | bytes | * *code* : contains the binary code
@@ if ($version >= 18) {
|    | bytes | * possible padding to align file on 4-byte boundary
@@ }
@@ if ($version >= 5) {
|... | ...   | ...
@@ }
|    |       |
@@ if ($version >= 18) {
|    |       | **String Table**
|    |       | Contains the array of strings used in the object file
|    | dword | * *count* : number of strings in the table
|    | dword | * *size*  : total size of blob of all the strings rounded up
|    |       |   to the next aligned address
|    |       | Table of indices:
|    | dword | * *index* : index of first character of this string in the
|    |       |   blob of all strings
|... | ...   | ...
|    | chars | * Blob of strings : Characters of each string followed by '\0' 
|    |       |   terminator and padded to align on 4-byte boundary
|    |       |
@@ }


@@
@@ #---------------------------------------------------------------------------
@@ # Library
@@ #---------------------------------------------------------------------------
@@
Library file format
-------------------

The library file format is a sequence of object files with additional
structures.

|Addr|Type   | Object
|----|----   | ------
|    |       | **File header**
|   0|8 chars| 'Z80LMF[@> $vv @]' - file signature and version
|    |       |
@@ if ($version >= 19) {
|    | dword | File pointer to *Symbol Index Table*
|    | dword | File pointer to *String Table*
|    |       |
@@ } elsif ($version >= 18) {
|    | dword | File pointer to *Library Public Symbols*
|    |       |
@@ }
|    |       | **Object Modules**
|    |       | List of object modules in the library:
| hN | dword | * *next* : contains the file pointer of the next object file
|    |       |   in the library *hN*, or
|    |       |   *-1* if this is the last object in the library
|    | dword | * *size* : contains the size of this object file, or
|    |       |   *0* if this object files has been marked "deleted"
|    |       |   and will not be used
|    |       |   An empty library has next=-1 and size=0
| oN | bytes | * Object module binary data (already aligned on 4-byte boundary)
|... | ...   | ...
|    |       |
@@ if ($version >= 19) {
|    |       | **Symbol Index Table**
|    |       | List of all public symbols in the library per cpu/swap_ixiy
|    |       | combination of the target; each symbol has the pointer *oN*
|    |       | of the object file that defines this symbol.
|    | dword | * *CPU Id* : CPU Id, 0 to mark end of list
|    | dword | * *swap_ixiy* : swap_ixiy value
|    | dword | * *sN* : file pointer of the list of symbols, 0 if none
|    | dword | * *count* : number of public symbols, 0 if none
|... | ...   | ...
|    |       |
|    |       | **Public Symbols List**
| sN | strid | Symbol name
|    | dword | * *oN* : file pointer of the Object Module binary data
|... | ...   | ...
|    |       |
@@ }
@@ if ($version >= 19) {
|    |       | **String Table**
@@ } elsif ($version >= 18) {
|    |       | **Public Symbols List**
@@ }
@@ if ($version >= 18) {
|    |       | Contains the array of public symbols defined in any of the 
|    |       | object files in the object library
|    | dword | * *count* : number of strings in the table
|    | dword | * *size* : total size of blob of all the strings rounded up
|    |       |   to the next aligned address
|    |       | Table of indices:
|    | dword | * *index* : index of first character of this string in the
|    |       |   blob of all strings
|... | ...   | ...
|    | chars | * Blob of strings : Characters of each string followed by '\0' 
|    |       |   terminator and padded to align on 4-byte boundary
|    |       |
@@ }


@@
@@ #---------------------------------------------------------------------------
@@ # History
@@ #---------------------------------------------------------------------------
@@
History
-------

@@ if ($version >= 1) {
* *v01* : original z80asm version

@@ }
@@ if ($version >= 2) {
* *v02* : allow expressions to use standard C operators instead of the
  original (legacy) z80asm specific syntax

@@ }
@@ if ($version >= 3) {
* *v03* : include the address of the start of the assembly instruction
  in the object file, so that expressions with ASMPC are correctly computed
  at link time;
  remove type 'X' symbols (global library), no longer used

@@ }
@@ if ($version >= 4) {
* *v04* : include the source file location of expressions in order
  to give meaningful link-time error messages

@@ }
@@ if ($version >= 5) {
* *v05* : include source code sections

@@ }
@@ if ($version >= 6) {
* *v06* : incomplete implementation, fixed in version *v07*

@@ }
@@ if ($version >= 7) {
* *v07* : include *DEFC* symbols that are defined as an expression using
  other symbols and are computed at link time, after all
  addresses are allocated

@@ }
@@ if ($version >= 8) {
* *v08* : include a user defined ORG address per section

@@ }
@@ if ($version >= 9) {
* *v09* : include the file and line number where each symbol was defined

@@ }
@@ if ($version >= 10) {
* *v10* : allow a section alignment to be defined

@@ }
@@ if ($version >= 11) {
* *v11* : allow big-endian 16-bit expressions to be patched;
  these big-endian values are used in the ZXN coper unit

@@ }
@@ if ($version >= 12) {
* *v12* : allow the target expression of relative jumps to be computed
  in the link phase

@@ }
@@ if ($version >= 13) {
* *v13* : add 8-bit signed and unsigned values extended to 16-bits

@@ }
@@ if ($version >= 14) {
* *v14* : add 24-bit pointers

@@ }
@@ if ($version >= 15) {
* *v15* : add byte offset to 0xFF00

@@ }
@@ if ($version >= 16) {
* *v16* : convert all *string* to *lstring* in the object file to allow
  for very large symbol names, needed for C debugging symbols

@@ }
@@ if ($version >= 17) {
* *v17* : add size of opcode so that DJNZ emulation on Intel and 
  ALTD DJNZ on Rabbit compute the right offset

@@ }
@@ if ($version >= 18) {
* *v18* : add CPU and -IXIY option to disallow linking of objects built
  for a different architecture; add a string table to remove
  duplicate strings and speed up linking

@@ }
@@ if ($version >= 19) {
* *v19* : (not yet in production) 
  add symbol index in the library to speed up linking; 
  add Relocations section for simple relocations of symbol + addend 
  to speed up linking; 
@@ }
