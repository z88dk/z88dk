; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION code_lib
PUBLIC asm_SMS_hideSprite

EXTERN _SpriteTableY

asm_SMS_hideSprite:

   ; void SMS_hideSprite (unsigned int sprite)
   ;
   ; enter : hl = unsigned int sprite
   ;
   ; uses : de, hl

   ld de,_SpriteTableY
   add hl,de
   
   ld (hl),0xe0
   ret
