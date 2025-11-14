// This is the same program as sna.c except this one is intended
// for the snx snapshot type introduced in NextOS 1.98E.  The snapshot
// format does not change but NextOS leaves the file handle open
// that was used to load the snx from disk.  This means the filename
// of the snx file on disk no longer needs to be known.
//
// This snapshot format can only be started in NextOS.  Emulators
// that do not run NextOS and other operating systems will not be
// able to start snx snapshots unless they have been modified to
// do so.

// zsdcc compile
// zcc +zxn -vn -startup=0 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 snx.c mem.asm -o snx -subtype=snx -Cz"--fullsize --clean" -create-app

// sccz80 compile
// zcc +zxn -vn -startup=0 -clib=new snx.c mem.asm -o snx -subtype=snx -Cz"--fullsize --clean" -create-app

#include <stdio.h>
#include <stdlib.h>
#include <arch/zxn/esxdos.h>
#include <arch/zxn.h>
#include <errno.h>

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
   extended_sna_load(0);
   esx_f_close(0);

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
