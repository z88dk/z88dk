/* [fuzz-found] a store through a pointer to a frame slot left a register claiming the slot's old value.
 * Reduced program from the differential fuzzer. The body must stay in main (exempt
 * from the fp-to-sp frame flip; the bug did not reproduce from an ordinary function).
 */
#include "test.h"

static unsigned short result;

static void check(void)
{
    assertEqual(result, 7232);
}

int main(int argc, char *argv[])
{
  (void)argc; (void)argv;

  unsigned short a = 40000;
  unsigned short *p = &a;
  *p = (unsigned short)(((unsigned short)((65535) >> (3))) & ((unsigned short)(((unsigned short)*p) & ((unsigned short)a))));
  result = a;
  suite_setup("fuzz reproducer 2496");
  suite_add_test(check);
  return suite_run();
}
