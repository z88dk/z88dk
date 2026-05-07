
#include <stdarg.h>

#include <stdio.h>


static char processed_chars[2];
static int local_use_cb;

int main()
{
	processed_chars[1] = 2;
    (void)fprintf (stdout, " %d-bit character%s", local_use_cb,
      (1 == processed_chars [0] && 0 == processed_chars [1]) ? "" : "s");
}
