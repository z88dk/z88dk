/* [fuzz-found] an address-taken local was proved byte-sized from its definitions, then rewritten through a pointer.
 * Reduced program from the differential fuzzer. The body must stay in main (exempt
 * from the fp-to-sp frame flip; the bug did not reproduce from an ordinary function).
 */
#include "test.h"

unsigned char gb = 64;
static unsigned short result;

static void check(void)
{
    assertEqual(result, 63);
}

int main(int argc, char *argv[])
{
  (void)argc; (void)argv;

  unsigned short a = 2, b = 65535;
  unsigned short *p = &a;
  *p ^= (unsigned short)(((unsigned short)*p) * ((unsigned short)b));
  gb += (unsigned short)(((unsigned short)a) >> (2));
  result = gb;
  suite_setup("fuzz reproducer 2734");
  suite_add_test(check);
  return suite_run();
}
