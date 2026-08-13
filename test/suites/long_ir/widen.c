/* Widening assignment into a LOCAL integer of larger width. build_assign's
   scalar-local path emitted a bare MOV(dst) <- rhs without converging widths,
   so `long i = <int expr>` copied only the low 2 bytes and left the high half
   unset — a silent miscompile for a slot-resident int source, and a hard abort
   ("value read with no live register and no stack slot") when the source was
   register-resident (notably a const-multiply strength-reduce result, which
   surfaced in umaxd.c:59 `i = 99 * w[t&7]`). Now the local path sign/zero-
   extends like the global store path. All products chosen to fit in a 16-bit
   int so the widen — not int overflow — is what's under test. */
#include "test.h"

int          t;
unsigned int ut;
char         sc;
unsigned char uc;

static void test_int_to_long(void)
{
    long i;
    t = -5;   i = t;         Assert(i == -5L,    "int -5 -> long");
    t = 12345; i = t;        Assert(i == 12345L, "int 12345 -> long");
    t = -1;   i = t;         Assert(i == -1L,    "int -1 -> long (sign)");
}

static void test_const_mult_to_long(void)
{
    long i;
    t = -5;  i = 99 * t;     Assert(i == -495L,  "99*-5 -> long (Horner SR)");
    t = 30;  i = 1000 * t;   Assert(i == 30000L, "1000*30 -> long (SR)");
    t = 7;   i = 3 * t;      Assert(i == 21L,    "3*7 -> long (SR)");
    t = -8;  i = 100 * t;    Assert(i == -800L,  "100*-8 -> long (SR)");
}

static void test_unsigned_and_char_to_long(void)
{
    long i; unsigned long u;
    ut = 60000u; u = ut;     Assert(u == 60000UL, "uint -> ulong (zero-ext)");
    sc = -3;  i = sc;        Assert(i == -3L,     "schar -> long (sign)");
    uc = 200; i = uc;        Assert(i == 200L,    "uchar -> long (zero)");
    t = -2;   i = t * t;     Assert(i == 4L,      "int mult -> long (helper)");
    t = 9;    i = -t;        Assert(i == -9L,     "neg int -> long");
}

int main(int argc, char *argv[])
{
    suite_setup("widening assignment to local");
    suite_add_test(test_int_to_long);
    suite_add_test(test_const_mult_to_long);
    suite_add_test(test_unsigned_and_char_to_long);
    return suite_run();
}
