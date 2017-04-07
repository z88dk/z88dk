; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC asm_SMSlib_copySpritestoSAT

EXTERN __SMSlib_SpriteTableY, __SMSlib_SpriteTableXN

asm_SMSlib_copySpritestoSAT:

   ; void SMS_copySpritestoSAT (void)
   ;
   ; uses : af, bc, hl
   
   ld hl,SMS_SATAddress
   INCLUDE "SMS_CRT0_RST08.inc"
   
IF MAXSPRITES = 64

   ld b,MAXSPRITES

ELSE

   ld b,MAXSPRITES + 1
   
ENDIF

   ld hl,__SMSlib_SpriteTableY

loop00:
 
   ld a,(hl)
   inc hl
   
   out (VDPDataPort),a
   
   djnz loop00
   
   ld hl,SMS_SATAddress + 128
   INCLUDE "SMS_CRT0_RST08.inc"
   
   ld b,MAXSPRITES
   sla b
   
   ld hl,__SMSlib_SpriteTableXN

loop01:

   ld a,(hl)
   inc hl
   
   out (VDPDataPort),a
   
   djnz loop01
   ret
