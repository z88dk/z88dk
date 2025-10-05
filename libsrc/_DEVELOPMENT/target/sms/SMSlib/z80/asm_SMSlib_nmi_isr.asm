; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC asm_SMSlib_nmi_isr

EXTERN __SMSlib_PauseRequested

asm_SMSlib_nmi_isr:

   push hl
   
   ld hl,__SMSlib_PauseRequested
   ld (hl),1
   
   pop hl
   retn
