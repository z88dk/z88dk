; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC asm_UNSAFE_SMSlib_copySpritestoSAT

EXTERN asm_SMSlib_outi_block
EXTERN __SMSlib_SpriteTableY, __SMSlib_SpriteTableXN

asm_UNSAFE_SMSlib_copySpritestoSAT:

   ; void UNSAFE_SMS_copySpritestoSAT (void)
   ;
   ; uses  : f, bc, hl
   
   ld hl,SMS_SATAddress
   INCLUDE "SMS_CRT0_RST08.inc"
   
   ld c,VDPDataPort
   ld hl,__SMSlib_SpriteTableY

IF MAXSPRITES=64
   call asm_SMSlib_outi_block - (MAXSPRITES*2)
ELSE
   call asm_SMSlib_outi_block - ((MAXSPRITES+1)*2)
ENDIF

   ld hl,SMS_SATAddress+128
   INCLUDE "SMS_CRT0_RST08.inc"
   
   ld c,VDPDataPort
   ld hl,__SMSlib_SpriteTableXN

   jp asm_SMSlib_outi_block - (MAXSPRITES*4)
