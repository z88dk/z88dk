#------------------------------------------------------------------------------
# Z80 assembler
# Copyright (C) Paulo Custodio, 2011-2025
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

#------------------------------------------------------------------------------
# Z80 assembler - HLA (High-Level Assembler) directive tests
# Directives covered:
#   %IF / %ELIF / %ELSE / %ENDIF
#   %WHILE / %WEND
#   %REPEAT / %UNTIL / %UNTILB / %UNTILBC
#   %BREAK [IF expr]
#   %CONTINUE [IF expr]
# Expressions:
#   - comparisons: reg8 | (HL) | (abs) | imm const
#   - logical: '!' and '&&' (avoid '||' here due to temp-label variability)
#   - flag tests: Z, NZ, C, NC, PO, PE, P, M
#------------------------------------------------------------------------------

BEGIN { use lib 't'; require 'testlib.pl'; }
use Modern::Perl;

#------------------------------------------------------------------------------
# %IF basic (no %ELSE)
#------------------------------------------------------------------------------
spew("$test.asm", <<END);
%IF A == 0
%ENDIF
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
% z88dk-z80asm -v -E $test.asm
Preprocessing file: $test.asm -> $test.i
END

# Expect: CP 0; JP NZ,<ELSE>; place ELSE and END labels
check_text_file("$test.i", <<END);
#line 1, "$test.asm"
CP 0
#line 1
JP NZ,HLA_IF_0_ELSE
.HLA_IF_0_ELSE
#line 2
.HLA_IF_0_END
END

#------------------------------------------------------------------------------
# %IF with %ELSE (no body lines)
#------------------------------------------------------------------------------
spew("$test.asm", <<END);
%IF A == 0
%ELSE
%ENDIF
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
% z88dk-z80asm -v -E $test.asm
Preprocessing file: $test.asm -> $test.i
END

# Expect: CP 0; JP NZ,<ELSE>; JP <END>; place ELSE then END
check_text_file("$test.i", <<END);
#line 1, "$test.asm"
CP 0
#line 1
JP NZ,HLA_IF_0_ELSE
JP HLA_IF_0_END
#line 2
.HLA_IF_0_ELSE
.HLA_IF_0_END
END

#------------------------------------------------------------------------------
# %IF / %ELIF / %ELSE chain (no body lines)
#------------------------------------------------------------------------------
spew("$test.asm", <<END);
%IF A < 5
%ELIF A == 7
%ELSE
%ENDIF
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
% z88dk-z80asm -v -E $test.asm
Preprocessing file: $test.asm -> $test.i
END

# Flow:
#   IF A<5 false -> JP NC, IF_0_ELSE
#   (ELIF) close prior true-branch: JP END; place .ELSE
#   ELIF A==7 false -> JP NZ, IF_1_ELSE
#   ELSE: JP END; place .IF_1_ELSE
#   END:  place .IF_0_END
check_text_file("$test.i", <<END);
#line 1, "$test.asm"
CP 5
#line 1
JP NC,HLA_IF_0_ELSE
JP HLA_IF_0_END
#line 2
.HLA_IF_0_ELSE
#line 2
CP 7
#line 2
JP NZ,HLA_IF_1_ELSE
JP HLA_IF_0_END
#line 3
.HLA_IF_1_ELSE
.HLA_IF_0_END
END

#------------------------------------------------------------------------------
# %IF with NOT: %( !(A==0) )
#------------------------------------------------------------------------------
spew("$test.asm", <<END);
%IF !( A == 0 )
%ENDIF
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
% z88dk-z80asm -v -E $test.asm
Preprocessing file: $test.asm -> $test.i
END

# NOT turns branch-if-false into branch-if-true of inner: JP Z,<ELSE>
check_text_file("$test.i", <<END);
#line 1, "$test.asm"
CP 0
#line 1
JP Z,HLA_IF_0_ELSE
.HLA_IF_0_ELSE
#line 2
.HLA_IF_0_END
END

#------------------------------------------------------------------------------
# Operand coverage: reg8, (HL), (abs)
#------------------------------------------------------------------------------
spew("$test.asm", <<END);
%IF B == 1
%ENDIF
%IF (HL) > 0
%ENDIF
%IF (100) != 0
%ENDIF
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
% z88dk-z80asm -v -E $test.asm
Preprocessing file: $test.asm -> $test.i
END

# B==1: LD A,B; CP 1; JP NZ,<ELSE>
# (HL)>0: LD A,(HL); CP 0; JP Z,<ELSE> and JP C,<ELSE>  (false for '>')
# (100)!=0: LD A,(100); CP 0; JP Z,<ELSE>
check_text_file("$test.i", <<END);
#line 1, "$test.asm"
LD A,B
#line 1
CP 1
#line 1
JP NZ,HLA_IF_0_ELSE
.HLA_IF_0_ELSE
#line 2
.HLA_IF_0_END
LD A,(HL)
#line 3
CP 0
#line 3
JP Z,HLA_IF_1_ELSE
#line 3
JP C,HLA_IF_1_ELSE
.HLA_IF_1_ELSE
#line 4
.HLA_IF_1_END
LD A,(100)
#line 5
CP 0
#line 5
JP Z,HLA_IF_2_ELSE
.HLA_IF_2_ELSE
#line 6
.HLA_IF_2_END
END

