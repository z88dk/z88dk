// memstream test program from C technical report

// zcc +cpm -vn -O3 -clib=new fmemopen.c -o fmemopen
// zcc +cpm -vn -SO3 -clib=sdcc_iy --max-allocs-per-node200000 fmemopen.c -o fmemopen

// zcc +zx -vn -O3 -clib=new fmemopen.c -o fmemopen
// zcc +zx -vn -SO3 -clib=sdcc_ix --reserve-regs-iy --max-allocs-per-node200000 fmemopen.c -o fmemopen
// appmake +zx -b fmemopen_CODE.bin -o fmem.tap --org 32768 --blockname fmem

#include <stdio.h>
#include <string.h>

static char buffer[] = "foobar";

int main(void)
{
   int ch;
   FILE *stream;

   stream = fmemopen(buffer, strlen(buffer), "r");

   if (stream == NULL)
      perror("fmemopen");
   else
   {
      while ((ch = fgetc(stream)) != EOF)
         printf("Got %c\n", ch);
         
      fclose(stream);
   }

   return 0;
}
