; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION code_lib
PUBLIC asm_SMS_finalizeSprites

EXTERN _SpriteNextFree, _SpriteTableY

include "../SMSlib_private.inc"

asm_SMS_finalizeSprites:

   ; void SMS_finalizeSprites (void)
   ;
   ; uses : af, hl
   
   ld a,(_SpriteNextFree)
   
IF MAXSPRITES = 64
   
   cp MAXSPRITES
   ret nc
   
ENDIF

   add a,_SpriteTableY&0xff
   ld l,a
   ld a,0
   adc a,_SpriteTableY/256
   ld h,a
   
   ld (hl),0xd0
   ret