#------------------------------------------------------------------------------
# Logical AND: A<10 && A>5  (no temp labels on false branch)
#------------------------------------------------------------------------------
spew("$test.asm", <<END);
%IF (A < 10) && (A > 5)
%ENDIF
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
% z88dk-z80asm -v -E $test.asm
Preprocessing file: $test.asm -> $test.i
END

# False of (L && R) => false if L false OR R false
#   L: A<10 false -> JP NC,<ELSE>
#   R: A>5 false  -> JP Z,<ELSE> and JP C,<ELSE>
check_text_file("$test.i", <<END);
#line 1, "$test.asm"
CP 10
#line 1
JP NC,HLA_IF_0_ELSE
#line 1
CP 5
#line 1
JP Z,HLA_IF_0_ELSE
#line 1
JP C,HLA_IF_0_ELSE
.HLA_IF_0_ELSE
#line 2
.HLA_IF_0_END
END

#------------------------------------------------------------------------------
# Flag test in %IF: Z
#------------------------------------------------------------------------------
spew("$test.asm", <<END);
%IF Z
%ENDIF
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
% z88dk-z80asm -v -E $test.asm
Preprocessing file: $test.asm -> $test.i
END

# Branch-if-false of 'Z' => invert to NZ
check_text_file("$test.i", <<END);
#line 1, "$test.asm"
JP NZ,HLA_IF_0_ELSE
.HLA_IF_0_ELSE
#line 2
.HLA_IF_0_END
END

#------------------------------------------------------------------------------
# %WHILE ... %WEND (no body lines)
#------------------------------------------------------------------------------
spew("$test.asm", <<END);
%WHILE A < 3
%WEND
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
% z88dk-z80asm -v -E $test.asm
Preprocessing file: $test.asm -> $test.i
END

# Expect top label, bif to END, then WEND emits JP TOP and END label
check_text_file("$test.i", <<END);
#line 1, "$test.asm"
.HLA_WHILE_0_TOP
#line 1
CP 3
#line 1
JP NC,HLA_WHILE_0_END
JP HLA_WHILE_0_TOP
#line 2
.HLA_WHILE_0_END
END

#------------------------------------------------------------------------------
# %REPEAT ... %UNTIL expr (no body lines)
#------------------------------------------------------------------------------
spew("$test.asm", <<END);
%REPEAT
%UNTIL A == 0
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
% z88dk-z80asm -v -E $test.asm
Preprocessing file: $test.asm -> $test.i
END

# BIF(false) to TOP: A==0 false => NZ
check_text_file("$test.i", <<END);
#line 1, "$test.asm"
.HLA_REPEAT_0_TOP
CP 0
#line 2
JP NZ,HLA_REPEAT_0_TOP
#line 2
.HLA_REPEAT_0_END
END

#------------------------------------------------------------------------------
# %UNTILB and %UNTILBC
#------------------------------------------------------------------------------
spew("$test.asm", <<END);
%REPEAT
%UNTILB
%REPEAT
%UNTILBC
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
% z88dk-z80asm -v -E $test.asm
Preprocessing file: $test.asm -> $test.i
END

check_text_file("$test.i", <<END);
#line 1, "$test.asm"
.HLA_REPEAT_0_TOP
DEC B
#line 2
JP NZ,HLA_REPEAT_0_TOP
#line 2
.HLA_REPEAT_0_END
.HLA_REPEAT_1_TOP
DEC BC
#line 4
LD A,B
#line 4
OR C
#line 4
JP NZ,HLA_REPEAT_1_TOP
#line 4
.HLA_REPEAT_1_END
END

#------------------------------------------------------------------------------
# %BREAK and %CONTINUE (unconditional) inside %WHILE
#------------------------------------------------------------------------------
spew("$test.asm", <<END);
%WHILE C == 0
%CONTINUE
%BREAK
%WEND
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
% z88dk-z80asm -v -E $test.asm
Preprocessing file: $test.asm -> $test.i
END

check_text_file("$test.i", <<END);
#line 1, "$test.asm"
.HLA_WHILE_0_TOP
#line 1
LD A,C
#line 1
CP 0
#line 1
JP NZ,HLA_WHILE_0_END
JP HLA_WHILE_0_TOP
JP HLA_WHILE_0_END
JP HLA_WHILE_0_TOP
#line 4
.HLA_WHILE_0_END
END

