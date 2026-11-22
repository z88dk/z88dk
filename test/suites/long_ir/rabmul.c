/* Rabbit's 16x16 multiply, on the path that actually ships.
 *
 * `l_mult` on Rabbit IS the hardware instruction — `ld bc,hl; mul; ld hl,bc;
 * ret` — so this is NOT a bit-serial helper. What used to cost was the CALL:
 * an opaque clobber that sent the product through a frame slot and read it
 * straight back. The copt rule in lib/arch/rabbit/rabbit_rules.1 elides that
 * reload, and that is what ships (adr/0075).
 *
 * Inlining the three instructions instead was built, measured and WITHDRAWN —
 * it exposed an allocator re-pick worth +10..13 % on listbench that has no
 * sound fix (three were tried). So what remains here is a multiply regression
 * test across z80, the three Rabbits and 8080-as-control, pinning that the
 * answers agree everywhere:
 *
 *  - bc_live      a value homed in BC held across a multiply and read after.
 *  - enigma       a condensed examples/console/enigma.c — real register
 *                 pressure around the multiply, which is what makes it worth
 *                 keeping: it is the shape that caught a copt fold applying
 *                 `pop bc; push hl` to a LIVE BC restore.
 *  - byte_ops     operands narrowed to width 1.
 *  - const_mul    x * K. Rabbit is excluded from constant-multiply strength
 *                 reduction because `mul` behind the call is still cheaper
 *                 than a shift chain; these pin that the exclusion lands
 *                 somewhere that works.
 *  - signed_mul   the low 16 bits of a product are sign-agnostic.
 *
 * Self-verifying against constants computed under the same 16-bit arithmetic,
 * and no printf (it perturbs allocation and can mask exactly this class of
 * bug).
 */
#include "test.h"

static unsigned int gk = 26u;
static unsigned char gtab[8] = { 3, 1, 4, 1, 5, 9, 2, 6 };

/* Inputs live in globals: a literal argument would be constant-folded and the
   multiply would never reach the IR builder at all. */
static unsigned int gn0, gn1, gn1a, gseed;
static int gsa, gsb, gsc, gs181, gsmin, gs1, gs300;

static void set_inputs(void)
{
    gn0 = 0u; gn1 = 1000u; gn1a = 1u; gseed = 12345u;
    gsa = -100; gsb = 7; gsc = -9; gs181 = 181;
    gsmin = (int)0x8000; gs1 = 1; gs300 = 300;   /* INT_MIN without the range warning */
}

/* A value that wants a BC home held ACROSS a multiply and read afterwards.
   `keep` is live from before the loop to after it, and the product is
   consumed each iteration, so the multiply sits inside keep's live range. */
static unsigned int bc_live(unsigned int n)
{
    unsigned int keep = n + 7u;
    unsigned int acc = 0;
    int i;

    for (i = 0; i < 6; i++) {
        acc = (unsigned int)(acc + (unsigned int)(gtab[i] * gk));
        acc ^= keep;                      /* keep must survive the multiply */
    }
    return (unsigned int)(acc + keep);
}

/* Condensed enigma: three rotors forward, reflector, three back, stepping the
   rotor positions per character. `rotor[((order[i] - 1) * 26) + ch - 'A']` is
   the multiply, and the surrounding pressure is what parks its product on the
   stack. Tables are enigma.c's. */
static const unsigned char rotor[] =
    "EKMFLGDQVZNTOWYHXUSPAIBRCJ"
    "AJDKSIRUXBLHWTMCQGZNPYFVOE"
    "BDFHJLCPRTXVZNYEIWGAKMUSQO"
    "ESOVPZJAYQUIRHXLNFTGKDCMWB"
    "VZBRGITYUPSDNHLXAWMJQOFECK";
static const unsigned char ref[]   = "YRUHQSLDPXNGOKMIEBFZCWVJAT";
static const unsigned char notch[] = "QEVJZ";
static const unsigned char order[3] = { 3, 1, 2 };
static const unsigned char rings[3] = { 'W', 'X', 'T' };
static const unsigned char plug[]   = "AMTE";
static unsigned char pos[3];
static unsigned char out[8];

