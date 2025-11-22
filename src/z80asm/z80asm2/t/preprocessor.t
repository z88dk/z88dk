#------------------------------------------------------------------------------
# Z80 assembler
# Copyright (C) Paulo Custodio, 2011-2025
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

#------------------------------------------------------------------------------
# Test various include formats and line continuations
#------------------------------------------------------------------------------
unlink("$test.i");
unlink("$test.o");

spew("$test.inc", <<END);
#undef FOO
#define FOO 42 /*comment*/
LD A,/*


*/FOO
LD B,2//comment
LD C,3;comment
LD D,\\
4
LD H,5 : LD L,6 \\ LD HL,7
END

spew("$test.asm", <<END);
LD BEFORE,1
#include $test.inc
LD BEFORE,2
#include "$test.inc"
LD BEFORE,3
#include <$test.inc>
LD BEFORE,4
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

check_text_file("$test.i", <<END);
#line 1, "$test.asm"
LD BEFORE,1
#line 3, "$test.inc"
LD A, 42



LD B,2
LD C,3
LD D, 4

LD H,5
#line 11
LD L,6
#line 11
LD HL,7
#line 3, "$test.asm"
LD BEFORE,2
#line 3, "$test.inc"
LD A, 42



LD B,2
LD C,3
LD D, 4

LD H,5
#line 11
LD L,6
#line 11
LD HL,7
#line 5, "$test.asm"
LD BEFORE,3
#line 3, "$test.inc"
LD A, 42



LD B,2
LD C,3
LD D, 4

LD H,5
#line 11
LD L,6
#line 11
LD HL,7
#line 7, "$test.asm"
LD BEFORE,4
END

#------------------------------------------------------------------------------
# Test BINARY and INCBIN directives produce DEFB lines with file bytes
#------------------------------------------------------------------------------

# Create binary files
spew("$test.bin32", pack('C*', 0..31));
spew("$test.bin5", pack('C*', 10..14));

# Assembly using BINARY (32 bytes => 2 lines of 16)
# and INCBIN (5 bytes => 1 line)
spew("$test.asm", <<END);
BINARY $test.bin32
INCBIN $test.bin5
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

# Expect three DEFB lines with the raw decimal byte values
check_text_file("$test.i", <<END);
#line 1, "$test.asm"
DEFB 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
#line 1
DEFB 16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
DEFB 10,11,12,13,14
END

# Extend BINARY/INCBIN tests to cover:
#  - quoted / angle / plain filename forms
#  - empty file (no DEFB lines)
#  - partial (non-multiple-of-16) last line
#  - location consistency (#line only once unless logical location changes)
#  - multiple directives in one file

# Create additional binary test files
spew("$test.empty", "");                            # empty
spew("$test.partial", pack('C*', 0..19));           # 20 bytes (16 + 4)
spew("$test.small", pack('C*', 200,201,202));       # small distinct
spew("$test.more", pack('C*', 250,251));            # small distinct

# Test all filename forms for BINARY / INCBIN plus empty and partial
spew("$test.asm", <<END);
LINE 100, "logic.bin"
BINARY "$test.bin32"
BINARY <$test.bin5>
BINARY $test.partial
BINARY $test.empty
INCBIN "$test.small"
INCBIN <$test.more>
INCBIN $test.empty
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

# Build expected output:
# Each directive expands to DEFB lines at logical line 100 ("logic.bin") except empty files (no lines).
# 32 bytes -> 2 lines, 5 bytes -> 1 line, 20 bytes -> 2 lines (16 + 4), 0 bytes -> none
# small(3) -> 1 line, more(2) -> 1 line, empty -> none
check_text_file("$test.i", <<END);
#line 100, "logic.bin"
DEFB 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
#line 100
DEFB 16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
DEFB 10,11,12,13,14
DEFB 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
#line 102
DEFB 16,17,18,19

DEFB 200,201,202
DEFB 250,251
END

#------------------------------------------------------------------------------
# Tests for LINE and C_LINE directives
#------------------------------------------------------------------------------

# LINE: sets logical line/file and increments for each following physical line
spew("$test.asm", <<END);
LINE 100, "logic_line.asm"
AAA
BBB
LINE 200, <logic_angle.asm>
CCC
LINE 300, logic_plain.asm
DDD
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

check_text_file("$test.i", <<END);
#line 100, "logic_line.asm"
AAA
BBB
#line 200, "logic_angle.asm"
CCC
#line 300, "logic_plain.asm"
DDD
END

# C_LINE: sets constant logical line (no increment) and optional filename
spew("$test.asm", <<END);
C_LINE 400, "logic_cline.asm"
AAA
BBB
C_LINE 500, <logic_cangle.asm>
CCC
C_LINE 600, logic_cplain.asm
DDD
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

check_text_file("$test.i", <<END);
#line 400, "logic_cline.asm"
AAA
#line 400
BBB
#line 500, "logic_cangle.asm"
CCC
#line 600, "logic_cplain.asm"
DDD
END

# Mixed LINE then C_LINE to ensure switching modes behaves correctly
spew("$test.asm", <<END);
LINE 700, "mix_line.asm"
X1
X2
C_LINE 800, "mix_cline.asm"
Y1
Y2
LINE 900, mix_after.asm
Z1
Z2
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

check_text_file("$test.i", <<END);
#line 700, "mix_line.asm"
X1
X2
#line 800, "mix_cline.asm"
Y1
#line 800
Y2
#line 900, "mix_after.asm"
Z1
Z2
END

#------------------------------------------------------------------------------
# Tests for object-like and function-like DEFINE (including cascading resolution)
#------------------------------------------------------------------------------

# Object-like, name-directive, empty bodies, function-like argument expansion, cascade chains.
spew("$test.asm", <<END);
#define X 5
X
Y DEFINE 6
Y
#define EMPTY
EMPTY
E DEFINE
E
#define A 10
#define F(x) x
F(A)
#define TWO 2
#define ADD(a,b) a + b
ADD(1,TWO)
UNDEF A
A DEFINE B
B DEFINE C
C DEFINE 123
A
#define G 7
#define H() G
H()
#define I() J
#define J() K
#define K 99
I()
#define Z()
Z()
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

# Expected: only macro use lines (definitions removed). Empty bodies -> 1.
# Cascade A->B->C->123, H()->7, I()->99, Z() empty -> 1.
check_text_file("$test.i", <<END);
#line 2, "$test.asm"
5

6

1

1


10


1 + 2




123


7



99

1
END

# Optional '=' before body (both name and prefix forms) and empty body cases.
spew("$test.asm", <<END);
A DEFINE = 5
A
DEFINE B = 6
B
C DEFINE =
C
DEFINE D =
D
#define F(x)
F(2)
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

check_text_file("$test.i", <<END);
#line 2, "$test.asm"
5

6

1

1

1
END

# Function-like cascading: object -> function -> object sequence and arguments expansion.
spew("$test.asm", <<END);
#define ID(x) x
#define WRAP(y) ID(y)
#define VAL 42
WRAP(VAL)
#define OUTER(a,b) a + b
#define ONE 1
#define TWO 2
OUTER(ONE,TWO)
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

check_text_file("$test.i", <<END);
#line 4, "$test.asm"
42



1 + 2
END

#------------------------------------------------------------------------------
# Tests for EQU, '=' synonym, and DEFC directives (object-like forms, cascading, macro expansion)
#------------------------------------------------------------------------------

# EQU / '=' / DEFC transformation and macro expansion
spew("$test.asm", <<END);
X EQU 5
EQU Y = 7
W EQU = 3
#define A 10
SUM EQU A + 2
a = 11
b=12
DEFC U = 13
V DEFC 14
LINE 200, "logic_equ.asm"
Z EQU 9
Q = 8
DEFC R = 21
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

check_text_file("$test.i", <<END);
#line 1, "$test.asm"
DEFC X = 5
DEFC Y = 7
DEFC W = 3

