# zx81bas - create a .p file from a zx81 BASIC and assembly program

Compiles a zx81 BASIC program that has in-line assembly between '#ASM' 
and '#BASIC'. The assembly code is pushed to z80asm for final assembly 
and .p file creation. The .p is a tape image of a zx81 program than can 
be run in emulators, e.g. EightyOne.

## Compilation

First the pragmas #PRAGMA are applied. Then the source file is sent 
to the C preprocessor, to handle macros, file includes and continuation
lines ending with '\\'. Then the BASIC blocks are processed and translated
into assembly DEFB and DEFW instructions. Finally the source composed by 
the inline assembly and the translated BASIC is sent to z80asm for 
assembly and linking.

## Comments

Comments are enclosed in '/*'...'*/', or started by '#', or '//'; 
in the ASM sections by ';'; in the BASIC sections by "'".

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

- #BASIC: following lines are interpreted as BASIC.

- #ASM: following lines are interpreted as assembly.

## Labels

Line numbers in the BASIC code are optional. Any line can have a label
'@' LABEL ':'. Label names are refered as '@' LABEL, e.g. 'GOTO @LABEL'.
Label addresses are refered to as '&' LABEL, e.g. 'RAND USR &LABEL+5'.

Lines without numbers are auto-numbered according to #INCREMENT. The compiler
checks if line numbers get too large (> 0x3FFF) or if a auto-numbered
line number is larger than the next numbered line.

## Assembly

Any block between #ASM and #BASIC is interpreted as assembly code. The code
is compiled at the end of the previous BASIC line REM, or to the end 
of the previous #VARS s$ = "" string variable. If there is no such previous 
line, or the previous line is not REM, a new REM line is introduced.

Assembly code can refer to @LABEL or &LABEL of labels defined in BASIC.

Assembly code can define special '@' LABELs, e.g. '@LABEL:', whose BASIC 
line number and address are exported to the BASIC code as @LABEL and &LABEL. 
Normal labels 'label:' and '.label' are only defined inside the assembly code.

The address of a BASIC variable is available as '&' VAR, e.g. 'RAND USR &z$'.

## BASIC

Multiple statements can be written in one line separated by ':'.

Hexadecimal numbers may be entered as 0xhh.

Long lines can be split with backslash '\\' following on the next line.

### Extended BASIC

- LET is optional.

- IF condition THEN
    true_statements
  ELSE
    false_statements
  ENDIF
  -->
  IF NOT condition THEN GOTO @false
  true_statements
  GOTO @end
  @false:
  false_statements
  @end:

- REPEAT
    statements
	IF condition1 THEN EXIT
    statements
  UNTIL condition2
  -->
  @start:
  statements
  IF condition1 THEN GOTO @end
  statements
  IF NOT condition2 THEN GOTO @start
  @end:
  
- WHILE condition1
    statements
	IF condition2 THEN EXIT
    statements
  WEND
  -->
  @start:
  IF NOT condition1 THEN GOTO @end
  statements
  IF condition2 THEN GOTO @end
  statements
  GOTO @start
  @end:

- EXIT
  -->
  GOTO @end
  
- END
  -->
  GOTO @end_of_basic

- DEF PROCname(A, B)
    LOCAL L
	L = A+B
	IF A=2 THEN EXIT
	PRINT L
	PROCname = L
  ENDPROC
  PROCname(10, 20)
  LET A = 1 + PROCname(30, 40)
  -->
  LET PROCname_A = 10
  LET PROCname_B = 20
  GOSUB @PROC_name
  LET PROCname_A = 30
  LET PROCname_B = 40
  GOSUB @PROC_name
  LET A = 1 + PROCname
  ...
  STOP
  @PROC_name:
  LET PROCname_L = PROCname_A + PROCname_B
  IF A=2 THEN RETURN
  PRINT PROCname_L
  LET PROCname = PROCname_L
  RETURN

- DEF FNname(A,B)=A+B
  PRINT 1,FNname(10,20),2
  -->
  LET FNname_A = 10
  LET FNname_B = 20
  LET FNname = FNname_A + FNname_B
  PRINT 1,FNname,2

- PEEKW(X)
  -->
  PEEK(X)+256\*PEEK(X+1)

- POKEW(ADDR,X)
  -->
  POKE ADDR, X-256\*INT(X/256)
  POKE ADDR+1, INT(X/256)

- DIV(A,B), A \\ B
  -->
  INT(A/B)

- MOD(A,B)
  -->
  A-B\*INT(A/B)

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

These additional sequences are also accepted:

- "^X" : encodes character X in inverted mode.

- "\r", "\n": encoded as newline (0x76).

## References

- https://worldofspectrum.net/ZX81BasicProgramming/index.html

