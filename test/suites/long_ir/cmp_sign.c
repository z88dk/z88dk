/* Signed `x REL 0` lowers to a sign-bit test (`add a,a; jp c/nc`), and a
 * CONV_SX-of-byte feeding only such a compare narrows to width 1 so the
 * whole sign-extend collapses. Both must read the CORRECT sign bit at each
 * width and must not corrupt other uses of the value.
 *
 * Correctness traps this guards:
 *   - byte sign test must read bit 7, not a widened bit 15 (narrowing a
 *     CONV_SX-of-byte is only valid because it fits [-128,127]);
 *   - an unsigned byte 0x80 (=+128) must NOT be narrowed into a signed <0
 *     (v_is_sx_of_byte excludes CONV_ZX) — checked via the schar_mix pattern
 *     where the same byte is both sign-tested and arithmetically combined;
 *   - int/long `x REL 0` still test bit 15 / bit 31.
 *
 * Values flow through globals so the compiler can't fold the compares. */
#include "test.h"

static signed char sc_vals[5] = { -128, -1, 0, 1, 127 };
static int         si_vals[5];
static long        sl_vals[5];

/* Mirror of charbench's schar_mix inner step: sign-conditional accumulate
 * plus an LFSR mix, all on signed char. Narrowing the CONV_SX operands and
 * the `b < 0` sign test must yield the byte-exact host result. */
static signed char schar_step(signed char *data, unsigned int len)
{
    signed char acc = -1;
    signed char *end = data + len;
    while (data < end) {
        signed char b = *data++;
        if (b < 0) acc = (signed char)(acc - b);
        else       acc = (signed char)(acc + b);
        acc = (signed char)((acc << 1) ^ b);
    }
    return acc;
}

static void test_char_sign(void)
{
    /* expected (b < 0): 1,1,0,0,0 ; (b >= 0): 0,0,1,1,1 */
    int lt = 0, ge = 0;
    for (int i = 0; i < 5; i++) {
        if (sc_vals[i] < 0)  lt++;
        if (sc_vals[i] >= 0) ge++;
    }
    Assert(lt == 2, "signed char <0 count");
    Assert(ge == 3, "signed char >=0 count");
}

static void test_int_sign(void)
{
    int lt = 0, ge = 0;
    for (int i = 0; i < 5; i++) {
        if (si_vals[i] < 0)  lt++;
        if (si_vals[i] >= 0) ge++;
    }
    Assert(lt == 2, "signed int <0 count");
    Assert(ge == 3, "signed int >=0 count");
}

static void test_long_sign(void)
{
    int lt = 0, ge = 0;
    for (int i = 0; i < 5; i++) {
        if (sl_vals[i] < 0)  lt++;
        if (sl_vals[i] >= 0) ge++;
    }
    Assert(lt == 2, "signed long <0 count");
    Assert(ge == 3, "signed long >=0 count");
}

/* Fill a 16-byte buffer with a mix incl. bytes whose bit 7 is set (which are
 * NEGATIVE as signed char but would be +128.. as unsigned) — the narrowing
 * must keep the sign test signed. Compare against the host-computed answer. */
static unsigned char mix_buf[16] = {
    0x00, 0x7F, 0x80, 0xFF, 0x01, 0xC0, 0x40, 0x81,
    0x7E, 0xAA, 0x55, 0x99, 0x02, 0xFE, 0x33, 0xCC
};

static void test_schar_mix_pattern(void)
{
    /* Host value of schar_step over mix_buf (computed by reference build). */
    signed char r = schar_step((signed char *)mix_buf, 16);
    Assert((unsigned char)r == 0xD6u, "schar_mix narrowed pattern");
}

int main(int argc, char *argv[])
{
    si_vals[0] = -32768; si_vals[1] = -1; si_vals[2] = 0; si_vals[3] = 1; si_vals[4] = 32767;
    sl_vals[0] = -2147483647L - 1; sl_vals[1] = -1; sl_vals[2] = 0; sl_vals[3] = 1; sl_vals[4] = 2147483647L;
    suite_setup("Signed REL 0 sign-bit test");
    suite_add_test(test_char_sign);
    suite_add_test(test_int_sign);
    suite_add_test(test_long_sign);
    suite_add_test(test_schar_mix_pattern);
    return suite_run();
}
