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
#line 900
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


# clean up
unlink_testfiles if Test::More->builder->is_passing;
done_testing;
