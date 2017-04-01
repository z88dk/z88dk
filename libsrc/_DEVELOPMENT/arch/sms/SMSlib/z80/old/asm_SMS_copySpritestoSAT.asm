; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION code_lib
PUBLIC asm_SMS_copySpritestoSAT

EXTERN _SpriteTableY, _SpriteTableXN

include "../SMSlib_private.inc"

asm_SMS_copySpritestoSAT:

   ; void SMS_copySpritestoSAT (void)
   ;
   ; uses : af, b, hl
   
   ;; SMS_setAddr(SMS_SATAddress)
   
   ld hl,SMS_SATAddress
   rst SMS_crt0_RST08          ; SMS_crt0_RST08(hl)
   
IF MAXSPRITES = 64

   ld b,MAXSPRITES

ELSE

   ld b,MAXSPRITES + 1
   
ENDIF

   ld hl,_SpriteTableY

loop00:
 
   ld a,(hl)
   inc hl
   
   out (VDPDataPort),a
   
   djnz loop00
   
   ld hl,SMS_SATAddress + 128
   rst SMS_crt0_RST08          ; SMS_crt0_RST08(hl)
   
   ld b,MAXSPRITES
   sla b
   
   ld hl,_SpriteTableXN

loop01:

   ld a,(hl)
   inc hl
   
   out (VDPDataPort),a
   
   djnz loop01
   ret
