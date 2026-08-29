# zx81bas - create a .p file from a zx81 BASIC and assembly program

Compiles a zx81 BASIC program that has in-line assembly between '#ASM' 
and '#ENDASM'. The assembly code is pushed to z80asm for final assembly 
and .p file creation. The .p is a tape image of a zx81 program than can 
be run in emulators, e.g. EightyOne. A symbol file is also created 
to be loaded in EightyOne to help debugging.

## Compilation

First the pragmas #<pragma> are applied. Then the source file is sent 
to the C preprocessor, to handle macros, file includes and continuation
lines ending with '\\'. Then the BASIC blocks are processed and translated
into assembly DEFB and DEFW instructions. Finally the source composed by 
the inline assembly and the translated BASIC is sent to z80asm for 
assembly and linking.

## Comments

Comments are enclosed in '/*'...'*/', or started by '//'; 
in the ASM sections by ';'; in the BASIC sections by "'".
The original T2P also used '#' as comment, but '#' is a valid
BASIC token, so in zx81bas it is not considered a comment.

## Pragmas

A pragma is composed by the '#' immediatelly followed by a pragma keyword.
The following pragma keywords are accepted:

- #AUTOSTART = 0 or 1 (default 0): sets autostart in the .p file if 1.

- #AUTOSTART_LINE = number or @label (default 0): sets the line number 
  to autostart, default is line 0.

- #INCREMENT = number (default 10): sets the line increment for line numbers.

- #REMINVERT = 0 or 1 (default 0): sets inverted mode for REM lines.

- #FAST = 0 or 1 (default 0): sets to FAST mode on start.

- #VERBOSE = 0 or 1 (default 0): sets verbose mode.

- #VARS number = 1: define a number variable.

- #VARS u$ = "123": define a string variable.

- #VARS z$ = "" <newline> #ASM <newline> ... <newline> #ENDASM <newline>: define 
  assembly code inside a BASIC variable.

- #VARS a(2,3) = 11,12,13, 21,22,23: define a number array.

- #VARS s$(2,3,4) = "abcd","efgh","ijkl", "0123","4567","8901": define a 
  string array.

- #DFILE = "line 1","line 2", ..., "line 24": define initial screen.

- #DFILE_COLAPSED = 0 or 1 (default 0): colapses all blanks in the display
  file.

- #SYSVARS = 0,1,2,3,4,...: define initial set of system variable values from
  16393 to 16508. These values are overwritten by the actual system variables
  of the compiled program, like SLOW/FAST mode, the various memory pointers
  e.g. DFILE, VARS, ...

- #ASM: following lines are interpreted as assembly.

- #ENDASM: following lines are interpreted as BASIC.

## Labels

Line numbers in the BASIC code are optional. Any line can have a label
'@' LABEL ':'. Label names are refered as '@' LABEL, e.g. 'GOTO @LABEL'.
Label addresses are refered to as '&' LABEL, e.g. 'RAND USR &LABEL+5'.

Assembly labels can also be defined in ASM 'label:' and used in 
BASIC 'RAND USR &label'.

Lines without numbers are auto-numbered according to #INCREMENT. The compiler
checks if line numbers get too large (> 0x3FFF) or if a auto-numbered
line number is larger than the next numbered line.

## Assembly

Any block between #ASM and #ENDASM is interpreted as assembly code. The code
is compiled at the end of the previous BASIC line REM, or to the end 
of the previous #VARS s$ = "" string variable. If there is no such previous 
line, or the previous line is not REM, a new REM line is introduced.

Assembly code can refer to @LABEL or &LABEL of labels defined in BASIC.

## BASIC

Multiple statements can be written in one line separated by ':'.

Long lines can be split with backslash '\\' following on the next line.

Hexadecimal numbers may be entered as 0xhh, binary numbers as 0b0101.

LET is optional.

IF has ELSE in same line or IF/ELSE/ENDIF in multiple lines.

REPEAT / UNTIL condition and WHILE condition / WEND can be used for loops
without GOTO labels. Inside REPEAT and WHILE loops EXIT can be used to jump 
out of the loop.

END calls GOTO to a line after the end of the program. Different from STOP
in that it cannot be CONTinued.

Procedures with arguments, local variables and return value can be created.
DEF PROCname(A,B) starts the procedure definition, ENDPROC ends it. 
Assignment to PROCname defines the return value to be used in the 
expression where the procedure is called. LOCAL A,B defines local variables.
EXIT returns from the procedure. A procedure is called either as a statement 
PROCname a,b or as an expression LET A=PROCname(a,b). Procedure arguments, 
local variables and return value are defined as variables PROCnameArg that 
are automatically assigned when calling the procedure, and calling and 
returning is a GOSUB/RETURN. Recursion is not possible.

Functions with arguments can be created. A function definition is 
DEF FNname(A,B) = expression. The expression is placed at the point of call
after assigning the local variables FNnameA and FNnameB with the arguments.

PEEKW(X) is a shortcut for PEEK(X)+256\*PEEK(X+1).

POKEW(A,X) is a shortcut for POKE A,X-256\*INT(X/256):POKE A+1,INT(X/256).

DIV(A,B) and A\\B are shortcuts for INT(A/B).

MOD(A,B) is a shortcut for A-B\*INT(A/B).

All BASIC extended features are lowered to standard zx81 BASIC instructions
or assembly routines before compilation.

## Character set

All strings in the code, either in BASIC or in assembly, and the single-quoted
characters in assembly are translated to the zx81 character set. Upper case 
and lower case characters can be used, as the zx81 has only upper case 
characters.

The sequences recognized by t2p.exe (documentation in docs) are accepted:

- Block characters (see t2p documentation): 
  "\  ", "\' ", "\ '", "\''", "\. ", "\: ", "\.'", "\:'", "\##", "\,,", "\~~", 
  "\::", "\.:", "\:.", "\..", "\':", "\ :", "\'.", "\ .", "\@@", "\;;", "\!!" 
  
- Double quote: "\""

- Double double quote: "\"\""

- Hexadecimal code: "\hh"

- "%X" : encodes character X in inverted mode (i.e. +0x80).

These additional sequences are also accepted:

- "\r", "\n", "\v", "\f": encoded as newline (0x76).

- "\t": encoded as space (0x00).

## References

- https://worldofspectrum.net/ZX81BasicProgramming/index.html

