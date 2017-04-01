; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION code_lib
PUBLIC asm_GG_init

EXTERN _VDPReg_init
EXTERN asm_SMS_initSprites, asm_SMS_finalizeSprites, asm_SMS_copySpritestoSAT

include "../SMSlib_private.inc"

asm_GG_init:

   di
   
   ld b,11
   ld hl,_VDPReg_init
   
loop:

   ld a,(hl)
   inc hl
   
   out (VDPControlPort),a
   
   ld a,11+0x80
   sub b
   
   out (VDPControlPort),a
   
   djnz loop
   
   ei
   
   call asm_SMS_initSprites
   call asm_SMS_finalizeSprites
   
   jp asm_SMS_copySpritestoSAT
