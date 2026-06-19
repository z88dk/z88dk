#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# ============================================================
#  SYMBOL DECLARATION / DEFINITION EXHAUSTIVE TEST MATRIX
#  Covers:
#    - extern / public / global / none
#    - definition before / between / after
#    - redeclaration combinations
#    - multi-step sequences
#    - correct error messages
# ============================================================


# ============================================================
#  SECTION 1 - BASIC EXTERN BEHAVIOR
# ============================================================

# 1A - extern before definition (allowed)
z80asm_ok("", "", "", <<END_SRC, bytes(0x00));
    extern x
x:  nop
END_SRC

# 1B - definition before extern (allowed)
z80asm_ok("", "", "", <<END_SRC, bytes(0x00));
x:  nop
    extern x
END_SRC

# 1C - extern -> define -> extern (allowed)
z80asm_ok("", "", "", <<END_SRC, bytes(0x00));
    extern x
x:  nop
    extern x
END_SRC

# 1D - extern without definition (allowed, becomes undefined extern)
z80asm_ok("", "", "", <<END_SRC, bytes());
    extern x
END_SRC


# ============================================================
#  SECTION 2 - BASIC PUBLIC BEHAVIOR
# ============================================================

# 2A - public before definition (allowed)
z80asm_ok("", "", "", <<END_SRC, bytes(0x00));
    public x
x:  nop
END_SRC

# 2B - definition before public (allowed)
z80asm_ok("", "", "", <<END_SRC, bytes(0x00));
x:  nop
    public x
END_SRC

# 2C - public without definition (error at end of input)
z80asm_nok("", "", <<END_SRC, <<END_ERR);
    public x
END_SRC
$test.asm:1: error: undefined symbol: x
END_ERR


# ============================================================
#  SECTION 3 - BASIC GLOBAL BEHAVIOR
# ============================================================

# 3A - global before definition (allowed, becomes public)
z80asm_ok("", "", "", <<END_SRC, bytes(0x00));
    global x
x:  nop
END_SRC

# 3B - definition before global (allowed, becomes public)
z80asm_ok("", "", "", <<END_SRC, bytes(0x00));
x:  nop
    global x
END_SRC

# 3C - global without definition (allowed, becomes extern)
z80asm_ok("", "", "", <<END_SRC, bytes());
    global x
END_SRC


# ============================================================
#  SECTION 4 - REDECLARATION MATRIX (extern/public/global)
# ============================================================

# 4A ---------- extern -> extern ----------
z80asm_ok("", "", "", <<END_SRC, bytes());
    extern x
    extern x
END_SRC

# 4B ---------- extern -> public (upgrade) ----------
z80asm_ok("", "", "", <<END_SRC, bytes(0x00));
    extern x
    public x
x:  nop
END_SRC

# 4C ---------- extern -> global (ignored) ----------
z80asm_ok("", "", "", <<END_SRC, bytes(0x00));
    extern x
    global x
x:  nop
END_SRC

# 4D ---------- public -> extern (ignored) ----------
z80asm_ok("", "", "", <<END_SRC, bytes(0x00));
    public x
    extern x
x:  nop
END_SRC

# 4E ---------- public -> public ----------
z80asm_ok("", "", "", <<END_SRC, bytes(0x00));
    public x
    public x
x:  nop
END_SRC

# 4F ---------- public -> global (ignored) ----------
z80asm_ok("", "", "", <<END_SRC, bytes(0x00));
    public x
    global x
x:  nop
END_SRC

# 4G ---------- global -> extern (ignored) ----------
z80asm_ok("", "", "", <<END_SRC, bytes(0x00));
    global x
    extern x
x:  nop
END_SRC

# 4H ---------- global -> public (ignored) ----------
z80asm_ok("", "", "", <<END_SRC, bytes(0x00));
    global x
    public x
x:  nop
END_SRC

# 4I ---------- global -> global ----------
z80asm_ok("", "", "", <<END_SRC, bytes(0x00));
    global x
    global x
