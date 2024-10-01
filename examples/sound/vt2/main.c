// zcc +zx main.c sound.asm -lndos -create-app
// zcc +msx main.c sound.asm -subtype=rom -create-app
// zcc +cpc main.c sound.asm -create-app
// zcc +cpm -subtype=einstein main.c sound.asm -subtype=rom -create-app
#include <interrupt.h>
#include <intrinsic.h>
#include <stdio.h>
#ifdef __SPECTRUM__
#include <spectrum.h>
#endif
#ifdef __MSX__
#include <msx.h>
#endif
#ifdef __GAL__
#include <arch/gal.h>
#endif
#include <psg/vt2.h>
#include <stdlib.h>

#if __PC6001__ | __MULTI8__ | __NABUPC__ | __EINSTEIN__
#define NO_INTERRUPT 1
#endif

extern vt2_song mysong;

void playmusic(void) {
  M_PRESERVE_MAIN;
  M_PRESERVE_INDEX;
#ifdef __AQUARIUS__
  // Aquarius is NTSC and the music was created for PAL
  // Skip 1 out of every 6 interrupts
  static int NTSCCount = 6;
  if (--NTSCCount) {
    ay_vt2_play();
  } else {
    NTSCCount = 6;
  }
#else
  ay_vt2_play();
#endif
  M_RESTORE_INDEX;
  M_RESTORE_MAIN;
}

void setup_int() {
#ifndef NO_INTERRUPT
#if __SPECTRUM__
  zx_im2_init((void *)0xd300, 0xd4);
  add_raster_int((isr_t)0x38);
#else
  im1_init();
#endif
  add_raster_int(playmusic);
#endif
}

int main() {
  printf("%cVT2 Tracker example\n", 12);
  printf("Press SPACE to stop music\n");
  printf("Press 's' to start music\n");

  // Load the tracker file
  ay_vt2_init(&mysong);
  // Set things up to play
  ay_vt2_start();

  // Setup interrupt
  setup_int();

  // Just loop
  while (1) {
    int k = getk();
    if (k) {
      if (k == ' ')
        ay_vt2_stop();
      else if (k == 's')
        ay_vt2_start();

      // Wait for key to be released
      do {
        ;
      } while (getk());
    }
#ifdef __CPC__
    msleep(40);
#endif

#ifdef NO_INTERRUPT
    ay_vt2_play();
    msleep(10);
#endif
  }
  return 0;
}
