/* **************************************************
   SMSlib - C programming library for the SMS/GG
   ( part of devkitSMS - github.com/sverx/devkitSMS )
   ************************************************** */

#include "SMSlib.h"
#include "SMSlib_common.c"
#include <stdbool.h>

void SMS_loadSTMcompressedTileMapArea (unsigned char x, unsigned char y, unsigned char *src, unsigned char width) {
  unsigned int HH=0x0000;
  unsigned int oldHH=0x0000;
  unsigned int dest=XYtoADDR(x,y);
  unsigned char cur;
  unsigned char cnt;
  unsigned char ttw=width;
  bool needRestore=false;
  
  SMS_setAddr(dest);
  while (true) {
    cur=*src++;
    if (cur & 0x01) {
      if (cur & 0x02) {
        /* RLE of successive words */
        HH=(HH & 0xFF00)|*src++;
        cnt=(cur>>2)+2;
        while (cnt>0) {
          SMS_setTile(HH);
          if (--ttw==0) {
            dest+=64;              // skip to next line
            SMS_setAddr(dest);
            ttw=width;
          }
          if (cnt>1)
            HH++;
          cnt--;
        }
      } else {
        /* RLE of same words */
        HH=(HH & 0xFF00)|*src++;
        cnt=(cur>>2)+2;
        while (cnt>0) {
          SMS_setTile(HH);
          if (--ttw==0) {
            dest+=64;              // skip to next line
            SMS_setAddr(dest);
            ttw=width;
          }
          cnt--;
        }
      }
    } else {
      if (cur & 0x02) {
        /* new HH */
        if (cur & 0x04) {
          /* temporary, thus save HH into oldHH */
          oldHH=HH;
          needRestore=true;
        }
        HH=((cur>>3)<<8);
        continue;         /* to skip the restore check at the end of the while block */
      } else {
        /* RAW */
        cnt=(cur>>2);
        if (cnt==0)
          break;          /* done, thus exit the while block */
        while (cnt>0) {
          SMS_byte_to_VDP_data(*src++);
          WAIT_VRAM;                      /* ensure we're not pushing data too fast */
          SMS_byte_to_VDP_data(HI(HH));
          if (--ttw==0) {
            dest+=64;              // skip to next line
            SMS_setAddr(dest);
            ttw=width;
          }
          cnt--;
        }
      }
    }
    if (needRestore) {
      HH=oldHH;
      needRestore=false;
    }
  } /* end while */
}

// the previous code:
/*
void SMS_loadSTMcompressedTileMap (unsigned char x, unsigned char y, unsigned char *src) {
  unsigned int HH=0x0000;
  unsigned int oldHH=0x0000;
  unsigned char cur;
  unsigned char cnt;
  bool needRestore=false;

  SMS_setAddr(SMS_PNTAddress+(y*32+x)*2);
  while (true) {
    cur=*src++;
    if (cur & 0x01) {
      if (cur & 0x02) {
        // RLE of successive words
        HH=(HH & 0xFF00)|*src++;
        cnt=(cur>>2)+2;
        while (cnt>0) {
          // SMS_word_to_VDP_data(HH);
          SMS_setTile(HH);
          if (cnt>1)
            HH++;
          cnt--;
        }
      } else {
        // RLE of same words
        HH=(HH & 0xFF00)|*src++;
        cnt=(cur>>2)+2;
        while (cnt>0) {
          // SMS_word_to_VDP_data(HH);
          SMS_setTile(HH);
          cnt--;
        }
      }
    } else {
      if (cur & 0x02) {
        // new HH
        if (cur & 0x04) {
          // temporary, thus save HH into oldHH
          oldHH=HH;
          needRestore=true;
        }
        HH=((cur>>3)<<8);
        continue;         // to skip the restore check at the end of the while block
      } else {
        // RAW
        cnt=(cur>>2);
        if (cnt==0)
          break;          // done, thus exit the while block
        while (cnt>0) {
          SMS_byte_to_VDP_data(*src++);
          WAIT_VRAM;                      // ensure we're not pushing data too fast
          SMS_byte_to_VDP_data(HI(HH));
          cnt--;
        }
      }
    }
    if (needRestore) {
      HH=oldHH;
      needRestore=false;
    }
  } // end while
}
*/
