#include <stdio.h>
#include <libgen.h>
#include <arch/zx/esxdos.h>

#include "globals.h"
#include "option.h"
#include "path.h"

void option_print_path(void)
{
   unsigned char *p;
   
   printf("Path Walk\n\n");
   
   for (p = path_open(); p != 0; p = path_next())
   {
      if (*p == 0) continue;
      
      esx_f_chdir("/");
      printf("%s %s\n", esx_f_chdir(p) ? "X" : "O", p);
   }
   
   path_close();

   printf("\nDone\n");
}

void option_print_find_dirs(void)
{
   unsigned char *p;
   unsigned char  i;
   
   printf("Locating...\n\n");
   
   i = 0;
   for (p = path_open(); p != 0; p = path_next())
   {
      esx_f_chdir("/");
      if ((*p == 0) || esx_f_chdir(p)) continue;
      
      if ((fin = esx_f_open(basename(program_name), ESX_MODE_R | ESX_MODE_OPEN_EXIST)) != 0xff)
      {
         printf("%2u %s\n", ++i, p);
         esx_f_close(fin);
         fin = 0xff;
      }
   }
   
   path_close();

   printf("\nDone\n");
}
