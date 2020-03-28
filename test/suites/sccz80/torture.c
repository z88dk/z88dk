#include "test.h"
#include <stdio.h>
#include <stdlib.h>

struct barstruct { char const * some_string; } x;

void
foo(void)
{
  if (!x.some_string)
    ASSERT (0);
}
void baz(int b)
{
  struct barstruct bar;
  struct barstruct* barptr;
  if (b)
    barptr = &bar;
  else
    {
      barptr = &x + 1;
      barptr = barptr - 1;
    }
  barptr->some_string = "Everything OK";
  foo();
  barptr->some_string = "Everything OK";
}

void test_torture_struct1(void)
{
  x.some_string = (void *)0;
  baz(0);
  if (!x.some_string)
    ASSERT (0);
  return;
}

int suite_torture()
{
    suite_setup("GCC Torture Tests");

    suite_add_test(test_torture_struct1);

    return suite_run();
}


int main(int argc, char *argv[])
{
    int  res = 0;

    res += suite_torture();

    exit(res);
}
