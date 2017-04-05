; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC asm_SMSlib_VRAMmemsetW

asm_SMSlib_VRAMmemsetW:

   ; void SMS_VRAMmemsetW (unsigned int dst, unsigned int value, unsigned int size)
   ;
   ; enter : hl = unsigned int dst
   ;         de = unsigned int value
   ;         bc = unsigned int size
   ;
   ; uses  : af, bc, h
   
   ld a,c
   
   set 6,h
   INCLUDE "SMS_CRT0_RST08.inc"

   srl b
   rra
   ld c,a
   
loop:

   ld a,b
   or c
   ret z

   ld a,e
   out (VDPDataPort),a
   
   nop
   nop
   nop
   
   ld a,d
   out (VDPDataPort),a

   dec bc
   jr loop
