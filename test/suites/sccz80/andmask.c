#include "test.h"
#include <stdlib.h>

unsigned ff00(unsigned x) { return x & 0xff00; }
unsigned lo(unsigned x) { return x & 0x00ff; }
unsigned all16(unsigned x) { return x & 0xffff; }
unsigned nib(unsigned x) { return x & 0x00f0; }
unsigned mix16(unsigned x) { return x & 0xf0ff; }
unsigned fe(unsigned x) { return x & 0xfffe; }

unsigned long b0(unsigned long x) { return x & 0x000000ffUL; }
unsigned long b1(unsigned long x) { return x & 0x0000ff00UL; }
unsigned long b2(unsigned long x) { return x & 0x00ff0000UL; }
unsigned long hi(unsigned long x) { return x & 0xffff0000UL; }
unsigned long alt(unsigned long x) { return x & 0xff00ff00UL; }
unsigned long alt2(unsigned long x) { return x & 0x00ff00ffUL; }
unsigned long top(unsigned long x) { return x & 0xff000000UL; }
unsigned long keep3(unsigned long x) { return x & 0x00ffffffUL; }
unsigned long drop0(unsigned long x) { return x & 0xffffff00UL; }
unsigned long partial(unsigned long x) { return x & 0x0fffffffUL; }

void test_and_whole_byte(void)
{
    unsigned x = 0xabcd;
    unsigned long y = 0x89abcdefUL;

    assertEqual(ff00(x), 0xab00);
    assertEqual(lo(x), 0x00cd);
    assertEqual(all16(x), 0xabcd);
    assertEqual(nib(x), 0x00c0);
    assertEqual(mix16(x), 0xa0cd);
    assertEqual(fe(x), 0xabcc);
    assertEqual(ff00(0x8000), 0x8000);
    assertEqual(lo(0x8000), 0);

    assertEqual(b0(y), 0x000000efUL);
    assertEqual(b1(y), 0x0000cd00UL);
    assertEqual(b2(y), 0x00ab0000UL);
    assertEqual(hi(y), 0x89ab0000UL);
    assertEqual(alt(y), 0x8900cd00UL);
    assertEqual(alt2(y), 0x00ab00efUL);
    assertEqual(top(y), 0x89000000UL);
    assertEqual(keep3(y), 0x00abcdefUL);
    assertEqual(drop0(y), 0x89abcd00UL);
    assertEqual(partial(y), 0x09abcdefUL);
    assertEqual(b2(0x80000000UL), 0);
    assertEqual(top(0x80000000UL), 0x80000000UL);
}

int suite_andmask(void)
{
    suite_setup("Whole byte masks");
    suite_add_test(test_and_whole_byte);
    return suite_run();
}

int main(int argc, char *argv[])
{
    int res = 0;

    (void)argc;
    (void)argv;
    res += suite_andmask();
    exit(res);
}
