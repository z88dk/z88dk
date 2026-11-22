#include <stdlib.h>
#include <string.h>
#include <errno.h>

#include "error.h"
#include "option.h"
#include "run.h"

// option arguments 

unsigned char option_unsigned_number(unsigned char *p, unsigned int *res)
{
   static unsigned char *endp;

   if (p && *p)
   {
      unsigned int num;

      errno = 0;
      num = _strtou_(p, &endp, 0);
      
      if ((errno == 0) && (*endp == 0))
      {
         *res = num;
         return 1;
      }
   }
   
   return 0;
}

// options

// cd

unsigned int option_exec_cd(void)
{
   flags.option |= FLAG_OPTION_CD;
   return OPT_ACTION_OK;
}

// cwd

unsigned int option_exec_cwd(void)
{
   flags.option |= FLAG_OPTION_CWD;
   return OPT_ACTION_OK;
}

// ?

unsigned int option_exec_question(void)
{
   flags.option |= (FLAG_OPTION_Q | FLAG_OPTION_CWD);
   return OPT_ACTION_OK;
}

// path

unsigned int option_exec_path(void)
{
   flags.option |= (FLAG_OPTION_PATH | FLAG_OPTION_CWD);
   return OPT_ACTION_OK;
}
