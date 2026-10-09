/* long + constant where the constant fits 16 bits, or is a small negative:
 * the high word only takes the carry out of the low add.
 */
#include "test.h"

static long add3(long x)      { return x + 3; }
static long add65535(long x)  { return x + 65535L; }
static long addm3(long x)     { return x + -3; }
static long addm65536(long x) { return x + -65536L; }
static long add65536(long x)  { return x + 65536L; }
static unsigned long uadd5(unsigned long x) { return x + 5; }
static unsigned long uaddm1(unsigned long x) { return x + 0xFFFFFFFFUL; }
static long sub3(long x)      { return x - 3; }
static long sub65535(long x)  { return x - 65535L; }
static unsigned long usub5(unsigned long x) { return x - 5; }
long g;
static void gadd(void)        { g += 7; }

static void check(void)
{
    assertEqual(add3(0L), 3L);
    assertEqual(add3(0xFFFDL), 0x10000L);
    assertEqual(add3(0x1FFFFL), 0x20002L);
    assertEqual(add3(-3L), 0L);
    assertEqual(add3(-1L), 2L);
    assertEqual(add65535(1L), 0x10000L);
    assertEqual(add65535(0x10001L), 0x20000L);
    assertEqual(add65535(0L), 65535L);
    assertEqual(addm3(3L), 0L);
    assertEqual(addm3(0x10000L), 0xFFFDL);
    assertEqual(addm3(0L), -3L);
    assertEqual(addm3(0x20001L), 0x1FFFEL);
    assertEqual(addm65536(0x20000L), 0x10000L);
    assertEqual(addm65536(5L), -65531L);
    assertEqual(add65536(0xFFFFL), 0x1FFFFL);
    assertEqual(uadd5(0xFFFFFFFFUL), 4UL);
    assertEqual(uadd5(0xFFFBUL), 0x10000UL);
    assertEqual(uaddm1(0UL), 0xFFFFFFFFUL);
    assertEqual(uaddm1(1UL), 0UL);
    assertEqual(uaddm1(0x10000UL), 0xFFFFUL);
    assertEqual(sub3(3L), 0L);
    assertEqual(sub3(0x10000L), 0xFFFDL);
    assertEqual(sub3(0L), -3L);
    assertEqual(sub3(0x20001L), 0x1FFFEL);
    assertEqual(sub65535(0x10000L), 1L);
    assertEqual(sub65535(0L), -65535L);
    assertEqual(sub65535(65535L), 0L);
    assertEqual(usub5(3UL), 0xFFFFFFFEUL);
    assertEqual(usub5(0x10002UL), 0xFFFDUL);
    g = 0xFFFAL; gadd();
    assertEqual(g, 0x10001L);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("long plus or minus a 16-bit constant");
    suite_add_test(check);
    return suite_run();
}
