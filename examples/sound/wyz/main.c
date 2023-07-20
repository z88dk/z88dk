// zcc +zx main.c sham.mus.asm effects.asm -create-app
// zcc +sam main.c sham.mus.asm effects.asm -create-app
// zcc +nabu main.c effects.asm sham.mus.asm -create-app
// zcc +msx main.c effects.asm sham.mus.asm -create-app
// zcc +cpc main.c effects.asm sham.mus.asm -create-app
// zcc +cpm -subtype=einstein main.c effects.asm sham.mus.asm -create-app
// etc etc
//
#include <stdio.h>
#include <intrinsic.h>
#include <interrupt.h>
#ifdef __SPECTRUM__
#include <spectrum.h>
#endif
#ifdef __MSX__
#include <msx.h>
#endif
#ifdef __CPC__
#include <cpc.h>
#endif
#ifdef __SAM__
#include <arch/sam.h>
#endif
#ifdef __GAL__
#include <arch/gal.h>
#endif
#include <psg/wyz.h>
#include <stdlib.h>


#if __PC6001__ | __MULTI8__ | __LM80C__ | __EINSTEIN__
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

#ifdef __NABUPC__
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
   zx_im2_init((void *)0xd300, 0xd4);
   add_raster_int((isr_t)0x38);
#endif
#ifndef NO_INTERRUPT_INIT
   im1_init();
#endif
   add_raster_int(playmusic);
#endif
}


int main()
{
   printf("%cWYZ Tracker example\n",12);

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
      if ( k != 0 ) printf("%c \n",k);
      switch ( k ) {
      case '0':
          ay_wyz_start_effect(3, 0);
          break;
      case '1':
          ay_wyz_start_effect(3, 1);
          break;
      case '2':
          ay_wyz_start_effect(3, 2);
          break;
      case '3':
          ay_wyz_start_effect(3, 3);
          break;
      case ' ':
          ay_wyz_stop();
          break;
      case 's':
          ay_wyz_start(0);
          break;
      }
#ifdef __CPC__
      // Calling the firmwae too often disables our interrupt handler, so lets only
      // do it once per frame
      msleep(40);
#endif
#ifdef NO_INTERRUPT
       ay_wyz_play();
       msleep(40);
#endif
   }
   return 0;
}