#------------------------------------------------------------------------------
# %BREAK IF and %CONTINUE IF inside %REPEAT (no body lines)
#------------------------------------------------------------------------------
spew("$test.asm", <<END);
%REPEAT
%BREAK IF A == 0
%CONTINUE IF Z
%UNTILB
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
% z88dk-z80asm -v -E $test.asm
Preprocessing file: $test.asm -> $test.i
END

# BREAK IF A==0 -> JP Z,END
# CONTINUE IF Z -> JP Z,TOP
check_text_file("$test.i", <<END);
#line 1, "$test.asm"
.HLA_REPEAT_0_TOP
CP 0
#line 2
JP Z,HLA_REPEAT_0_END
JP Z,HLA_REPEAT_0_TOP
DEC B
#line 4
JP NZ,HLA_REPEAT_0_TOP
#line 4
.HLA_REPEAT_0_END
END

# (Add after existing %WHILE tests)

#------------------------------------------------------------------------------
# %WHILE ambiguity: flag test vs register comparison
#------------------------------------------------------------------------------
spew("$test.asm", <<END);
%WHILE C
%WEND
%WHILE C == 3
%WEND
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
% z88dk-z80asm -v -E $test.asm
Preprocessing file: $test.asm -> $test.i
END

# First loop: treat 'C' as carry-flag test -> JP NC,end
# Second loop: treat 'C' as register C comparison -> LD A,C / CP 3 / JP NZ,end
check_text_file("$test.i", <<END);
#line 1, "$test.asm"
.HLA_WHILE_0_TOP
#line 1
JP NC,HLA_WHILE_0_END
JP HLA_WHILE_0_TOP
#line 2
.HLA_WHILE_0_END
.HLA_WHILE_1_TOP
#line 3
LD A,C
#line 3
CP 3
#line 3
JP NZ,HLA_WHILE_1_END
JP HLA_WHILE_1_TOP
#line 4
.HLA_WHILE_1_END
END

#------------------------------------------------------------------------------
# Logical OR: (A<10) || (A>20)
#------------------------------------------------------------------------------
spew("$test.asm", <<END);
%IF (A<10)||(A>20)
%ENDIF
END

capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
% z88dk-z80asm -v -E $test.asm
Preprocessing file: $test.asm -> $test.i
END

# False of (L || R) only if both false:
#  - gen_true(L) -> JP C, HLA_BOOL_1_OR_SKIP
#  - gen_false(R) -> JP Z,ELSE and JP C,ELSE
#  - place HLA_BOOL_1_OR_SKIP, then ELSE and END labels
check_text_file("$test.i", <<END);
#line 1, "$test.asm"
CP 10
#line 1
JP C,HLA_BOOL_1_OR_SKIP
#line 1
CP 20
#line 1
JP Z,HLA_IF_0_ELSE
#line 1
JP C,HLA_IF_0_ELSE
#line 1
.HLA_BOOL_1_OR_SKIP
.HLA_IF_0_ELSE
#line 2
.HLA_IF_0_END
END

#------------------------------------------------------------------------------
# Error cases
#------------------------------------------------------------------------------

# %ELSE without %IF
unlink("$test.i");
spew("$test.asm", <<END);
%ELSE
END
capture_nok("z88dk-z80asm -E $test.asm", <<END);
$test.asm:1: error: Invalid syntax: %ELSE without matching %IF
   |%ELSE
END
ok ! -f "$test.i", "no .i on stray %ELSE";

# %UNTIL without %REPEAT
unlink("$test.i");
spew("$test.asm", <<END);
%UNTIL A==0
END
capture_nok("z88dk-z80asm -E $test.asm", <<END);
$test.asm:1: error: Invalid syntax: %UNTIL without matching %REPEAT
   |%UNTIL A==0
END
ok ! -f "$test.i", "no .i on %UNTIL without %REPEAT";

# %WEND without %WHILE
unlink("$test.i");
spew("$test.asm", <<END);
%WEND
END
capture_nok("z88dk-z80asm -E $test.asm", <<END);
$test.asm:1: error: Invalid syntax: %WEND without matching %WHILE
   |%WEND
END
ok ! -f "$test.i", "no .i on %WEND without %WHILE";

# %ELSE with trailing tokens
unlink("$test.i");
spew("$test.asm", <<END);
%IF A==0
%ELSE junk
%ENDIF
END
capture_nok("z88dk-z80asm -E $test.asm", <<END);
$test.asm:2: error: Invalid syntax: Unexpected tokens after %ELSE
   |%ELSE junk
END
ok ! -f "$test.i", "no .i on %ELSE with trailing tokens";

# Unclosed HLA block at EOF
unlink("$test.i");
spew("$test.asm", <<END);
%IF A==1
END
capture_nok("z88dk-z80asm -E $test.asm", <<END);
$test.asm:1: error: Invalid syntax: Unclosed HLA block
END
ok ! -f "$test.i", "no .i on unclosed HLA block";

#------------------------------------------------------------------------------
# Clean up
#------------------------------------------------------------------------------
unlink_testfiles if Test::More->builder->is_passing;
done_testing;
