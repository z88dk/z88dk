; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION code_lib
PUBLIC asm_SMS_VRAMmemcpy

include "../SMSlib_private.inc"

asm_SMS_VRAMmemcpy:

   ; void SMS_VRAMmemcpy (unsigned int dst, void *src, unsigned int size)
   ;
   ; enter : hl = unsigned int dst
   ;         de = void *src
   ;         bc = unsigned int size
   ;
   ; uses  : af, bc, de, hl
   
   ld a,c
   
   set 7,h
   rst SMS_crt0_RST08

   ld c,a
   ex de,hl
   
loop:

   ld a,(hl)
   out (VDPDataPort),a
   
   cpi                         ; hl++, bc--
   jp pe, loop
   
   ret
