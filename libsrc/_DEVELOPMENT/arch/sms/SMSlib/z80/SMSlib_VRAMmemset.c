/* **************************************************
   SMSlib - C programming library for the SMS/GG
   ( part of devkitSMS - github.com/sverx/devkitSMS )
   ************************************************** */

#include "SMSlib.h"
#include "SMSlib_common.c"

/* low level functions, just to be used for dirty tricks ;) */
void SMS_VRAMmemset (unsigned int dst, unsigned char value, unsigned int size) {
  // SMS_set_address_VRAM(dst);
  SMS_setAddr(0x4000|dst);
  while (size>0) {
    SMS_byte_to_VDP_data(value);
    size--;
  }
}

void SMS_VRAMmemsetW (unsigned int dst, unsigned int value, unsigned int size) {
  // SMS_set_address_VRAM(dst);
  SMS_setAddr(0x4000|dst);
  while (size>0) {
    SMS_byte_to_VDP_data(LO(value));
    WAIT_VRAM;                          /* ensure we're not pushing data too fast */
    SMS_byte_to_VDP_data(HI(value));
    size-=2;
  }
}
