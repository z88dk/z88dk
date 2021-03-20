// zcc +sam main.c axel.asm -create-app

#include <stdio.h>
#include <intrinsic.h>
#include <interrupt.h>
#include <psg/etracker.h>
#include <stdlib.h>
#include <sys/ioctl.h>


#define NO_INTERRUPT 1

extern char mysong;

void playmusic(void) {
   M_PRESERVE_MAIN;
   M_PRESERVE_INDEX;
   saa_etracker_play();
   M_RESTORE_INDEX;
   M_RESTORE_MAIN;
}


void setup_int() {
#ifndef NO_INTERRUPT
   add_raster_int(playmusic);
#endif
}


void main()
{
   int  mode = 4;


   console_ioctl(IOCTL_GENCON_SET_MODE,&mode);

   printf("%ceTracker example\n",12);

   // Load the tracker file
   saa_etracker_init(&mysong);

   // Setup interrupt
   setup_int();

   // Just loop
   while  ( 1 ) {
#ifdef NO_INTERRUPT
       saa_etracker_play();
       msleep(41);
#endif
   }
}