static unsigned int enigma(const unsigned char *in, int len)
{
    unsigned int sum = 0;
    int i, j, ch, flag = 0, posn = 0;

    pos[0] = 'A'; pos[1] = 'W'; pos[2] = 'E';

    while (posn < len) {
        ch = in[posn];
        pos[0]++;
        if (pos[0] > 'Z') pos[0] -= 26;
        if (flag) {
            pos[1]++; if (pos[1] > 'Z') pos[1] -= 26;
            pos[2]++; if (pos[2] > 'Z') pos[2] -= 26;
            flag = 0;
        }
        if (pos[0] == notch[order[0] - 1]) {
            pos[1]++; if (pos[1] > 'Z') pos[1] -= 26;
            if (pos[1] == notch[order[1] - 1]) flag = 1;
        }
        for (i = 0; plug[i]; i += 2) {
            if (ch == plug[i]) ch = plug[i + 1];
            else if (ch == plug[i + 1]) ch = plug[i];
        }
        for (i = 0; i < 3; i++) {                      /* rotors forward */
            ch += pos[i] - 'A';   if (ch > 'Z') ch -= 26;
            ch -= rings[i] - 'A'; if (ch < 'A') ch += 26;
            ch = rotor[((order[i] - 1) * 26) + ch - 'A'];
            ch += rings[i] - 'A'; if (ch > 'Z') ch -= 26;
            ch -= pos[i] - 'A';   if (ch < 'A') ch += 26;
        }
        ch = ref[ch - 'A'];                            /* reflector */
        for (i = 3; i > 0; i--) {                      /* rotors back */
            ch += pos[i - 1] - 'A';   if (ch > 'Z') ch -= 26;
            ch -= rings[i - 1] - 'A'; if (ch < 'A') ch += 26;
            for (j = 0; j < 26; j++)
                if (rotor[(26 * (order[i - 1] - 1)) + j] == ch) { ch = j + 'A'; break; }
            ch += rings[i - 1] - 'A'; if (ch > 'Z') ch -= 26;
            ch -= pos[i - 1] - 'A';   if (ch < 'A') ch += 26;
        }
        out[posn] = (unsigned char)ch;
        sum = (unsigned int)(sum * 31u + (unsigned int)ch);
        posn++;
    }
    return sum;
}

/* Byte-width operands: both sources narrow to width 1. */
static unsigned int byte_ops(void)
{
    unsigned int acc = 0;
    int i;
    for (i = 0; i < 7; i++)
        acc = (unsigned int)(acc + (unsigned int)(gtab[i] * gtab[i + 1]));
    return acc;
}

/* Constant multiplies, including the LCG constant whose shift-add chain the
   !IS_RABBIT() gate declines to build. */
static unsigned int const_mul(unsigned int seed)
{
    unsigned int a = (unsigned int)(seed * 25173u);
    unsigned int b = (unsigned int)(seed * 181u);
    unsigned int c = (unsigned int)(seed * 3u);
    unsigned int d = (unsigned int)(seed * 6u);
    return (unsigned int)(a ^ b ^ c ^ d);
}

/* Signed products: the low 16 bits of BC*DE are sign-agnostic, which is the
   claim that lets one instruction serve both signednesses. */
static int signed_mul(int a, int b)
{
    return a * b;
}

static void test_bc_live(void)
{
    Assert(bc_live(gn0) == 593u, "bc_live(0)");
    Assert(bc_live(gn1) == 1065u, "bc_live(1000)");
}

static void test_enigma(void)
{
    static const unsigned char msg[] = "HELLO";
    unsigned int sum = enigma(msg, 5);

    /* Expectations taken from the z80 build, which never goes near this rung
       — every CPU agrees, which is what makes them the control. (The letters
       are not enigma.c's RXSEC: this version steps the rotors from index 0 and
       does not uppercase, so it is the same algorithm on a different phase.) */
    Assert(out[0] == 'R', "enigma[0]");
    Assert(out[1] == 'X', "enigma[1]");
    Assert(out[2] == 'S', "enigma[2]");
    Assert(out[3] == 'T', "enigma[3]");
    Assert(out[4] == 'C', "enigma[4]");
    Assert(sum == 51708u, "enigma checksum");
}

static void test_byte_ops(void)
{
    Assert(byte_ops() == 91u, "byte_ops");
}

static void test_const_mul(void)
{
    Assert(const_mul(gn1a) == 25317u, "const_mul(1)");
    Assert(const_mul(gseed) == 32093u, "const_mul(12345)");
}

static void test_signed_mul(void)
{
    Assert(signed_mul(gsa, gsb) == -700, "-100*7");
    Assert(signed_mul(gsa, gsc) == 900, "-100*-9");
    Assert(signed_mul(gs181, gs181) == 32761, "181*181");
    Assert(signed_mul(gsmin, gs1) == -32768, "-32768*1");
    Assert(signed_mul(gs300, gs300) == 24464, "300*300 wraps");
}

int main(void)
{
    set_inputs();
    suite_setup("rabbit hardware multiply");
    suite_add_test(test_bc_live);
    suite_add_test(test_enigma);
    suite_add_test(test_byte_ops);
    suite_add_test(test_const_mul);
    suite_add_test(test_signed_mul);
    return suite_run();
}
