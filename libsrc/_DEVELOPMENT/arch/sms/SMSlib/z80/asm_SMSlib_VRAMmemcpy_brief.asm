; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC asm_SMSlib_VRAMmemcpy_brief

asm_SMSlib_VRAMmemcpy_brief:

   ; void SMS_VRAMmemcpy_brief (unsigned int dst, void *src, unsigned char size)
   ;
   ; enter : hl = unsigned int dst
   ;         de = void *src
   ;         b  = unsigned char size
   ;
   ; uses  : af, bc, de, hl
   
   set 6,h
   INCLUDE "SMS_CRT0_RST08.inc"

   ex de,hl
   
loop:

   ld a,(hl)
   inc hl
   
   out (VDPDataPort),a
   
   djnz loop
   ret