DEFC SUM = 10 + 2
DEFC a = 11
DEFC b = 12
DEFC U = 13
DEFC V = 14
#line 200, "logic_equ.asm"
DEFC Z = 9
DEFC Q = 8
DEFC R = 21
END

# Optional '=' before body (prefix and name forms) and empty body expanding to 1
spew("$test.asm", <<END);
A DEFINE = 5
A
DEFINE B = 6
B
C DEFINE =
C
DEFINE D =
D
EQU E 9
EQU F = 10
G DEFC 11
H = 12
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

check_text_file("$test.i", <<END);
#line 2, "$test.asm"
5

6

1

1
DEFC E = 9
DEFC F = 10
DEFC G = 11
DEFC H = 12
END

# Macro cascade inside EQU / '=' RHS
spew("$test.asm", <<END);
#define A 1
#define B A + 2
#define C B + 3
VAL EQU C + 4
SUM = C + 5
DEFC OUT = C + 6
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

check_text_file("$test.i", <<END);
#line 4, "$test.asm"
DEFC VAL = 1 + 2 + 3 + 4
DEFC SUM = 1 + 2 + 3 + 5
DEFC OUT = 1 + 2 + 3 + 6
END

#------------------------------------------------------------------------------
# Tests for UNDEF / UNDEFINE (both name-directive and hash forms)
#------------------------------------------------------------------------------

# name UNDEF removes object-like macro; subsequent use is literal
spew("$test.asm", <<END);
M DEFINE 42
M UNDEF
M
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

check_text_file("$test.i", <<END);
#line 3, "$test.asm"
M
END

# #undef removes object-like macro; subsequent use is literal
spew("$test.asm", <<END);
#define P 88
#undef P
P
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

check_text_file("$test.i", <<END);
#line 3, "$test.asm"
P
END

# UNDEFINE synonym behaves like UNDEF (name-directive)
spew("$test.asm", <<END);
Q DEFINE 7
Q UNDEFINE
Q
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

check_text_file("$test.i", <<END);
#line 3, "$test.asm"
Q
END

# #UNDEFINE synonym behaves like #undef
spew("$test.asm", <<END);
#define N 99
#UNDEFINE N
N
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

check_text_file("$test.i", <<END);
#line 3, "$test.asm"
N
END

# UNDEF on function-like macro prevents further expansion
spew("$test.asm", <<END);
#define F(x) x
F(1)
UNDEF F
F(2)
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

check_text_file("$test.i", <<END);
#line 2, "$test.asm"
1

F(2)
END

# Redefinition after UNDEF works (new value in effect)
spew("$test.asm", <<END);
R DEFINE 1
R UNDEF
R DEFINE 3
R
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

check_text_file("$test.i", <<END);
#line 4, "$test.asm"
3
END

#------------------------------------------------------------------------------
# Tests for DEFL directive (infix, prefix, previous value, non-constant body, redefinition)
#------------------------------------------------------------------------------

# Infix form: name DEFL expr
spew("$test.asm", <<END);
idx DEFL 7
idx
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

check_text_file("$test.i", <<END);
#line 2, "$test.asm"
7
END

# Prefix form: DEFL name=expr (with and without spaces around '=')
spew("$test.asm", <<END);
DEFL count=9
count
DEFL value = 11
value
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

check_text_file("$test.i", <<END);
#line 2, "$test.asm"
9

11
END

# Previous value usage: self-referential increment
spew("$test.asm", <<END);
index DEFL 0
DEFL index=index+1
DEFL index=index+1
index
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

check_text_file("$test.i", <<END);
#line 4, "$test.asm"
2
END

# Non-constant body stored and expanded later (comma list via macro expansion)
spew("$test.asm", <<END);
#define A 10
#define B 20
#define LIST A, B
DEFL P=LIST
db P
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

# Expect "db 10, 20"
check_text_file("$test.i", <<END);
#line 5, "$test.asm"
db 10, 20
END

# Redefinition allowed (no MacroRedefined error) - last value wins
spew("$test.asm", <<END);
Z DEFL 1
Z DEFL 2
Z
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

check_text_file("$test.i", <<END);
#line 3, "$test.asm"
2
END

#------------------------------------------------------------------------------
# Tests for MACRO / ENDM / LOCAL / EXITM (including conditional EXITM)
#------------------------------------------------------------------------------

# Basic MACRO with parameter expansion
spew("$test.asm", <<END);
MACRO DBX(n)
db n
ENDM
DBX(3)
DBX(4)
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

check_text_file("$test.i", <<END);
#line 4, "$test.asm"
db 3
db 4
END

# LOCAL label inside MACRO must be renamed uniquely per expansion
spew("$test.asm", <<END);
MACRO MAKE_LABEL(v)
LOCAL L
L:
db v
ENDM
MAKE_LABEL(10)
MAKE_LABEL(20)
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

check_text_file("$test.i", <<END);
#line 6, "$test.asm"
.L_1
#line 6
db 10
.L_2
#line 7
db 20
END

# EXITM unconditionally stops macro expansion (subsequent body not emitted)
spew("$test.asm", <<END);
MACRO CUT()
db 1
EXITM
db 2
ENDM
CUT()
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

check_text_file("$test.i", <<END);
#line 6, "$test.asm"
db 1
END

# Conditional EXITM: only exits when condition is non-zero
spew("$test.asm", <<END);
MACRO MAYBE(x)
db x
IF x
EXITM
ENDIF
db 255
ENDM
MAYBE(0)
MAYBE(1)
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

check_text_file("$test.i", <<END);
#line 8, "$test.asm"
db 0
#line 8
db 255
db 1
END

#------------------------------------------------------------------------------
# REPT / REPTC / REPTI
#------------------------------------------------------------------------------

# Simple REPT repetition: REPT 3 should emit 3 copies of the body at directive location
spew("$test.asm", <<END);
REPT 3
X
ENDR
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

check_text_file("$test.i", <<END);
#line 1, "$test.asm"
X
#line 1
X
#line 1
X
END

# REPT with zero count: body consumed but nothing emitted; following line should appear
spew("$test.asm", <<END);
REPT 0
SKIPME
ENDR
AFTER
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

# AFTER should be emitted at its logical location (line 4)
check_text_file("$test.i", <<END);
#line 4, "$test.asm"
AFTER
END

# REPTC iterates over characters of a string argument and substitutes variable
spew("$test.asm", <<END);
REPTC ch, "AZ"
defb ch
ENDR
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

# Expect defb 65 and defb 90 (ASCII 'A' and 'Z')
check_text_file("$test.i", <<END);
#line 1, "$test.asm"
defb 65
#line 1
defb 90
END

# REPTI enumerates a list of arguments into the body
spew("$test.asm", <<END);
REPTI v, 7,8
db v
ENDR
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

# Expect two db lines with values 7 and 8
check_text_file("$test.i", <<END);
#line 1, "$test.asm"
db 7
#line 1
db 8
END

# REPT with LOCAL renaming: local label L should be uniquified per iteration
spew("$test.asm", <<END);
REPT 2
LOCAL L
L: nop
ENDR
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

# Expect two iterations with labels renamed L_1 and L_2 and corresponding nop lines
check_text_file("$test.i", <<END);
#line 1, "$test.asm"
.L_1
#line 1
nop
#line 1
.L_2
#line 1
nop
END

#------------------------------------------------------------------------------
# IF / ELIF / ELSE / ENDIF
#------------------------------------------------------------------------------

# IF true: emit THEN branch, then following lines
spew("$test.asm", <<END);
IF 1
A
ENDIF
X
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

check_text_file("$test.i", <<END);
#line 2, "$test.asm"
A

X
END

# IF false with ELSE: emit ELSE branch
spew("$test.asm", <<END);
IF 0
A
ELSE
B
ENDIF
C
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

check_text_file("$test.i", <<END);
#line 4, "$test.asm"
B

C
END

# IF with multiple ELIF: first true ELIF wins; later branches ignored
spew("$test.asm", <<END);
IF 0
ONE
ELIF 0
TWO_SHOULD_NOT
ELIF 1
THREE
ELSE
FOUR_SHOULD_NOT
ENDIF
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

