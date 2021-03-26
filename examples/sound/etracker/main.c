// zcc +sam main.c axel.asm -create-app

#include <stdio.h>
#include <intrinsic.h>
#include <interrupt.h>
#include <psg/etracker.h>
#include <stdlib.h>
#include <sys/ioctl.h>


#ifdef __SAM__
#include <arch/sam.h>
#endif

extern char mysong;

void playmusic(void) {
   M_PRESERVE_MAIN;
   saa_etracker_play();
   M_RESTORE_MAIN;
}


void setup_int() {
   add_raster_int(playmusic);
}


void main()
{
   printf("%ceTracker example\n",12);

   // Load the tracker file
   saa_etracker_init(&mysong);

   // Setup interrupt
   setup_int();

   // Just loop
   while  ( 1 ) {
      fgetc_cons();
   }
}