x:  nop
END_SRC


# ============================================================
#  SECTION 5 - DEFINITION BEFORE / BETWEEN / AFTER DECLARATIONS
# ============================================================

# 5A ----- definition before extern (allowed) -----
z80asm_ok("", "", "", <<END_SRC, bytes(0x00));
x:  nop
    extern x
END_SRC

# 5B ----- definition between externs (allowed) -----
z80asm_ok("", "", "", <<END_SRC, bytes(0x00));
    extern x
x:  nop
    extern x
END_SRC

# 5C ----- definition before public (allowed) -----
z80asm_ok("", "", "", <<END_SRC, bytes(0x00));
x:  nop
    public x
END_SRC

# 5D ----- definition before global (allowed) -----
z80asm_ok("", "", "", <<END_SRC, bytes(0x00));
x:  nop
    global x
END_SRC


# ============================================================
#  SECTION 6 - MULTI-STEP SEQUENCES
# ============================================================

# 6A extern -> public -> global -> definition
z80asm_ok("", "", "", <<END_SRC, bytes(0x00));
    extern x
    public x
    global x
x:  nop
END_SRC

# 6B public -> global -> extern -> definition
#    extern ignored because public already seen
z80asm_ok("", "", "", <<END_SRC, bytes(0x00));
    public x
    global x
    extern x
x:  nop
END_SRC

# 6C global -> extern -> public -> definition
z80asm_ok("", "", "", <<END_SRC, bytes(0x00));
    global x
    extern x
    public x
x:  nop
END_SRC

# 6D extern -> global -> extern -> definition
z80asm_ok("", "", "", <<END_SRC, bytes(0x00));
    extern x
    global x
    extern x
x:  nop
END_SRC


# ============================================================
#  SECTION 7 - DUPLICATE DEFINITION ERRORS
# ============================================================

# 7A definition -> definition (duplicate definition)
z80asm_nok("", "", <<END_SRC, <<END_ERR);
x:  nop
x:  nop
END_SRC
$test.asm:2: error: duplicate definition: x
  ^---- x: nop
END_ERR

# 7B definition -> public -> definition (duplicate definition)
z80asm_nok("", "", <<END_SRC, <<END_ERR);
x:  nop
    public x
x:  nop
END_SRC
$test.asm:3: error: duplicate definition: x
  ^---- x: nop
END_ERR


# ============================================================
#  SECTION 8 - UNDEFINED SYMBOL ERRORS
# ============================================================

# 8A public without definition
z80asm_nok("", "", <<END_SRC, <<END_ERR);
    public x
END_SRC
$test.asm:1: error: undefined symbol: x
END_ERR

# 8B extern without definition (allowed)
z80asm_ok("", "", "", <<END_SRC, bytes());
    extern x
END_SRC

# 8C global without definition (allowed, becomes extern)
z80asm_ok("", "", "", <<END_SRC, bytes());
    global x
END_SRC

# ============================================================
#  SECTION 9 -> SYMBOL USE TESTS
#  These verify that referencing a symbol triggers correct
#  undefined / defined behavior depending on declarations.
# ============================================================

# 9A -> use of undefined symbol (no declaration)
z80asm_nok( "", "", <<END_SRC, <<END_ERR );
    ld a,(x)
END_SRC
$test.asm:1: error: undefined symbol: x
  ^---- (x)
END_ERR

# 9B -> use of symbol declared extern (allowed, no code emitted)
spew("$test.asm", <<END_SRC);
    extern x
    ld a,(x)
END_SRC
spew("$test.1.asm", <<END_SRC);
    public x
x:
END_SRC

unlink "$test.o";
capture_ok( "z88dk-z80asm $test.asm", "" );
ok -f "$test.o";

capture_ok("z88dk-z80asm -b $test.asm $test.1.asm", "");
check_bin_file("$test.bin", bytes(0x3A, 0x03, 0x00));

