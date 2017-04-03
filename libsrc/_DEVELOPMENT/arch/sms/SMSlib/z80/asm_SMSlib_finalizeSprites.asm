; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC asm_SMSlib_finalizeSprites

EXTERN __SMSlib_SpriteNextFree, __SMSlib_SpriteTableY

asm_SMSlib_finalizeSprites:

   ; void SMS_finalizeSprites (void)
   ;
   ; uses : af, hl
   
   ld a,(__SMSlib_SpriteNextFree)
   
IF MAXSPRITES = 64
   
   cp MAXSPRITES
   ret nc
   
ENDIF

   add a,__SMSlib_SpriteTableY&0xff
   ld l,a
   ld a,0
   adc a,__SMSlib_SpriteTableY/256
   ld h,a
   
   ld (hl),0xd0
   ret
