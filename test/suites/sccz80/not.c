#include "test.h"
#include <stdio.h>
#include <stdlib.h>


/** not.c test ! operator

  ANSI: return type is int

  attr: volatile,
*/

void
test_Not(void)
{
    signed char   sc;
  unsigned char   uc;
  unsigned int    ui;
  unsigned long   ul;

  sc = 0;
  uc = 0;
  ui = 0;
  ul = 0;
  /* remember: unsigned * signed -> unsigned */
  /*             signed * signed ->   signed */
  ASSERT(!(  signed char) 0 * -1 < 0);
  ASSERT(!(unsigned char) 0 * -1 < 0);
  ASSERT(!sc   * -1 < 0);
  ASSERT(!uc   * -1 < 0);
  ASSERT(! 0   * -1 < 0);
  ASSERT(! 0U  * -1 < 0);
  ASSERT(!ui   * -1 < 0);
  ASSERT(! 0L  * -1 < 0);
  ASSERT(! 0UL * -1 < 0);
  ASSERT(!ul   * -1 < 0);

  ASSERT(!(char) 0 <<  8 == 0x100);
  ASSERT(!sc       <<  8 == 0x100);
}

int suite_mult()
{
    suite_setup("Not Tests");

    suite_add_test(test_Not);

    return suite_run();
}


int main(int argc, char *argv[])
{
    int  res = 0;

    res += suite_mult();

    exit(res);
}
