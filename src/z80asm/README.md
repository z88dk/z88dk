Z88DK Z80 Macro Assembler
=========================

Copyright
---------
Original z80asm module assembler was written by Gunther Strube. 
It was converted from QL SuperBASIC version 0.956, initially ported to Lattice C,
and then to C68 on QDOS.

It has been maintained since 2011 by Paulo Custodio.

Copyright (C) Gunther Strube, InterLogic 1993-99  
Copyright (C) Paulo Custodio, 2011-2024

Repository
----------
Repository: <https://github.com/z88dk/z88dk.git>

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
- allow EQU as synonym to DEFC
- finish the split between front-end and back-end;
- implement an expression parser with a parser generator, to get rid of
  the need to write a '#' to tell the assembler something it should know:
  a difference between two addresses is a constant;
- add an additional step to automatically change JR into JP if the
  distance is too far;
- implement macros inside the assembler
- add high level constructs (IF flag / ELSE / ENDIF, 
  DO WHILE flag, ...)
- add a rule based optimizer based on RAGEL as a state machine generator
