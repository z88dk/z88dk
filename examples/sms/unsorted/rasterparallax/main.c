#include <arch/sms/SMSlib.h>
#include "bank2.h"

#define HOLEINSAT 506
/*
const unsigned char shft[192/2]={
1,1,1,1,1, 1,1,1,1,1, 1,1,1,1,1, 1,1,1,1,1,
1,1,1,1,1, 2,2,2,2,2, 2,2,2,2,2, 2,2,2,2,2,
3,3,3,3,3, 3,3,3,3,3,
4,4,4,4,4, 4,4,4,
5,5,5,5,5, 5,5,
6,6,6,6,6,
7,7,7,7,
8,8,8,
9,9,
10,10,
11,11,
12,12,
13,14,15,16,17,18,19,20,21,22,23};        */

const unsigned char shft[192/2]={
1,1,1,1,1, 1,1,1,1,1, 1,1,1,1,1, 1,1,1,1,1, 1,1,1,
1,1,1,1,2, 1,2,1,2,2, 2,2,       2,2,2,2,3,
2,3,2,3,3, 3,3,3,3,4,
/* 50 */
3,4,3,4,4, 4,4,5,
4,5,4,5,5, 5,6,
5,6,5,6,6,
/* 70 */
7,6,7,7,
8,7,8,
9,9,
10,10,
11,11,
12,12,
13,14,15,16,17,18,19,20,21,22,23};


unsigned char offs[192/2];   /* this will be zeroed by CRT0 */
unsigned char lineCnt,pole_x;

void lineHandler(void) {
  SMS_setBGScrollX (offs[lineCnt++]);
}

void main(void) {
  unsigned char i,pole_y;
  
  // load assets into VRAM
  SMS_loadPSGaidencompressedTiles (grass_reduced__tiles__psgcompr,0);
  SMS_loadSTMcompressedTileMap (0, 0, grass_reduced__tilemap__stmcompr);
  SMS_loadBGPalette (grass_reduced__palette__bin);
  SMS_loadPSGaidencompressedTiles (pole__tiles__psgcompr,HOLEINSAT);
  SMS_loadSpritePalette (pole__palette__bin);

  // prepare for lineIRQ
  SMS_setLineInterruptHandler(&lineHandler);
  SMS_setLineCounter(1);    /* we're updating every 2 scanlines... */
  SMS_enableLineInterrupt();
  
  // prepare sprites
  SMS_initSprites();
  for (i=0;i<5;i++)
    SMS_addSprite(0,0,HOLEINSAT);
  SMS_finalizeSprites();

  // get this party started
  SMS_VDPturnOnFeature(VDPFEATURE_LEFTCOLBLANK);
  SMS_setSpriteMode(SPRITEMODE_TALL);
  SMS_displayOn();
  for (;;) {
    SMS_waitForVBlank ();
    SMS_disableLineInterrupt();
    UNSAFE_SMS_copySpritestoSAT();
    offs[0]+=shft[0];
    SMS_setBGScrollX (offs[0]);
    i=1;
    do {
      // offs[i++]+=shft[i];
      offs[i]+=shft[i];
      i++;
    } while (i<(192/2));
    lineCnt=1;

    // move sprites
    pole_y=52;
    for (i=0;i<5;i++) {
      SMS_updateSpritePosition(i,pole_x,pole_y);
      pole_y+=16;
    }
    pole_x+=5;
    SMS_enableLineInterrupt();
  }
}
