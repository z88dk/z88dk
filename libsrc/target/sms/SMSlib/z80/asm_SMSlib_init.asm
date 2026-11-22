; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

defc __NONEED = 1
INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC asm_SMSlib_init

EXTERN asm_SMSlib_resetPauseRequest, asm_SMSlib_detect_VDP_type, asm_SMSlib_setSpritePaletteColor
EXTERN asm_SMSlib_initSprites, asm_SMSlib_finalizeSprites, asm_SMSlib_copySpritestoSAT

asm_SMSlib_init:

   xor a
   ld l,a

   call asm_SMSlib_setSpritePaletteColor

   ; vdp register initialization moved to crt
   
   call asm_SMSlib_initSprites
   call asm_SMSlib_finalizeSprites
   call asm_SMSlib_copySpritestoSAT
   call asm_SMSlib_resetPauseRequest

   jp asm_SMSlib_detect_VDP_type


; add library initialization to crt

SECTION code_crt_init
call    asm_SMSlib_init
