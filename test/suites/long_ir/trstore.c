/* [trunc-store-bc] [sink-trunc] [ivsr-suppress-lea] A byte store of a truncated
 * word counter: the byte comes straight from C, the local array is addressed
 * from the frame, and the shapes that must keep the generic path stay right. */
#include "test.h"


static unsigned int fill_local(void)
{
    unsigned char m[300];
    unsigned int i, s = 0;
    for (i = 0; i < 300; i++) m[i] = (unsigned char)i;
    for (i = 0; i < 300; i += 37) s += m[i];
    return s + m['o'] + m[299];
}

static unsigned int fill_ptr(unsigned char *p, unsigned int n)
{
    unsigned int i, s = 0;
    for (i = 0; i < n; i++) p[i] = (unsigned char)(i * 3);
    for (i = 0; i < n; i++) s += p[i];
    return s;
}

/* the truncated byte is read twice */
static unsigned int twice(void)
{
    unsigned char m[40], k;
    unsigned int i, s = 0;
    for (i = 0; i < 40; i++) { k = (unsigned char)(i + 5); m[i] = k; s += k; }
    return s + m[39];
}

/* store at a nonzero offset, and a store whose index is the truncated value */
static unsigned int offs(void)
{
    unsigned char m[64];
    unsigned int i, s = 0;
    for (i = 0; i < 64; i++) m[i] = 0;
    for (i = 0; i < 20; i++) { m[i + 3] = (unsigned char)(i * 7); m[(unsigned char)(i * 2)] ^= (unsigned char)i; }
    for (i = 0; i < 64; i++) s += m[i] * (i + 1);
    return s;
}

static void test_trstore(void)
{
    unsigned char big[100];
    unsigned int i, e;
    assertEqual(fill_local(), 974U);
    for (i = 0, e = 0; i < 50; i++) e += (unsigned char)(i * 3);
    assertEqual(fill_ptr(big, 50), e);
    for (i = 0, e = 0; i < 40; i++) e += (unsigned char)(i + 5);
    assertEqual(twice(), e + 44U);
    assertEqual(offs(), 26662U);
}

int suite_trstore(void) { suite_setup("trunc store from BC"); suite_add_test(test_trstore); return suite_run(); }
int main(void) { return suite_trstore(); }
