// zcc +zx main.c sham.mus.asm effects.asm -create-app
// zcc +sam main.c sham.mus.asm effects.asm -create-app
#include <stdio.h>
#include <intrinsic.h>
#include <interrupt.h>
#ifdef __SPECTRUM__
#include <spectrum.h>
#endif
#ifdef __MSX__
#include <msx.h>
#endif
#ifdef __SAM__
#include <arch/sam.h>
#endif
#ifdef __GAL__
#include <arch/gal.h>
#endif
#include <psg/wyz.h>
#include <stdlib.h>


#if __PC6001__ | __MULTI8__ | __LM80C__  
#define NO_INTERRUPT 1
#endif

#ifdef __LM80C__
#define getk() 0
#endif

#ifdef __PC88__
extern void __LIB__ add_raster_int(isr_t handler);
#endif

#ifdef __SAM__
#define NO_INTERRUPT_INIT 1
#endif


extern wyz_song mysong;
extern wyz_effects myeffects;

void playmusic(void) {
   M_PRESERVE_MAIN;
   M_PRESERVE_INDEX;
   ay_wyz_play();
   M_RESTORE_INDEX;
   M_RESTORE_MAIN;
}


void setup_int() {
#ifndef NO_INTERRUPT
#if __SPECTRUM__
   zx_im2_init(0xd300, 0xd4);
   add_raster_int(0x38);
#endif
#ifndef NO_INTERRUPT_INIT
   im1_init();
#endif
   add_raster_int(playmusic);
#endif
}


void main()
{
   //printf("%cWYZ Tracker example\n",12);

   // Load the tracker file
   ay_wyz_init(&mysong);
   // Setup the effects
   ay_wyz_effect_init(&myeffects);
   // Play song 1 within the  file
   ay_wyz_start(0);

   // Setup interrupt
   setup_int();

   // Just loop
   while  ( 1 ) {
      int k = getk();
      switch ( k ) {
      case '0':
          asm("di");
          ay_wyz_start_effect(3, 0);
          asm("ei");
          break;
      case '1':
          asm("di");
          ay_wyz_start_effect(3, 1);
          asm("ei");
          break;
      case '2':
          asm("di");
          ay_wyz_start_effect(3, 2);
          asm("ei");
          break;
      case '3':
          asm("di");
          ay_wyz_start_effect(3, 3);
          asm("ei");
          break;
      case ' ':
          asm("di");
          ay_wyz_stop();
          asm("ei");
          break;
      case 's':
          asm("di");
          ay_wyz_start(0);
          asm("ei");
          break;
      }
#ifdef NO_INTERRUPT
       ay_wyz_play();
       msleep(40);
#endif
   }
}

