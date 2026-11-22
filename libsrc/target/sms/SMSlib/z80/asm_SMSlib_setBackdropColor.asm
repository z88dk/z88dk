; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC asm_SMSlib_setBackdropColor

EXTERN asm_sms_border

defc asm_SMSlib_setBackdropColor = asm_sms_border

   ; void SMS_setBackdropColor (unsigned char entry)
   ;
   ; enter :  l = unsigned char entry
   ;
   ; uses  : af
