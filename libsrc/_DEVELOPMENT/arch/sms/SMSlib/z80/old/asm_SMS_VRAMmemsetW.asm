; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION code_lib
PUBLIC asm_SMS_VRAMmemsetW

include "../SMSlib_private.inc"

asm_SMS_VRAMmemsetW:

   ; void SMS_VRAMmemsetW (unsigned int dst, unsigned int value, unsigned int size)
   ;
   ; enter : hl = unsigned int dst
   ;         de = unsigned char value
   ;         bc = unsigned int size
   ;
   ; uses  : af, bc, h
   
   ld a,c
   
   set 7,h
   rst SMS_crt0_RST08

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
