/* An inlined memcpy/strcpy returns its destination. In an IX-framed function
 * (-fframe-pointer, no sp-flip) the destination is kept in BC across the copy
 * (`push bc; ld bc,N; ldir; pop bc`), and a copt rule dropped the `pop bc` that
 * sits before `ld hl,bc; ld sp,ix`, so the function returned the clobbered BC. */
#include "test.h"
#include <string.h>

static unsigned char m_a[40], m_b[40];
static char sbuf[16];
static unsigned char *gp;

static void *t1(unsigned char *d, void *s) { return memcpy(d + 4, s, 20); }
static void *t2(void *s) { return memcpy(gp, s, 20); }
static char *t3(char *d, char *s) { return strcpy(d + 2, s); }
static void *t4(void *s) { unsigned char *d = gp + 1; return memcpy(d, s, 20); }
static void *t5(void *d, void *s) { void *r = memcpy(d, s, 20); return r; }

void test_ixblockcopy(void)
{
    gp = m_a;
    assertEqual(t1(m_a, m_b) == (void *)(m_a + 4), 1);
    assertEqual(t2(m_b) == (void *)m_a, 1);
    assertEqual(t3(sbuf, "hi") == sbuf + 2, 1);
    assertEqual(t4(m_b) == (void *)(m_a + 1), 1);
    assertEqual(t5(m_a, m_b) == (void *)m_a, 1);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("IX-frame inlined block copy return value");
    suite_add_test(test_ixblockcopy);
    return suite_run();
}
