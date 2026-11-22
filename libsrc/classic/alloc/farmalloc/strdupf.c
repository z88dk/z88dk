#include <stdlib.h>
#include <string.h>


char *__far strdupf(const char *__far orig) __z88dk_saveframe
{
   char *__far ptr;

   ptr=malloc_far(strlenf(orig) + 1);

   if (ptr) {
           strcpyf(ptr,orig);
   }
   return (ptr);
}

