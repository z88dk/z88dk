/* **************************************************
   SMSlib - C programming library for the SMS/GG
   ( part of devkitSMS - github.com/sverx/devkitSMS )
   ************************************************** */

#include "SMSlib.h"
#include "SMSlib_common.c"

/* low level functions, just to be used for dirty tricks ;) */
void SMS_VRAMmemcpy (unsigned int dst, void *src, unsigned int size) {
  // SMS_set_address_VRAM(dst);
  SMS_setAddr(0x4000|dst);
  SMS_byte_array_to_VDP_data(src,size);
}

void SMS_VRAMmemcpy_brief (unsigned int dst, void *src, unsigned char size) {
  // SMS_set_address_VRAM(dst);
  SMS_setAddr(0x4000|dst);
  SMS_byte_brief_array_to_VDP_data(src,size);
}