check_text_file("$test.i", <<END);
#line 6, "$test.asm"
THREE
END

# Nested IF: inner ELSE selected, outer IF true; then following line
spew("$test.asm", <<END);
IF 1
X
IF 0
Y
ELSE
Z
ENDIF
ENDIF
W
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

check_text_file("$test.i", <<END);
#line 2, "$test.asm"
X



Z


W
END

# Single-line colon-separated IF true -> THEN branch
spew("$test.asm", <<END);
IF 1 : OK : ENDIF
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

check_text_file("$test.i", <<END);
#line 1, "$test.asm"
OK
END

# Single-line colon-separated IF false with ELSE -> ELSE branch
spew("$test.asm", <<END);
IF 0 : BAD : ELSE : GOOD : ENDIF
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

check_text_file("$test.i", <<END);
#line 1, "$test.asm"
GOOD
END

# Single-line colon-separated IF with multiple ELIF -> first true ELIF only
spew("$test.asm", <<END);
IF 0 : A : ELIF 1 : B : ELIF 1 : C : ENDIF
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

check_text_file("$test.i", <<END);
#line 1, "$test.asm"
B
END

#------------------------------------------------------------------------------
# IFDEF / IFNDEF / ELIFDEF / ELIFNDEF
#------------------------------------------------------------------------------

# IFDEF true when macro is defined -> THEN branch emitted
spew("$test.asm", <<END);
#define A 1
IFDEF A
T
ELSE
F
ENDIF
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

# 'T' is on physical line 3
check_text_file("$test.i", <<END);
#line 3, "$test.asm"
T
END

# IFDEF false -> ELSE branch emitted
spew("$test.asm", <<END);
IFDEF UNDEF_MAC
T
ELSE
F
ENDIF
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

# 'F' is on physical line 4
check_text_file("$test.i", <<END);
#line 4, "$test.asm"
F
END

# IFNDEF true when macro is NOT defined -> THEN branch emitted
spew("$test.asm", <<END);
IFNDEF X
YES
ELSE
NO
ENDIF
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

# 'YES' is on physical line 2
check_text_file("$test.i", <<END);
#line 2, "$test.asm"
YES
END

# IFNDEF false when macro is defined -> ELSE branch emitted
spew("$test.asm", <<END);
#define B 1
IFNDEF B
YES_SHOULD_NOT
ELSE
NO_OK
ENDIF
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

# 'NO_OK' is on physical line 6
check_text_file("$test.i", <<END);
#line 5, "$test.asm"
NO_OK
END

# ELIFDEF after false IF: selects when macro is defined
spew("$test.asm", <<END);
#define A 1
IF 0
X
ELIFDEF A
Y
ELSE
Z
ENDIF
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

# 'Y' is on physical line 5
check_text_file("$test.i", <<END);
#line 5, "$test.asm"
Y
END

# ELIFDEF not taken when macro is undefined -> ELSE branch
spew("$test.asm", <<END);
IF 0
X
ELIFDEF MISSING
Y_SHOULD_NOT
ELSE
Z_OK
ENDIF
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

# 'Z_OK' is on physical line 6
check_text_file("$test.i", <<END);
#line 6, "$test.asm"
Z_OK
END

# ELIFNDEF after false IF: selects when macro is not defined
spew("$test.asm", <<END);
IF 0
A
ELIFNDEF B
BDEF
ELSE
ELSE_BAD
ENDIF
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

# 'BDEF' is on physical line 4
check_text_file("$test.i", <<END);
#line 4, "$test.asm"
BDEF
END

# ELIFNDEF not taken when macro is defined -> ELSE branch
spew("$test.asm", <<END);
#define FLAG 1
IF 0
THEN_BAD
ELIFNDEF FLAG
ELIFNDEF_BAD
ELSE
ELSE_OK
ENDIF
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

# 'ELSE_OK' is on physical line 8
check_text_file("$test.i", <<END);
#line 7, "$test.asm"
ELSE_OK
END

# Single-line colon-separated IFDEF true -> THEN branch
spew("$test.asm", <<END);
#define C 1
IFDEF C : OK : ELSE : BAD : ENDIF
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

check_text_file("$test.i", <<END);
#line 2, "$test.asm"
OK
END

# Single-line colon-separated IFNDEF true (macro missing) -> THEN branch
spew("$test.asm", <<END);
IFNDEF M : MISSING_OK : ENDIF
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

check_text_file("$test.i", <<END);
#line 1, "$test.asm"
MISSING_OK
END

#------------------------------------------------------------------------------
# PRAGMA ONCE (#pragma once) include skipping
#------------------------------------------------------------------------------

# Create a header with #pragma once and some content
spew("$test.inc", <<END);
#pragma once
ONCE_VALUE
END

# Include it multiple times; only first inclusion should emit its body
spew("$test.asm", <<END);
PRE
#include "$test.inc"
MID
#include "$test.inc"
POST
#include "$test.inc"
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

# Expect ONCE_VALUE only once; subsequent includes skipped (no duplicate emission)
# Logical line mapping: first include switches to $test.inc then returns.
check_text_file("$test.i", <<END);
#line 1, "$test.asm"
PRE
#line 2, "$test.inc"
ONCE_VALUE
#line 3, "$test.asm"
MID

POST
END

# Control test: same content without pragma once should repeat
spew("$test.inc", <<END);
REPEAT_VALUE
END

spew("$test.asm", <<END);
A
#include "$test.inc"
B
#include "$test.inc"
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

check_text_file("$test.i", <<END);
#line 1, "$test.asm"
A
#line 1, "$test.inc"
REPEAT_VALUE
#line 3, "$test.asm"
B
#line 1, "$test.inc"
REPEAT_VALUE
END

#------------------------------------------------------------------------------
# #ifndef / #define include guard detection and skip
#------------------------------------------------------------------------------

# Guarded header: #ifndef NAME / #define NAME pattern
spew("$test.guard", <<END);
#ifndef TEST_GUARD_INC
#define TEST_GUARD_INC
GUARD_CONTENT
#endif
END

# Include guarded header multiple times
spew("$test.asm", <<END);
PRE_G
#include "$test.guard"
MID_G
#include "$test.guard"
POST_G
#include "$test.guard"
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

# Expect GUARD_CONTENT only once (line 3 of header); later includes skipped
check_text_file("$test.i", <<END);
#line 1, "$test.asm"
PRE_G
#line 3, "$test.guard"
GUARD_CONTENT
#line 3, "$test.asm"
MID_G

POST_G
END

# Bad guard (names differ) should NOT skip: included twice
spew("$test.badguard", <<END);
#ifndef BAD_GUARD_A
#define BAD_GUARD_B
BAD_GUARD_CONTENT
#endif
#undef BAD_GUARD_B
END

spew("$test.asm", <<END);
BG1
#include "$test.badguard"
BG2
#include "$test.badguard"
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

# Expect BAD_GUARD_CONTENT twice
check_text_file("$test.i", <<END);
#line 1, "$test.asm"
BG1
#line 3, "$test.badguard"
BAD_GUARD_CONTENT
#line 3, "$test.asm"
BG2
#line 3, "$test.badguard"
BAD_GUARD_CONTENT
END

# Re-include after explicit UNDEF of guard macro should re-emit content
spew("$test.reincl", <<END);
#ifndef REINCL_G
#define REINCL_G
REINCL_CONTENT
#endif
END

spew("$test.asm", <<END);
R1
#include "$test.reincl"
UNDEF REINCL_G
R2
#include "$test.reincl"
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

# Expect content twice: once before UNDEF and once after
check_text_file("$test.i", <<END);
#line 1, "$test.asm"
R1
#line 3, "$test.reincl"
REINCL_CONTENT
#line 4, "$test.asm"
R2
#line 3, "$test.reincl"
REINCL_CONTENT
END

#------------------------------------------------------------------------------
# Recursive include detection (RecursiveInclude)
#------------------------------------------------------------------------------

