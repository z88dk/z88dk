/*
 * TOUCH update listed files to the current date and time
 * aralbrec @ z88dk.org
*/

// ZX SPECTRUM
//
// zcc +zx -vn -startup=30 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 --opt-code-size touch.c -o touch -subtype=dot -create-app
// zcc +zx -vn -startup=30 -clib=new touch.c -o touch -subtype=dot -create-app

// ZX NEXT
//
// zcc +zxn -vn -startup=30 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 --opt-code-size touch.c -o touch -subtype=dot -create-app
// zcc +zxn -vn -startup=30 -clib=new touch.c -o touch -subtype=dot -create-app

#pragma printf = ""

#include <stdio.h>
#include <stdarg.h>
#include <arch/zxn/esxdos.h>

unsigned char buffer[20];

int main(int argc, char **argv)
{
   if ((unsigned char)argc < 2)
   {
      printf("touch file1 file2 file3 ...\n");
      printf("(simple test)\n\n");
      
      return 0;
   }
   
   for (unsigned char i = 1; i != (unsigned char)argc; ++i)
   {
      unsigned char file;
      
      file = esxdos_f_open(argv[i], ESXDOS_MODE_OPEN_EXIST | ESXDOS_MODE_R | ESXDOS_MODE_W);
      esxdos_f_read(file, buffer, 1);
      esxdos_f_seek(file, 0UL, ESXDOS_SEEK_SET);
      esxdos_f_write(file, buffer, 1);
      esxdos_f_close(file);
   }
   
   return 0;
}
