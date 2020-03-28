#include <stdio.h>
#include <stdlib.h>
#include <input.h>

#include "user_interaction.h"

extern int error(char *fmt, ...);

void user_interaction(void)
{
   if (in_key_pressed(IN_KEY_SCANCODE_SPACE | 0x8000))
   {
      puts("<break>");

      in_wait_nokey();
      exit(error("D BREAK - no repeat"));
   }
}
