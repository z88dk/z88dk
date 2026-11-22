/*
 * Command Line Processing Test
 *
 */

// zcc +cpm -vn -O3 -clib=new cmdline.c -o cmdline -create-app
// zcc +cpm -vn -SO3 -clib=sdcc_iy --max-allocs-per-node200000 cmdline.c -o cmdline -create-app

#include <stdio.h>

void main(int argc, char **argv)
{
   unsigned char i;
   
   printf("\nCommand line words: %u\n\n", argc);
   
   for (i=0; i<argc; ++i)
      printf("%u : %s\n", i+1, argv[i]);
}
