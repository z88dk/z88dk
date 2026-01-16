// This is the same program as snx.c except this one is intended
// for generating an extended sna snapshot.  The program must open
// its own sna file in order to load the banks appended to the
// end of the standard portion of the sna.
//
// Many emulators will be able to start this extended sna type
// without any changes.

// zsdcc compile
// zcc +zxn -vn -startup=0 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 sna.c mem.asm -o sna -subtype=sna -Cz"--ext --fullsize --clean" -create-app

// sccz80 compile
// zcc +zxn -vn -startup=0 -clib=new sna.c mem.asm -o sna -subtype=sna -Cz"--ext --fullsize --clean" -create-app

#include <stdio.h>
#include <stdlib.h>
#include <arch/zxn/esxdos.h>
#include <arch/zxn.h>
#include <errno.h>

unsigned char _z_sna_filename[13];

void print_page(unsigned char page)
{
   ZXN_WRITE_MMU3(page);
   
   printf("Page %u\n\n", page);
   
   for (unsigned char *p = 0x6000; p != 0x6180; ++p)
      printf("%02x", *p);
   
   printf("\n\n");
   
   ZXN_WRITE_MMU3(11);
}

int main(void)
{
   unsigned char fin;
   
   printf("Filename: %s\n\n", _z_sna_filename);
   
   fin = esx_f_open(_z_sna_filename, ESX_MODE_R | ESX_MODE_OPEN_EXIST);
   
   if (errno == 0)
   {
      extended_sna_load(fin);
      esx_f_close(fin);
   }
   
   if (errno)
   {
      printf("Error: %u\n", errno);
      exit(1);
   }
   
   print_page(30);
   print_page(41);
   print_page(125);
   
   return 0;
}
