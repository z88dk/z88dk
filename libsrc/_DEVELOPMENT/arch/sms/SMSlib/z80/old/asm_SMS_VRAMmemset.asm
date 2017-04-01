; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION code_lib
PUBLIC asm_SMS_VRAMmemset

include "../SMSlib_private.inc"

asm_SMS_VRAMmemset:

   ; void SMS_VRAMmemset (unsigned int dst, unsigned char value, unsigned int size)
   ;
   ; enter : hl = unsigned int dst
   ;          e = unsigned char value
   ;         bc = unsigned int size
   ;
   ; uses  : af, bc, h
   
   ld a,c
   
   set 7,h
   rst SMS_crt0_RST08

   ld c,a
   
loop:

   ld a,b
   or c
   ret z

   ld a,e
   out (VDPDataPort),a

   dec bc
   jr loop
