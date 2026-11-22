; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC asm_SMSlib_detect_VDP_type

EXTERN __SMSlib_VDPType

asm_SMSlib_detect_VDP_type:

   ; uses : af, c

loop00:

   in a,(VDPVCounterPort)
   
   cp 0x81
   jr nc, loop00               ; // wait next frame starts

loop01:

   in a,(VDPVCounterPort)
   
   cp 0x80
   jr c, loop01                ; // wait next half frame
   
loop02:

   in a,(VDPVCounterPort)
   ld c,a
   
   in a,(VDPVCounterPort)
   
   cp c
   jr nc, loop02               ; // wait until VCounter 'goes back'
   
   ld a,c
   cp 0xe7
   
   ld a,VDP_PAL
   jr nc, detected
   
   ld a,VDP_NTSC

detected:
   
   ld (__SMSlib_VDPType),a
   ret
