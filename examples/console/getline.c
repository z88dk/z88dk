// zcc +zx -vn -clib=sdcc_iy -SO3 --max-allocs-per-node200000 getline.c -o getline -create-app
// zcc +zx -vn -clib=new getline.c -o getline -create-app

#pragma output printf = "%u %s"
#pragma output CLIB_STDIO_HEAP_SIZE = 0        // cannot open files

#include <stdio.h>

void main(void)
{
   unsigned char *line = 0;
   unsigned int len = 0;
   unsigned int slen;
   
   while (1)
   {
      printf("\nEnter line: ");
      
      fflush(stdin);
      slen = getline(&line, &len, stdin);
      
      printf("\nAllocated length = %u\n", len);
      
      if (slen != 0)
      {
         unsigned char term = line[slen - 1];
         
         printf("Terminating char = %u\n", (int)term);
         printf("\"%.*s\"\n", slen - (term == '\n'), line);
      }
   }
}
