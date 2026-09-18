/* [ldsi-addr] 8085 slot-address formation via LDSI.
 *
 * `ld hl,N; add hl,sp` (4 B, 20 cyc) becomes `ld de,sp+N; ex de,hl` (3 B, 14)
 * — but only when three things hold. This test is mostly about the shapes where
 * they do NOT, because each one fails SILENTLY: the wrong answer is a plausible
 * number, not a crash.
 *
 *  - de_dead     DE is dead across the address formation. The rung may fire.
 *                Pins that it still computes the right address.
 *  - de_live     a value is held in a register pair across the address
 *                formation and used after it. `ex de,hl` is a SWAP, so if the
 *                rung fires here the live value is replaced by the old HL and
 *                the sum is wrong.
 *  - carry_live  the address formation sits between a subtraction and the use
 *                of its borrow. `add hl,sp` WRITES CARRY; the LDSI pair does
 *                not. If the rung fires, the flag read afterwards is stale.
 *  - big_frame   a frame large enough to push slot offsets past 255, which is
 *                LDSI's whole operand range (one unsigned byte —
 *                `sp + get_memory_inst(pc++)` in src/ticks/i8085_inst.c).
 *                Over-applying wraps the offset and reads the wrong slot.
 *
 * Runs on every CPU: 8080/gbz80/rabbit have no LDSI and must be unaffected,
 * which makes them the control. Self-verifying against constants computed under
 * identical 16-bit arithmetic, and no printf (it perturbs allocation and can
 * mask exactly this class of bug — see the enigma family).
 */
#include "test.h"

static unsigned int g_sink;
static void sink(unsigned int x) { g_sink += x; }

/* DE dead across the address formation: the rung is free to fire. Several
   scalar members of a local struct updated in a loop — each update forms its
   own slot address, and the values themselves live in A/HL, so DE is dead
   between them. This is the shape that converts in the corpus (localbench
   `record`); an array indexed by a loop variable is NOT, because the index
   keeps DE busy. */
struct rec4 { int a, b, c, d; };

static unsigned int de_dead(unsigned int n)
{
    struct rec4 r;
    int i;

    r.a = (int)(n & 255u);
    r.b = (int)((n >> 4) & 255u);
    r.c = (int)((n >> 8) & 255u);
    r.d = 0;

    for (i = 0; i < 8; i++) {
        r.d = (r.d + r.a) & 4095;
        r.a = (r.a ^ r.b) & 255;
        r.b = (r.b + r.c + i) & 255;
        r.c = (r.c ^ r.d) & 255;
    }
    return (unsigned int)((r.a + r.b + r.c + r.d) & 0xffff);
}

/* A value must survive the address formation. If `ex de,hl` fires with DE live,
   `keep` comes back as a slot address instead of its value. */
static unsigned int de_live(unsigned int n)
{
    unsigned int a[4];
    unsigned int keep = n * 3u + 11u;
    unsigned int i, s = 0;
    for (i = 0; i < 4; i++) a[i] = (unsigned int)(i + n);
    for (i = 0; i < 4; i++) s += a[i] + keep;
    return s + keep;
}

/* The borrow from the subtraction must survive the address formation. */
static unsigned int carry_live(unsigned int x, unsigned int y)
{
    unsigned int buf[4];
    unsigned int i, s = 0;
    int borrow = (x < y);
    for (i = 0; i < 4; i++) buf[i] = x + i;
    for (i = 0; i < 4; i++) s += buf[i];
    return borrow ? (s + 1u) : s;
}

/* Frame bigger than LDSI's 0..255 operand range. */
static unsigned int big_frame(unsigned int n)
{
    unsigned int big[150];
    unsigned int i, s = 0;
    for (i = 0; i < 150; i++) big[i] = (unsigned int)(i ^ n);
    for (i = 0; i < 150; i += 15) s += big[i];
    s += big[149];
    return s;
}

void test_ldsiaddr(void)
{
    assertEqual(de_dead(0),   138u);
    assertEqual(de_dead(5),   676u);
    assertEqual(de_dead(100), 862u);

    assertEqual(de_live(0),   61u);
    assertEqual(de_live(7),   194u);

    assertEqual(carry_live(3, 9), 19u);
    assertEqual(carry_live(9, 3), 42u);

    assertEqual(big_frame(0), 824u);
    assertEqual(big_frame(3), 825u);

    sink(de_dead(1));
    sink(de_live(1));
    assertEqual(g_sink, 388u);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("8085 LDSI slot-address formation");
    suite_add_test(test_ldsiaddr);
    return suite_run();
}
