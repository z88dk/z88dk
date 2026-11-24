/* A float literal cast to an integer type folds at compile time. It used to
 * be a runtime dload + ifix, which needs the double library linked (fix16's
 * FIX16_FROM_FLOAT constants made libsrc objects reference ifix, undefined
 * under -lm). The makefile rule also checks the asm for the runtime helpers. */
#include <stdint.h>
#include "test.h"

static int      c_int(void)   { return (int)(0.4426950408889634074 * 65536.0 + 0.5); }
static int      c_neg(void)   { return (int)-2.75; }
static long     c_long(void)  { return (long)(2.5 * 1000.0); }
static unsigned c_uint(void)  { return (unsigned)40000.9; }
static uint8_t  c_byte(void)  { return (uint8_t)200.5; }

static void casts(void)
{
    assertEqual(c_int(), 29012);
    assertEqual(c_neg(), -2);
    assertEqual(c_long() == 2500L, 1);
    assertEqual(c_uint() == 40000u, 1);
    assertEqual(c_byte(), 200);
}

int main(int argc, char *argv[])
{
    (void)argc; (void)argv;
    suite_setup("float literal cast to integer");
    suite_add_test(casts);
    return suite_run();
}
