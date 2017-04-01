; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION code_lib
PUBLIC asm_UNSAFE_SMS_copySpritestoSAT

EXTERN _SpriteTableY, _SpriteTableXN, asm_sms_outi

include "../SMSlib_private.inc"

asm_UNSAFE_SMS_copySpritestoSAT:

   ; void UNSAFE_SMS_copySpritestoSAT (void)
   ;
   ; uses  : f, bc, hl
   
   ld hl,SMS_SATAddress
   rst SMS_crt0_RST08
   
   ld c,VDPDataPort
   ld hl,_SpriteTableY
IF MAXSPRITES==64
   call asm_sms_outi - (MAXSPRITES*2)
ELSE
   call asm_sms_outi - ((MAXSPRITES+1)*2)
ENDIF

   ld hl,SMS_SATAddress+128
   rst SMS_crt0_RST08
   
   ld c,VDPDataPort
   ld hl,_SpriteTableXN
   jp asm_sms_outi - (MAXSPRITES*4)
