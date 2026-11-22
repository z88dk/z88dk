/* [l-call-flags] A call to an l_* runtime helper does not read the flags.
 *
 * No l_* helper 80cc emits reads the flags on entry, so the backward sweep
 * now treats `call l_*` as killing F, like a call to C code. That lets an
 * F-gated rewrite fire just before one: on the 8085, `ld hl,N; add hl,sp`
 * becomes `ld de,sp+N; ex de,hl`, which leaves the carry alone.
 *
 *  - mix       fires on 8085: a byte parked in a slot just before the
 *              variable shift `l_asr_u`. Checked over every shift count.
 *  - lmix      the same with the 32-bit `l_lsr_dehl`.
 *
 * Every CPU builds it; _keep runs the 8085 opt-out.
 */
#include "test.h"

static unsigned int sink;

static unsigned int mix(unsigned int v, unsigned int w, unsigned char n)
{
    unsigned char t = (unsigned char)(v << n);

    sink += t;
    return (w >> n) + t;
}

static unsigned long lmix(unsigned long v, unsigned char k, unsigned char n)
{
    unsigned char t = (unsigned char)(k << 1);

    sink += t;
    return (v >> n) + t;
}

void test_lcallflags(void)
{
    unsigned char n;
    unsigned int acc = 0;
    unsigned long lacc = 0;

    for (n = 0; n < 16; n++)
        acc += mix(0x1234u + n, 0xf00du, n);
    for (n = 0; n < 32; n++)
        lacc += lmix(0x89abcdefUL, (unsigned char)(n * 7u), n);
    assertEqual(acc, 0xe3e1u);
    assertEqual(lacc, 0x1357a9eaUL);
}

int suite_lcallflags(void)
{
    suite_setup("l_* call flag liveness");
    suite_add_test(test_lcallflags);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;

    res += suite_lcallflags();
    exit(res);
}