# Ensure no stale .i survives from previous tests
unlink("$test.i");

# Create two headers that include each other to force recursion
spew("$test.rec1", <<END);
#include "$test.rec2"
END

spew("$test.rec2", <<END);
#include "$test.rec1"
END

# Main file that starts the recursive include chain
spew("$test.asm", <<END);
#include "$test.rec1"
END

# Expect a Recursive include error reported at the line in $test.rec2 that tries to re-include $test.rec1
# No .i file should be produced.

capture_nok("z88dk-z80asm -E $test.asm", <<END);
$test.rec2:1: error: Recursive include: $test.rec1
   |#include "$test.rec1"
END
ok ! -f "$test.i", "output file not produced on error";

#------------------------------------------------------------------------------
# Dependency file generation (-MD)
#------------------------------------------------------------------------------

# Create dependency inputs
spew("$test.depinc1", <<END);
#include "$test.depinc2"
END
spew("$test.depinc2", <<END);
#include "$test.depinc3"
END
spew("$test.depinc3", <<END);
INC
END

spew("$test.depbin1", pack('C*', 1));
spew("$test.depbin2", pack('C*', 2));

# Main references include and binaries, then re-includes to produce a duplicate dep
spew("$test.asm", <<END);
#include "$test.depinc1"
BINARY $test.depbin1
INCBIN $test.depbin2
#include "$test.depinc1"
END

