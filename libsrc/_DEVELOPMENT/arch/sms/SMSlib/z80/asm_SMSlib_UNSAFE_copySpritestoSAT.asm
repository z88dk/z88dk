; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC asm_UNSAFE_SMSlib_copySpritestoSAT

EXTERN _SpriteTableY, _SpriteTableXN, _outi_block

asm_UNSAFE_SMSlib_copySpritestoSAT:

   ; void UNSAFE_SMS_copySpritestoSAT (void)
   ;
   ; uses  : f, bc, hl
   
   ld hl,SMS_SATAddress
   rst SMS_crt0_RST08
   
   ld c,VDPDataPort
   ld hl,_SpriteTableY

IF MAXSPRITES=64
   call _outi_block - (MAXSPRITES*2)
ELSE
   call _outi_block - ((MAXSPRITES+1)*2)
ENDIF

   ld hl,SMS_SATAddress+128
   rst SMS_crt0_RST08
   
   ld c,VDPDataPort
   ld hl,_SpriteTableXN

   jp _outi_block - (MAXSPRITES*4)