# 9C -> use of symbol declared global but not defined (allowed, becomes extern)
spew("$test.asm", <<END_SRC);
    global x
    ld a,(x)
END_SRC
spew("$test.1.asm", <<END_SRC);
    public x
x:
END_SRC

unlink "$test.o";
capture_ok( "z88dk-z80asm $test.asm", "" );
ok -f "$test.o";

capture_ok("z88dk-z80asm -b $test.asm $test.1.asm", "");
check_bin_file("$test.bin", bytes(0x3A, 0x03, 0x00));

# 9D -> use of symbol declared public but not defined (error)
z80asm_nok( "", "", <<END_SRC, <<END_ERR );
    public x
    ld a,(x)
END_SRC
$test.asm:2: error: undefined symbol: x
  ^---- (x)
$test.asm:1: error: undefined symbol: x
END_ERR

# 9E -> use of symbol defined later (forward reference)
z80asm_ok( "", "", "", <<END_SRC, bytes( 0x3A, 0x03, 0x00, 0x00 ) );
    ld a,(x)
x:  nop
END_SRC

# 9F -> use of symbol defined earlier
z80asm_ok( "", "", "", <<END_SRC, bytes( 0x00, 0x3A, 0x00, 0x00 ) );
x:  nop
    ld a,(x)
END_SRC

# ============================================================
#  SECTION 10 - FORWARD REFERENCE TESTS
#  These verify that the assembler correctly resolves symbols
#  defined later in the file, with and without declarations.
# ============================================================

# 10A - forward reference without declaration (allowed)
z80asm_ok( "", "", "", <<END_SRC, bytes( 0x3A, 0x03, 0x00, 0x00 ) );
    ld a,(x)
x:  nop
END_SRC

# 10B - forward reference with extern (allowed)
z80asm_ok( "", "", "", <<END_SRC, bytes( 0x3A, 0x03, 0x00, 0x00 ) );
    extern x
    ld a,(x)
x:  nop
END_SRC

# 10C - forward reference with public (allowed)
z80asm_ok( "", "", "", <<END_SRC, bytes( 0x3A, 0x03, 0x00, 0x00 ) );
    public x
    ld a,(x)
x:  nop
END_SRC

# 10D - forward reference with global (allowed)
z80asm_ok( "", "", "", <<END_SRC, bytes( 0x3A, 0x03, 0x00, 0x00 ) );
    global x
    ld a,(x)
x:  nop
END_SRC

# 10E - forward reference to symbol never defined (undefined)
z80asm_nok( "", "", <<END_SRC, <<END_ERR );
    ld a,(x)
END_SRC
$test.asm:1: error: undefined symbol: x
  ^---- (x)
END_ERR

# 10F - forward reference with extern but never defined (allowed)
# Produces a relocation to an external symbol.
spew("$test.asm", <<END_SRC);
    extern x
    ld a,(x)
END_SRC
spew("$test.1.asm", <<END_SRC);
    public x
x:
END_SRC

unlink "$test.o";
capture_ok( "z88dk-z80asm $test.asm", "" );
ok -f "$test.o";

capture_ok("z88dk-z80asm -b $test.asm $test.1.asm", "");
check_bin_file("$test.bin", bytes(0x3A, 0x03, 0x00));

# 10G - forward reference with global but never defined (allowed)
# global becomes extern
spew("$test.asm", <<END_SRC);
    global x
    ld a,(x)
END_SRC
spew("$test.1.asm", <<END_SRC);
    public x
x:
END_SRC

unlink "$test.o";
capture_ok( "z88dk-z80asm $test.asm", "" );
ok -f "$test.o";

capture_ok("z88dk-z80asm -b $test.asm $test.1.asm", "");
check_bin_file("$test.bin", bytes(0x3A, 0x03, 0x00));

# ============================================================
#  END OF TEST SUITE
# ============================================================

unlink_testfiles;
done_testing;
