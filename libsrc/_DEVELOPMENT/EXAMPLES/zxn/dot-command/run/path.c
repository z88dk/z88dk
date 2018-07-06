#include <string.h>
#include <libgen.h>

#include "globals.h"
#include "path.h"

char *path_open(void)
{
   unsigned char *p;
   
   if (p = strtok(PATH, ":;"))
      return pathnice(p);

   return 0;
}

char *path_next(void)
{
   unsigned char *p;
   
   if (p = strtok(0, ":;"))
      return pathnice(p);
   
   return 0;
}