# Expect verbose preprocess message and dependency generation message
capture_ok("z88dk-z80asm -v -E -MD $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
Generating dependency file: $test.d
END

# Dependency file lists:
#   - target object (left side)
#   - deps in recorded order (duplicates preserved):
#       $test.asm, $test.depinc, $test.depbin1, $test.depbin2, $test.depinc
check_text_file("$test.d", <<END);
$test.o: $test.asm $test.depinc1 \\
        $test.depinc2 $test.depinc3 \\
        $test.depbin1 $test.depbin2 \\
        $test.depinc1 $test.depinc2 \\
        $test.depinc3
END

#------------------------------------------------------------------------------
# Do not generate dependency file when errors occur (-MD)
#------------------------------------------------------------------------------

# Ensure no stale .d survives from previous tests
unlink("$test.d");

# Create a source with a preprocessing error (unterminated IF)
spew("$test.asm", <<END);
IF 1
X
END

# Run with -MD and expect failure, and verify $test.d was NOT generated
capture_nok("z88dk-z80asm -E -MD $test.asm", <<END);
$test.asm:1: error: Invalid syntax: Unexpected end of input in IF (expected ENDIF)
END
ok ! -f "$test.d", "dependency file not generated on error";

#------------------------------------------------------------------------------
# Token pasting operator (##) in macros
#------------------------------------------------------------------------------

# Object-like macro with ## in replacement
spew("$test.asm", <<END);
#define AB foo##bar
AB
#define JOIN(x,y) x##y
JOIN(f,oo)
JOIN(foo,1)
#define X foo
#define Y bar
JOIN(X,Y)
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

# Expected expansions:
#  AB            -> foobar
#  JOIN(f,oo)    -> foo
#  JOIN(foo,1)   -> foo1
#  JOIN(X,Y)     -> foobar (after parameter substitution then paste)
check_text_file("$test.i", <<END);
#line 2, "$test.asm"
foobar

foo
foo1


foobar
END

#------------------------------------------------------------------------------
# Token pasting operator (##) outside macros
#------------------------------------------------------------------------------

spew("$test.asm", <<END);
foo##bar
foo ## bar
foo##1
A##B##C
X ## Y ## 2
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

# Expected merges (with blank line spacing to match physical line advancement):
#  foo##bar      -> foobar
#  foo ## bar    -> foobar
#  foo##1        -> foo1
#  A##B##C       -> ABC (chained paste)
#  X ## Y ## 2   -> XY2 (identifier + identifier + integer)
check_text_file("$test.i", <<END);
#line 1, "$test.asm"
foobar
foobar
foo1
ABC
XY2
END

#------------------------------------------------------------------------------
# Stringize operator (#param) in macros
#------------------------------------------------------------------------------

# Basic stringize: turn argument tokens into a string, then db expands to bytes
spew("$test.asm", <<END);
#define STR(x) db #x
STR(Hello)
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

# "Hello" -> 72,101,108,108,111
check_text_file("$test.i", <<END);
#line 2, "$test.asm"
db 72,101,108,108,111
END

# Stringize uses original (unexpanded) argument text
spew("$test.asm", <<END);
#define A X
#define STR(x) db #x
STR(A)
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

# Argument is 'A' (not expanded to X) -> 'A' == 65
check_text_file("$test.i", <<END);
#line 3, "$test.asm"
db 65
END

# Stringize escapes quotes/backslashes: argument is a string literal
spew("$test.asm", <<END);
#define STR(x) db #x
STR("hi")
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

# Expect db 34,"h","i",34 -> 34,104,105,34
check_text_file("$test.i", <<END);
#line 2, "$test.asm"
db 34,104,105,34
END

# Stringize preserves spaces between tokens inside argument
spew("$test.asm", <<END);
#define STR(x) db #x
STR(A B)
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

# Expect "A B" -> 65,32,66
check_text_file("$test.i", <<END);
#line 2, "$test.asm"
db 65,32,66
END

#------------------------------------------------------------------------------
# Macro recursion limit (MacroRecursionLimit)
#------------------------------------------------------------------------------

# Self-recursive macro triggers MacroRecursionLimit and should not produce .i
spew("$test.asm", <<END);
#define R R
R
END

# Expect an error referring to the recursive macro name and the offending line
unlink("$test.i");
capture_nok("z88dk-z80asm -E $test.asm", <<END);
$test.asm:2: error: Macro recursion limit exceeded: R
   |R
END
ok ! -f "$test.i", "output file not produced on error";

# Mutual recursion also triggers MacroRecursionLimit; first macro name reported
spew("$test.asm", <<END);
#define A B
#define B A
A
END

unlink("$test.i");
capture_nok("z88dk-z80asm -E $test.asm", <<END);
$test.asm:3: error: Macro recursion limit exceeded: B
   |B
END
ok ! -f "$test.i", "output file not produced on error";

#------------------------------------------------------------------------------
# Function-like macro calls without parentheses (unparenthesized argument form)
#------------------------------------------------------------------------------
spew("$test.asm", <<END);
#define ID(x) x
ID 7
#define ADD(a,b) a + b
ADD 3,4
#define VAL 9
#define WRAP(x) x
WRAP VAL
#define F(a,b) a + b
F 1
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

# Expected:
#  ID 7          -> 7             (one argument, no parentheses)
#  ADD 3,4       -> 3 + 4         (two arguments, no parentheses)
#  WRAP VAL      -> 9             (argument macro expands inside wrapper)
#  F 1           -> F 1           (wrong arg count without parens: treated as literal)
check_text_file("$test.i", <<END);
#line 2, "$test.asm"
7

3 + 4


9

F 1
END

#------------------------------------------------------------------------------
# String token post-processing (automatic expansion to comma-separated integers)
#------------------------------------------------------------------------------
spew("$test.asm", <<END);
db "A"
db "ABC"
LD A,"Z"
DEFB "Hi"
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

# Expected:
# db "A"   -> db 65
# db "ABC" -> db 65,66,67
# LD A,"Z" -> LD A, 90
# DEFB "Hi"-> DEFB 72,105
check_text_file("$test.i", <<END);
#line 1, "$test.asm"
db 65
db 65,66,67
LD A,90
DEFB 72,105
END

#------------------------------------------------------------------------------
# Negative line numbers in LINE / C_LINE directives
#------------------------------------------------------------------------------
spew("$test.asm", <<END);
LINE -10, "neg_line.asm"
A
B
C_LINE -20, <neg_cangle.asm>
C
C_LINE -30, neg_cplain.asm
D
LINE -5, neg_mix.asm
E
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

# Expectations:
# LINE -10 => first logical line -10 then increments (-9) on next physical line.
# C_LINE -20 => all following physical lines keep -20 until next directive.
# Subsequent C_LINE -30 sets constant -30.
# LINE -5 => sets -5 then (if more lines followed) would increment; only one line emitted.
check_text_file("$test.i", <<END);
#line -10, "neg_line.asm"
A
B
#line -20, "neg_cangle.asm"
C
#line -30, "neg_cplain.asm"
D
#line -5, "neg_mix.asm"
E
END

# Negative line numbers without explicit filename (should default to current file name for first occurrence)
spew("$test.asm", <<END);
LINE -15
X
C_LINE -25
Y
Z
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

# Expectations:
# LINE -15 (no filename) => uses source file name then increments.
# C_LINE -25 keeps constant -25; second physical line after C_LINE prints #line -25 again (no filename).
check_text_file("$test.i", <<END);
#line -15, "$test.asm"
X
#line -25
Y
#line -25
Z
END

#------------------------------------------------------------------------------
# LINE / C_LINE without filename argument (positive line numbers)
#------------------------------------------------------------------------------
spew("$test.asm", <<END);
LINE 10
A
B
C_LINE 5
C
C
LINE 8
D
E
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

# Expectations:
# LINE 10 (no filename) -> logical line set to 10, filename remains $test.asm
# A at 10, B at 11.
# C_LINE 5 (no filename) -> constant line number 5; each emitted line at 5.
# Second C_LINE line shows #line 5 again (line number decreased).
# LINE 8 -> jump forward to 8 (no filename change, so only blank lines inserted for 6 and 7).
# D at 8, E at 9.
check_text_file("$test.i", <<END);
#line 10, "$test.asm"
A
B
#line 5
C
#line 5
C


D
E
END

#------------------------------------------------------------------------------
# REPTC with LOCAL label renaming per character iteration
#------------------------------------------------------------------------------
spew("$test.asm", <<END);
REPTC ch, "AB"
LOCAL L
L: defb ch
ENDR
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

# Expect two iterations:
#  1st: .L_1 then defb 65 ('A')
#  2nd: .L_2 then defb 66 ('B')
check_text_file("$test.i", <<END);
#line 1, "$test.asm"
.L_1
#line 1
defb 65
#line 1
.L_2
#line 1
defb 66
END

#------------------------------------------------------------------------------
# REPTI with LOCAL label renaming per list element iteration
#------------------------------------------------------------------------------
spew("$test.asm", <<END);
REPTI v, 7,8
LOCAL L
L: db v
ENDR
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

# Expect two iterations:
#  1st: .L_1 then db 7
#  2nd: .L_2 then db 8
check_text_file("$test.i", <<END);
#line 1, "$test.asm"
.L_1
#line 1
db 7
#line 1
.L_2
#line 1
db 8
END

#------------------------------------------------------------------------------
# REPTC / REPTI empty iteration sources (no output from loop body)
#------------------------------------------------------------------------------

# REPTC empty string => zero iterations, body skipped, next line appears
spew("$test.asm", <<END);
REPTC ch, ""
defb ch
ENDR
AFTER_C
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

# 4 physical lines; only AFTER_C emitted
check_text_file("$test.i", <<END);
#line 4, "$test.asm"
AFTER_C
END

# REPTC empty string with LOCAL label => still zero iterations, no .L_n labels
spew("$test.asm", <<END);
REPTC ch, ""
LOCAL L
L: defb ch
ENDR
AFTER_C_LOCAL
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

# 5 physical lines; only AFTER_C_LOCAL emitted
check_text_file("$test.i", <<END);
#line 5, "$test.asm"
AFTER_C_LOCAL
END

# REPTI empty list => zero iterations
spew("$test.asm", <<END);
REPTI v,
db v
ENDR
AFTER_I
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

# 4 physical lines; only AFTER_I emitted
check_text_file("$test.i", <<END);
#line 4, "$test.asm"
AFTER_I
END

# REPTI empty list with LOCAL label
spew("$test.asm", <<END);
REPTI v,
LOCAL L
L: db v
ENDR
AFTER_I_LOCAL
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

# 5 physical lines; only AFTER_I_LOCAL emitted
check_text_file("$test.i", <<END);
#line 5, "$test.asm"
AFTER_I_LOCAL
END

#------------------------------------------------------------------------------
# LOCAL duplicate names inside a single MACRO / REPT / REPTC / REPTI body
# Should raise Duplicate definition error and produce no .i output.
#------------------------------------------------------------------------------

# Duplicate LOCAL in MACRO
unlink("$test.i");
spew("$test.asm", <<END);
MACRO DUPM()
LOCAL L
LOCAL L
L: nop
ENDM
DUPM()
END
capture_nok("z88dk-z80asm -E $test.asm", <<END);
$test.asm:3: error: Duplicate definition: L
   |MACRO DUPM()
   |LOCAL L
END
ok ! -f "$test.i", "no .i file produced on duplicate LOCAL inside MACRO";

# Duplicate LOCAL in REPT
unlink("$test.i");
spew("$test.asm", <<END);
REPT 1
LOCAL L
LOCAL L
L: nop
ENDR
END
capture_nok("z88dk-z80asm -E $test.asm", <<END);
$test.asm:3: error: Duplicate definition: L
   |REPT 1
   |LOCAL L
END
ok ! -f "$test.i", "no .i file produced on duplicate LOCAL inside REPT";

# Duplicate LOCAL in REPTC
unlink("$test.i");
spew("$test.asm", <<END);
REPTC ch, "A"
LOCAL L
LOCAL L
L: defb ch
ENDR
END
capture_nok("z88dk-z80asm -E $test.asm", <<END);
$test.asm:3: error: Duplicate definition: L
   |REPTC ch, "A"
   |LOCAL L
END
ok ! -f "$test.i", "no .i file produced on duplicate LOCAL inside REPTC";

# Duplicate LOCAL in REPTI
unlink("$test.i");
spew("$test.asm", <<END);
REPTI v, 1
LOCAL L
LOCAL L
L: db v
ENDR
END
capture_nok("z88dk-z80asm -E $test.asm", <<END);
$test.asm:3: error: Duplicate definition: L
   |REPTI v, 1
   |LOCAL L
END
ok ! -f "$test.i", "no .i file produced on duplicate LOCAL inside REPTI";

#------------------------------------------------------------------------------
# LOCAL label appearing also as a parameter / iteration variable name (rename collision)
# Should raise Duplicate definition error and produce no .i output.
#------------------------------------------------------------------------------

# MACRO parameter name collides with LOCAL label
unlink("$test.i");
spew("$test.asm", <<END);
MACRO M(p)
LOCAL p
p: db p
ENDM
M(1)
END
capture_nok("z88dk-z80asm -E $test.asm", <<END);
$test.asm:2: error: Duplicate definition: p
   |MACRO M(p)
   |LOCAL p
END
ok ! -f "$test.i", "no .i file produced on parameter/local collision in MACRO";

# REPTC iteration variable collides with LOCAL label
unlink("$test.i");
spew("$test.asm", <<END);
REPTC ch, "A"
LOCAL ch
ch: defb ch
ENDR
END
capture_nok("z88dk-z80asm -E $test.asm", <<END);
$test.asm:2: error: Duplicate definition: ch
   |REPTC ch, "A"
   |LOCAL ch
END
ok ! -f "$test.i", "no .i file produced on iteration/local collision in REPTC";

# REPTI iteration variable collides with LOCAL label
unlink("$test.i");
spew("$test.asm", <<END);
REPTI v, 1
LOCAL v
v: db v
ENDR
END
capture_nok("z88dk-z80asm -E $test.asm", <<END);
$test.asm:2: error: Duplicate definition: v
   |REPTI v, 1
   |LOCAL v
END
ok ! -f "$test.i", "no .i file produced on iteration/local collision in REPTI";

#------------------------------------------------------------------------------
# EXITM inside nested macro scenarios
#------------------------------------------------------------------------------

# 1) EXITM in inner macro called from outer macro: only terminates inner macro,
#    outer macro continues after the call.
spew("$test.asm", <<END);
MACRO INNER(a)
db a
EXITM
db 999 ; should not appear
ENDM

MACRO OUTER(x,y)
db x        ; before inner
INNER(y)    ; inner stops after first db
db y+1      ; outer continues
ENDM

OUTER(1,10)
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

# Expect:
#   db 1         (outer pre)
#   db 10        (inner before EXITM)
#   db 11        (outer after inner call)
check_text_file("$test.i", <<END);
#line 13, "$test.asm"
db 1
#line 13
db 10
#line 13
db 10+1
END

# 2) EXITM inside a REPT loop in a macro: terminates the whole macro expansion
#    at first EXITM encounter (remaining REPT iterations and trailing lines skipped).
spew("$test.asm", <<END);
MACRO LOOPCUT(n)
REPT 3
db n
EXITM          ; should stop macro after first iteration
db 777         ; skipped
ENDR
db 888          ; skipped (after REPT)
ENDM
LOOPCUT(5)
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

# Expect only first "db 5" emitted.
check_text_file("$test.i", <<END);
#line 9, "$test.asm"
db 5
END

# 3) EXITM inside inner macro called from within REPT in outer macro:
#    REPT continues after inner macro call (EXITM only affects inner macro).
spew("$test.asm", <<END);
MACRO CUT_ONCE(v)
db v
EXITM
db 123       ; skipped
ENDM
MACRO OUT_REPT(val)
REPT 2
CUT_ONCE(val)
db val+1     ; emitted for each iteration; inner EXITM does not abort outer macro
ENDR
ENDM
OUT_REPT(7)
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

# Expect per iteration:
#   db 7       (from CUT_ONCE before EXITM)
#   db 8       (outer macro after inner call)
# Two iterations total.
check_text_file("$test.i", <<END);
#line 12, "$test.asm"
db 7
#line 12
db 7+1
#line 12
db 7
#line 12
db 7+1
END

#------------------------------------------------------------------------------
# Angle form for BINARY / INCBIN include-path resolution
#------------------------------------------------------------------------------
# Create a subdirectory with binary resources and use angle bracket form
# with only the bare filename; ensure -I search resolves them.
path("$test.binpath")->mkpath;

spew("$test.binpath/abin.bin", pack('C*', 1,2,3));      # 3 bytes -> 1 line
spew("$test.binpath/bbin.bin", pack('C*', 4,5));        # 2 bytes -> 1 line

spew("$test.asm", <<END);
C_LINE 50, "angle_bin.asm"
BINARY <abin.bin>
INCBIN <bbin.bin>
END

capture_ok("z88dk-z80asm -v -E -I$test.binpath $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

# Expect constant logical line number (C_LINE): second emitted logical line
# repeats #line 50 (no filename) because the line number decreased.
check_text_file("$test.i", <<END);
#line 50, "angle_bin.asm"
DEFB 1,2,3
#line 50
DEFB 4,5
END

#------------------------------------------------------------------------------
# Angle vs quoted/plain forms without -I when files are in the same directory
#------------------------------------------------------------------------------
# Place source and binaries together; angle <file> should still resolve.
spew("$test.abin", pack('C*', 7,8));          # single DEFB line
spew("$test.bbin", pack('C*', 9,10,11));      # single DEFB line

spew("$test.asm", <<END);
BINARY <$test.abin>
INCBIN "$test.bbin"
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

# Expected: first directive establishes logical line mapping (#line 1, "$test.asm"),
# second directive continues at next logical line without needing another #line.
check_text_file("$test.i", <<END);
#line 1, "$test.asm"
DEFB 7,8
DEFB 9,10,11
END

# Clean up temporary path
path("$test.binpath")->remove_tree if Test::More->builder->is_passing;

#------------------------------------------------------------------------------
# Plain include path search failures (FileNotFound error case)
#------------------------------------------------------------------------------

# 1) Plain (unquoted) form: #include missing_plain.inc
unlink("$test.i");
spew("$test.asm", <<END);
#include missing_plain.inc
END
capture_nok("z88dk-z80asm -E $test.asm", <<END);
$test.asm:1: error: File not found: missing_plain.inc
   |#include missing_plain.inc
END
ok ! -f "$test.i", "no .i file produced on plain missing include";

# 2) Quoted form: #include "missing_quoted.inc"
unlink("$test.i");
spew("$test.asm", <<END);
#include "missing_quoted.inc"
END
capture_nok("z88dk-z80asm -E $test.asm", <<END);
$test.asm:1: error: File not found: missing_quoted.inc
   |#include "missing_quoted.inc"
END
ok ! -f "$test.i", "no .i file produced on quoted missing include";

# 3) Angle form: #include <missing_angle.inc>
unlink("$test.i");
spew("$test.asm", <<END);
#include <missing_angle.inc>
END
capture_nok("z88dk-z80asm -E $test.asm", <<END);
$test.asm:1: error: File not found: missing_angle.inc
   |#include <missing_angle.inc>
END
ok ! -f "$test.i", "no .i file produced on angle missing include";

# 4) Plain form with -I search path provided but file absent
# Create empty search directory
path("$test.incpath")->mkpath;
unlink("$test.i");
spew("$test.asm", <<END);
#include missing_in_path.inc
END
capture_nok("z88dk-z80asm -E -I$test.incpath $test.asm", <<END);
$test.asm:1: error: File not found: missing_in_path.inc
   |#include missing_in_path.inc
END
ok ! -f "$test.i", "no .i file produced when -I path does not contain file";
path("$test.incpath")->remove_tree if Test::More->builder->is_passing;

#------------------------------------------------------------------------------
# C_LINE constant line number behavior after multi-line macro / REPT expansions
#------------------------------------------------------------------------------

# Multi-line macro under C_LINE: every emitted line should retain the same logical line
spew("$test.asm", <<END);
MACRO MULTI()
db 10
db 20
db 30
ENDM
C_LINE 6000, "const_macro.asm"
MULTI()
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

check_text_file("$test.i", <<END);
#line 6000, "const_macro.asm"
db 10
#line 6000
db 20
#line 6000
db 30
END

# REPT expansion under C_LINE: each iteration keeps constant logical line number
spew("$test.asm", <<END);
C_LINE 6100, "const_rept.asm"
REPT 3
X
ENDR
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

check_text_file("$test.i", <<END);
#line 6100, "const_rept.asm"
X
#line 6100
X
#line 6100
X
END

# Nested macro expansion under C_LINE: inner and outer expansions all share constant line number
spew("$test.asm", <<END);
MACRO INNER()
db 99
db 100
ENDM
MACRO OUTER()
INNER()
db 101
ENDM
C_LINE 6200, "const_nested.asm"
OUTER()
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

check_text_file("$test.i", <<END);
#line 6200, "const_nested.asm"
db 99
#line 6200
db 100
#line 6200
db 101
END

# Additional tests: C_LINE constant line number after multi-line macro / REPT / REPTC / REPTI / mixed nested expansions

# C_LINE then REPTC: every emitted character iteration keeps constant logical line
spew("$test.asm", <<END);
C_LINE 6300, "const_reptc.asm"
REPTC ch, "XYZ"
defb ch
ENDR
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

check_text_file("$test.i", <<END);
#line 6300, "const_reptc.asm"
defb 88
#line 6300
defb 89
#line 6300
defb 90
END

# C_LINE then REPTI: every emitted argument iteration keeps constant logical line
spew("$test.asm", <<END);
C_LINE 6400, "const_repti.asm"
REPTI v, 5,6,7
db v
ENDR
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

check_text_file("$test.i", <<END);
#line 6400, "const_repti.asm"
db 5
#line 6400
db 6
#line 6400
db 7
END

# C_LINE then macro invoking REPT: all lines from nested expansion share constant line
spew("$test.asm", <<END);
MACRO R3()
REPT 3
X
ENDR
ENDM
C_LINE 6500, "const_macro_rept.asm"
R3()
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

check_text_file("$test.i", <<END);
#line 6500, "const_macro_rept.asm"
X
#line 6500
X
#line 6500
X
END

# C_LINE with macro + LOCAL labels: label and instruction lines keep constant line
spew("$test.asm", <<END);
MACRO LABS(n)
LOCAL L
L:
db n
db n+1
ENDM
C_LINE 6600, "const_local_macro.asm"
LABS(10)
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

# Expect:
# .L_1, db 10, db 10+1 all at 6600
check_text_file("$test.i", <<END);
#line 6600, "const_local_macro.asm"
.L_1
#line 6600
db 10
#line 6600
db 10+1
END

# C_LINE then nested macro calling REPTC and REPTI: all emitted lines constant
spew("$test.asm", <<END);
MACRO MIX()
REPTC ch, "AB"
defb ch
ENDR
REPTI v, 1,2
db v
ENDR
ENDM
C_LINE 6700, "const_mix.asm"
MIX()
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

check_text_file("$test.i", <<END);
#line 6700, "const_mix.asm"
defb 65
#line 6700
defb 66
#line 6700
db 1
#line 6700
db 2
END

# Transition test: C_LINE followed by LINE after expansions
spew("$test.asm", <<END);
MACRO TWO()
db 1
db 2
ENDM
C_LINE 6800, "const_then_line.asm"
TWO()
LINE 50, "after_line.asm"
A
B
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

# Expect first two lines constant at 6800, then LINE 50 starts increment (50,51)
check_text_file("$test.i", <<END);
#line 6800, "const_then_line.asm"
db 1
#line 6800
db 2
#line 50, "after_line.asm"
A
B
END

#------------------------------------------------------------------------------
# Unclosed structure errors: each open construct at EOF should report an error
# with the line of the opening statement.
#------------------------------------------------------------------------------

# Unclosed MACRO (missing ENDM)
unlink("$test.i");
spew("$test.asm", <<END);
MACRO M()
db 1
END
capture_nok("z88dk-z80asm -E $test.asm", <<END);
$test.asm:1: error: Invalid syntax: Unexpected end of input in MACRO (expected ENDM)
   |MACRO M()
END
ok ! -f "$test.i", "no .i file produced on unclosed MACRO";

# Unclosed REPT (missing ENDR)
unlink("$test.i");
spew("$test.asm", <<END);
REPT 3
X
END
capture_nok("z88dk-z80asm -E $test.asm", <<END);
$test.asm:1: error: Invalid syntax: Unexpected end of input in REPT (expected ENDR)
   |REPT 3
END
ok ! -f "$test.i", "no .i file produced on unclosed REPT";

# Unclosed REPTC (missing ENDR)
unlink("$test.i");
spew("$test.asm", <<END);
REPTC ch, "AB"
defb ch
END
capture_nok("z88dk-z80asm -E $test.asm", <<END);
$test.asm:1: error: Invalid syntax: Unexpected end of input in REPTC (expected ENDR)
   |REPTC ch, "AB"
END
ok ! -f "$test.i", "no .i file produced on unclosed REPTC";

# Unclosed REPTI (missing ENDR)
unlink("$test.i");
spew("$test.asm", <<END);
REPTI v, 1,2
db v
END
capture_nok("z88dk-z80asm -E $test.asm", <<END);
$test.asm:1: error: Invalid syntax: Unexpected end of input in REPTI (expected ENDR)
   |REPTI v, 1,2
END
ok ! -f "$test.i", "no .i file produced on unclosed REPTI";

# Multiple different unclosed constructs: only the innermost (last opened) IF should report,
# followed by earlier MACRO still expecting ENDM once IF block ends (macro body collection).
# (Demonstrates that each structure produces its own error when reached.)
unlink("$test.i");
spew("$test.asm", <<END);
MACRO OUT()
REPT 2
IF 1
X
ENDM
END
capture_nok("z88dk-z80asm -E $test.asm", <<END);
$test.asm:1: error: Invalid syntax: Unexpected ENDM directive without matching MACRO
   |MACRO OUT()
$test.asm:1: error: Invalid syntax: Unexpected end of input in MACRO (expected ENDM)
   |MACRO OUT()
END
# Note: current implementation reports only the unclosed IF; OUT() / REPT error
# messages are not emitted after EOF, so .i is not produced.
ok ! -f "$test.i", "no .i file produced on nested unclosed structures";

# Additional tests: missing ENDIF for IF / IFDEF / IFNDEF directives

# Unclosed IF (already tested elsewhere, but explicit standalone verification)
unlink("$test.i");
spew("$test.asm", <<END);
IF 1
A
END
capture_nok("z88dk-z80asm -E $test.asm", <<END);
$test.asm:1: error: Invalid syntax: Unexpected end of input in IF (expected ENDIF)
END
ok ! -f "$test.i", "no .i file produced on unclosed IF";

# Unclosed IFDEF (missing ENDIF)
unlink("$test.i");
spew("$test.asm", <<END);
#define FLAG 1
IFDEF FLAG
GOOD
END
capture_nok("z88dk-z80asm -E $test.asm", <<END);
$test.asm:2: error: Invalid syntax: Unexpected end of input in IF (expected ENDIF)
END
ok ! -f "$test.i", "no .i file produced on unclosed IFDEF";

# Unclosed IFNDEF (missing ENDIF)
unlink("$test.i");
spew("$test.asm", <<END);
IFNDEF MISSING
FALLBACK
END
capture_nok("z88dk-z80asm -E $test.asm", <<END);
$test.asm:1: error: Invalid syntax: Unexpected end of input in IF (expected ENDIF)
END
ok ! -f "$test.i", "no .i file produced on unclosed IFNDEF";

#------------------------------------------------------------------------------
# String escape sequences: octal / hex / standard escapes and unknown escapes
#------------------------------------------------------------------------------
spew("$test.asm", <<END);
db "\\a\\b\\e\\f\\n\\r\\t\\v"
db "\\101\\12\\x41\\x4A\\xA"
db "QUOTE: \\\" BACKSLASH: \\\\ UNKNOWN: \\q"
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

# Expected expansions:
#  \a 7, \b 8, \e 27, \f 12, \n 10, \r 13, \t 9, \v 11
#  \101 'A' 65, \12 newline 10, \x41 'A' 65, \x4A 'J' 74, \xA 10
#  "QUOTE: \" BACKSLASH: \\ UNKNOWN: \q" -> numeric bytes of each character
check_text_file("$test.i", <<END);
#line 1, "$test.asm"
db 7,8,27,12,10,13,9,11
db 65,10,65,74,10
db 81,85,79,84,69,58,32,34,32,66,65,67,75,83,76,65,83,72,58,32,92,32,85,78,75,78,79,87,78,58,32,113
END

#------------------------------------------------------------------------------
# parse_macro_args negative tests: trailing comma and bad nesting
#------------------------------------------------------------------------------

# REPTI trailing comma -> Invalid argument list in REPTI
unlink("$test.i");
spew("$test.asm", <<END);
REPTI v, 1,2,
db v
ENDR
END
capture_nok("z88dk-z80asm -E $test.asm", <<END);
$test.asm:1: error: Invalid syntax: Invalid argument list in REPTI
   |REPTI v, 1,2,
$test.asm:3: error: Invalid syntax: Unexpected ENDR directive without matching REPT
   |ENDR
END
ok ! -f "$test.i", "no .i file produced on REPTI trailing comma";

# REPTI bad nesting (unclosed parenthesis) -> Invalid argument list in REPTI
unlink("$test.i");
spew("$test.asm", <<END);
REPTI v, (1,2
db v
ENDR
END
capture_nok("z88dk-z80asm -E $test.asm", <<END);
$test.asm:1: error: Invalid syntax: Invalid argument list in REPTI
   |REPTI v, (1,2
$test.asm:3: error: Invalid syntax: Unexpected ENDR directive without matching REPT
   |ENDR
END
ok ! -f "$test.i", "no .i file produced on REPTI bad nesting";

# Name-directive REPTI trailing comma -> Invalid argument list after REPTI
unlink("$test.i");
spew("$test.asm", <<END);
val REPTI 3,4,
db val
ENDR
END
capture_nok("z88dk-z80asm -E $test.asm", <<END);
$test.asm:1: error: Invalid syntax: Invalid argument list after REPTI
   |val REPTI 3,4,
$test.asm:3: error: Invalid syntax: Unexpected ENDR directive without matching REPT
   |ENDR
END
ok ! -f "$test.i", "no .i file produced on name-directive REPTI trailing comma";

# Name-directive REPTI bad nesting -> Invalid argument list after REPTI
unlink("$test.i");
spew("$test.asm", <<END);
val REPTI (7,8
db val
ENDR
END
capture_nok("z88dk-z80asm -E $test.asm", <<END);
$test.asm:1: error: Invalid syntax: Invalid argument list after REPTI
   |val REPTI (7,8
$test.asm:3: error: Invalid syntax: Unexpected ENDR directive without matching REPT
   |ENDR
END
ok ! -f "$test.i", "no .i file produced on name-directive REPTI bad nesting";

# Function-like macro trailing comma inside parentheses -> Macro argument count mismatch
unlink("$test.i");
spew("$test.asm", <<END);
MACRO F(a,b)
db a,b
ENDM
F(1,2,)
END
capture_nok("z88dk-z80asm -E $test.asm", <<END);
$test.asm:4: error: Invalid syntax: Macro argument count mismatch for: F
   |F(1,2,)
END
ok ! -f "$test.i", "no .i file produced on macro call trailing comma";

# Function-like macro bad nesting (unclosed parenthesis) -> Macro argument count mismatch
unlink("$test.i");
spew("$test.asm", <<END);
MACRO G(x,y)
db x,y
ENDM
G(1,(2,3
END
capture_nok("z88dk-z80asm -E $test.asm", <<END);
$test.asm:4: error: Invalid syntax: Macro argument count mismatch for: G
   |G(1,(2,3
END
ok ! -f "$test.i", "no .i file produced on macro call bad nesting";

#------------------------------------------------------------------------------
# Duplicate parameter names in function-like macros (DuplicateDefinition)
#------------------------------------------------------------------------------

# MACRO form: duplicate parameter 'a' triggers Duplicate definition error
unlink("$test.i");
spew("$test.asm", <<END);
MACRO M(a,a)
db 0
ENDM
END
capture_nok("z88dk-z80asm -E $test.asm", <<END);
$test.asm:1: error: Duplicate definition: a
   |MACRO M(a,a)
END
ok ! -f "$test.i", "no .i file produced on duplicate MACRO parameters";

# #define form: duplicate parameter 'a' triggers Duplicate definition error
unlink("$test.i");
spew("$test.asm", <<END);
#define F(a,a) 1
F(2)
END
capture_nok("z88dk-z80asm -E $test.asm", <<END);
$test.asm:1: error: Duplicate definition: a
   |#define F(a,a) 1
$test.asm:2: error: Invalid syntax: Macro argument count mismatch for: F
   |F(2)
END
ok ! -f "$test.i", "no .i file produced on duplicate #define parameters";

#------------------------------------------------------------------------------
# Function-like macro arity: fewer args without parentheses, and empty ()
#------------------------------------------------------------------------------

# Fewer args without parentheses: treated as literal (no error)
# Define a two-arg macro, invoke with only one arg without parentheses
unlink("$test.i");
spew("$test.asm", <<END);
#define F(a,b) a + b
F 1
END
capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END
# Expect the call to remain literal since there are no parentheses (graceful fallback)
check_text_file("$test.i", <<END);
#line 2, "$test.asm"
F 1
END

# Empty parentheses when params are required: should raise arg count mismatch
unlink("$test.i");
spew("$test.asm", <<END);
#define F(a) a
F()
END
capture_nok("z88dk-z80asm -E $test.asm", <<END);
$test.asm:2: error: Invalid syntax: Macro argument count mismatch for: F
   |F()
END
ok ! -f "$test.i", "no .i file produced on empty () for required-arg macro";

#------------------------------------------------------------------------------
# Function-like macro with empty parameter list invoked with arguments (mismatch)
#------------------------------------------------------------------------------

# H() defined with no parameters; invoking H(1) should raise arg count mismatch
unlink("$test.i");
spew("$test.asm", <<END);
#define H() 0
H(1)
END
capture_nok("z88dk-z80asm -E $test.asm", <<END);
$test.asm:2: error: Invalid syntax: Macro argument count mismatch for: H
   |H(1)
END
ok ! -f "$test.i", "no .i file produced when calling zero-param macro with arguments";

#------------------------------------------------------------------------------
# MACRO parameter list without parentheses (e.g., MACRO M a,b)
#------------------------------------------------------------------------------

# Define a function-like MACRO with unparenthesized parameters and call it
# both without and with parentheses.
unlink("$test.i");
spew("$test.asm", <<END);
MACRO SUM a,b
db a + b
ENDM
SUM 3,4
SUM(5,6)
END
capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END
# Expect both calls to expand correctly at the call-site line
check_text_file("$test.i", <<END);
#line 4, "$test.asm"
db 3 + 4
db 5 + 6
END

#------------------------------------------------------------------------------
# Macro recursion: longer mutual cycle (>2 macros) should report an error
#------------------------------------------------------------------------------

# A -> B -> C -> A cycle; invoking A should trigger MacroRecursionLimit on C
unlink("$test.i");
spew("$test.asm", <<END);
#define A B
#define B C
#define C A
A
END
capture_nok("z88dk-z80asm -E $test.asm", <<END);
$test.asm:4: error: Macro recursion limit exceeded: C
   |C
END
ok ! -f "$test.i", "output file not produced on longer macro cycle";

#------------------------------------------------------------------------------
# Multi-line macro argument expansion (':' and '\' inside argument)
# Flattening and extra-line insertion when an argument expands to multiple lines
#------------------------------------------------------------------------------

# ':' inside argument -> two logical lines at the call site
unlink("$test.i");
spew("$test.asm", <<END);
#define ARG A : B
#define EDB(x) db x
EDB(ARG)
END
capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END
check_text_file("$test.i", <<END);
#line 3, "$test.asm"
db A
#line 3
B
END

# '\' inside argument -> two logical lines at the call site
unlink("$test.i");
spew("$test.asm", <<END);
#define ARG2 10 \\ 20
#define EDB2(x) db x
EDB2(ARG2)
END
capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END
check_text_file("$test.i", <<END);
#line 3, "$test.asm"
db 10
#line 3
20
END

#------------------------------------------------------------------------------
# DEFINE macros with multi-line bodies split by ':' or '\' expand to several lines
#------------------------------------------------------------------------------

# Object-like and function-like #define bodies using ':' and '\' split into multiple lines.
# Also cover name-directive DEFINE with ':' and '\'.
unlink("$test.i");
spew("$test.asm", <<'END');
#define TWOC db 1 : db 2
TWOC
#define TWOB db 3 \ db 4
TWOB
#define F2(a,b) db a : db b
F2(9,10)
#define F2B(a,b) db a \ db b
F2B(11,12)
M DEFINE db 13 : db 14
M
N DEFINE db 15 \ db 16
N
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

# Each macro call occurs at its physical call-site line; the split parts are emitted
# as separate logical lines at the same call-site. When the logical line decreases,
# a #line directive without filename appears.
check_text_file("$test.i", <<END);
#line 2, "$test.asm"
db 1
#line 2
db 2

db 3
#line 4
db 4

db 9
#line 6
db 10

db 11
#line 8
db 12

db 13
#line 10
db 14

db 15
#line 12
db 16
END

#------------------------------------------------------------------------------
# Clean up
#------------------------------------------------------------------------------
unlink_testfiles if Test::More->builder->is_passing;
done_testing;
