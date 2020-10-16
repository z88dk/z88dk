#include <stdio.h>
#include <intrinsic.h>
#include <psg/PSGlib.h>
#include <stdlib.h>
#include <games.h>


// zcc +coleco main.c psg.c -create-app
// zcc +sms main.c psg.c -create-app


// Content.
#define MUSIC_PSG                       music_psg
#define SOUND1_PSG                      sound1_psg
#define SOUND2_PSG                      sound2_psg
#define SOUND3_PSG                      sound3_psg


#include "psg.h"


#define USE_JOYSTICK 1

int readkey() {
#ifdef USE_JOYSTICK
   int k = joystick(1);
   if ( k & MOVE_UP ) return '0';
   if ( k & MOVE_RIGHT ) return '1';
   if ( k & MOVE_DOWN ) return '2';
   if ( k & MOVE_DOWN ) return '2';
   if ( k & MOVE_FIRE1 ) return 's';
   if ( k & MOVE_FIRE1 ) return ' ';
#else
   return getk();
#endif
}


void main()
{
   printf("%cPSGLib example\n",12);

   // Start playing the song
   PSGPlay(MUSIC_PSG);

   // Just loop
   while  ( 1 ) {
      int k = readkey();
      switch ( k ) {
      case '0':
          PSGSFXPlay(SOUND1_PSG, SFX_CHANNEL2);
          break;
      case '1':
          PSGSFXPlay(SOUND2_PSG, SFX_CHANNEL2);
          break;
      case '2':
          PSGSFXPlay(SOUND3_PSG, SFX_CHANNEL2);
          break;
      case ' ':
          PSGSilenceChannels();
          break;
      case 's':
          PSGRestoreVolumes();
          break;
      }
      PSGFrame();
      PSGSFXFrame();
      msleep(40);
   }
}

