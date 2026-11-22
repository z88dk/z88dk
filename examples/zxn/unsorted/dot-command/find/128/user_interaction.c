#include <stdio.h>
#include <stdlib.h>
#include <input.h>

#include "errors.h"
#include "user_interaction.h"

void user_interaction(void)
{
   if (in_key_pressed(IN_KEY_SCANCODE_SPACE | 0x8000))
   {
      puts("<break>");

      in_wait_nokey();
      exit((int)err_break_into_program);
   }
}

static unsigned char cpos;
static unsigned char cursor[] = "-\\|/";

void user_interaction_spin_report(unsigned char level)
{
   printf("%03u %c" "\x08\x08\x08\x08\x08", level, cursor[cpos]);
   if (++cpos >= (sizeof(cursor) - 1)) cpos = 0;

   user_interaction();
}
