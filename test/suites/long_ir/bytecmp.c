/* Byte compares against byte-range constants, and branch-lowered mixed-polarity
 * conditions — the char-classification idiom (lexers, parsers, ctype).
 *
 * Two coordinated codegen paths under test:
 *   1. build_binop_integer keep_byte_cmp: an unsigned char compared to a
 *      constant in [0,255] (`c == ' '`, `c >= '0'`) stays a byte `cp` instead of
 *      widening c to int for a 16-bit `sbc hl,de` — C promotion is value-
 *      preserving for a byte-range constant. (EQ/NE and ULT/UGE, unsigned LHS.)
 *   2. build_cond mixed-polarity branch-lowering: a polarity-flipped nested
 *      logical — `(c>='a' && c<='z') || …` (`&&` under `||`) or `||` under `&&`
 *      — branch-lowers via a continuation block so every leaf compare stays
 *      branch-fused (byte cp), instead of the old "value leaf" that materialised
 *      each nested compare as a widened 0/1 boolean.
 * Checksums are host-verified and width-independent. */
#include "test.h"

/* the classic 4-way classifier: exercises == chains, range tests, and the
   (a&&b)||(c&&d)||e mixed-polarity condition all at once. */
static int classify(unsigned char c)
{
    if (c == ' ' || c == '\t' || c == '\n' || c == '\r') return 0;
    if ((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || c == '_') return 1;
    if (c >= '0' && c <= '9') return 2;
    return 3;
}

/* Plain (signed-by-default) char EQ/NE against printable literals: narrows to a
   byte `cp` (bias-free) even though the char is signed. */
static int sclass(char c)
{
    if (c == ' ' || c == '\t' || c == '\n') return 0;
    if (c == '_' || c == '.') return 1;
    if (c != '?') return 2;
    return 3;
}

/* Signed-char relational narrowing (the +128 bias path): all four relations
   plus negative constants, exercised over the whole signed range. */
static int sr_lt32(signed char c)  { return c < 32; }
static int sr_ge48(signed char c)  { return c >= 48; }
static int sr_le122(signed char c) { return c <= 122; }
static int sr_gt65(signed char c)  { return c > 65; }
static int sr_ltn10(signed char c) { return c < -10; }
static int sr_gen5(signed char c)  { return c >= -5; }

/* `||` under `&&` (the mirror polarity flip): printable-and-not-vowel. */
static int cons(unsigned char c)
{
    return (c >= 'a' && c <= 'z')
        && !(c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u');
}

static void bc_run(void)
{
    Assert(classify(' ')  == 0, "space -> ws");
    Assert(classify('\t') == 0, "tab -> ws");
    Assert(classify('\n') == 0, "nl -> ws");
    Assert(classify('m')  == 1, "m -> alpha");
    Assert(classify('Z')  == 1, "Z -> alpha");
    Assert(classify('_')  == 1, "_ -> alpha");
    Assert(classify('0')  == 2, "0 -> digit");
    Assert(classify('9')  == 2, "9 -> digit");
    Assert(classify('!')  == 3, "! -> punct");
    Assert(classify('~')  == 3, "~ -> punct");
    Assert(classify((unsigned char)0x80) == 3, "high byte -> punct");
    Assert(classify((unsigned char)0xFF) == 3, "0xFF -> punct (no 16-bit alias)");

    Assert(sclass(' ') == 0, "signed char space");
    Assert(sclass('_') == 1, "signed char _");
    Assert(sclass('x') == 2, "signed char x (!= '?')");
    Assert(sclass('?') == 3, "signed char ?");
    Assert(sclass((char)0x80) == 2, "signed char high byte (!= '?', no alias)");

    {
        unsigned int h = 0; int v;
        for (v = -128; v < 128; v++) {
            signed char c = (signed char)v;
            h = (unsigned int)((h * 31u + (unsigned int)sr_lt32(c))  & 0xffffu);
            h = (unsigned int)((h * 31u + (unsigned int)sr_ge48(c))  & 0xffffu);
            h = (unsigned int)((h * 31u + (unsigned int)sr_le122(c)) & 0xffffu);
            h = (unsigned int)((h * 31u + (unsigned int)sr_gt65(c))  & 0xffffu);
            h = (unsigned int)((h * 31u + (unsigned int)sr_ltn10(c)) & 0xffffu);
            h = (unsigned int)((h * 31u + (unsigned int)sr_gen5(c))  & 0xffffu);
        }
        Assert(h == 64354u, "signed-char relational over -128..127 (host-verified)");
    }

    Assert(cons('b') == 1, "b consonant");
    Assert(cons('e') == 0, "e vowel");
    Assert(cons('z') == 1, "z consonant");
    Assert(cons('A') == 0, "A not lowercase");

    /* histogram over all 256 byte values — pins the boundary behaviour of every
       range/eq test and the byte-vs-16-bit distinction (0x80..0xFF must not
       alias into the ASCII ranges). */
    {
        unsigned int h = 0; int v;
        for (v = 0; v < 256; v++)
            h = (unsigned int)((h * 31u + (unsigned int)classify((unsigned char)v)) & 0xffffu);
        Assert(h == 49502u, "classify histogram over 0..255 (host-verified)");
    }
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("byte compare + mixed-polarity conditions");
    suite_add_test(bc_run);
    return suite_run();
}
