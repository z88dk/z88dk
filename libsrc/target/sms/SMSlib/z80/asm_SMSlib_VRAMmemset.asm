; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC asm_SMSlib_VRAMmemset

EXTERN asm_sms_set_vram

asm_SMSlib_VRAMmemset:

   ; void SMS_VRAMmemset (unsigned int dst, unsigned char value, unsigned int size)
   ;
   ; enter : hl = unsigned int dst
   ;          e = unsigned char value
   ;         bc = unsigned int size > 0
   ;
   ; uses  : af, bc, hl
   
   ld a,c
   
   set 6,h
   INCLUDE "SMS_CRT0_RST08.inc"

   ld c,a

   or b
   ret z

   ld a,e
   jp asm_sms_set_vram
