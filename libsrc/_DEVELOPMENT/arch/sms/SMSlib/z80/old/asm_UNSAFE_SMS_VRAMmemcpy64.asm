; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION code_lib
PUBLIC asm_UNSAFE_SMS_VRAMmemcpy64

EXTERN asm_sms_outi

include "../SMSlib_private.inc"

asm_UNSAFE_SMS_VRAMmemcpy64:

   ; void UNSAFE_SMS_VRAMmemcpy64 (unsigned int dst, void *src)
   ;
   ; enter : hl = unsigned int dst
   ;         de = void *src
   ;
   ; uses  : f, bc, de, hl
   
   set 7,h
   rst SMS_crt0_RST08
   
   ld c,VDPDataPort
   ex de,hl
   jp asm_sms_outi - (64*2)
