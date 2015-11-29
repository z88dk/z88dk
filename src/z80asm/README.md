Z88DK Z80 Macro Assembler
=========================

Copyright
---------
Original z80asm module assembler was written by Gunther Strube. 
It was converted from QL SuperBASIC version 0.956, initially ported to Lattice C,
and then to C68 on QDOS.

It has been maintained since 2011 by Paulo Custodio.

Copyright (C) Gunther Strube, InterLogic 1993-99  
Copyright (C) Paulo Custodio, 2011-2015

Repository
----------
Repository: <z88dk.cvs.sourceforge.net:/cvsroot/z88dk>

License
-------
Artistic License 2.0 <http://www.perlfoundation.org/artistic_license_2_0>

TODO List
---------
- Implement recursive includes in Coco/R parser/scanner
- Separate standard Z80 assembly from extensions; add macro files for extensions.
- Port to C++
- Parse command line
- Input source
- Preprocess
- Lexing
- Parsing
- Symbol Table
- Object Files
- Assembling 
- Linking
- List file
- replace DEFL by DEFDW, to allow DEFL for variable labels
- allow EQU as synonym to DEFC
- finish the split between front-end and back-end;
- implement an expression parser with a parser generator, to get rid of
  the need to write a '#' to tell the assembler something it should know:
  a difference between two addresses is a constant;
- add an additional step to automatically change JR into JP if the
  distance is too far;
- cleanup the symbol table to implement the GLOBAL suggestion: declare a
  symbol GLOBAL and it is PUBLIC if defined, or EXTERN otherwise
- implement macros inside the assembler
- add high level constructs (IF flag / ELSE / ENDIF, 
  DO WHILE flag, ...)
- add a rule based optimizer based on RAGEL as a state machine generator
- BUG_0038: library modules not loaded in sequence  
  The library modules loaded to the linked binary file should respect
  the order given on the command line.  
```
    "z80asm -ilib1 -ilib2 obj1.o obj2.o"
```
  should load obj1, obj2, objects from lib1, objects from lib2 in this
  order.  
  The load order is today: obj1, obj2, and then all library modules
  required by obj1, and then library modules required by obj2,
  independently of the -i sequence.  
  This poses problems when trying to keep all data at the end of the
  binary code by defining a library with all the data and linking it
  last in the command line - the -i sequence is not respected and the
  data appears in the middle of other library modules.

Differences to z88dk-z80asm
---------------------------
- Errors are only output on stderr, *.err files are not created.
  *.err files are a leftover from operating systems that could not
  redirect standard error.

  Fatal errors example:  
```
  x.cc:1:18: fatal error: nofile: No such file or directory  
    \#include "nofile"  
    ------------------^  
  compilation terminated.
```

  Non-fatal errors example:  
```
  x.cc:1:7: error: expected initializer before 'b'  
    int a b  
    -------^ 
