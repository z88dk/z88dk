; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC asm_SMSlib_VRAMmemcpy

asm_SMSlib_VRAMmemcpy:

   ; void SMS_VRAMmemcpy (unsigned int dst, void *src, unsigned int size)
   ;
   ; enter : hl = unsigned int dst
   ;         de = void *src
   ;         bc = unsigned int size
   ;
   ; uses  : af, bc, de, hl
   
   ld a,c
   
   set 6,h
   INCLUDE "SMS_CRT0_RST08.inc"

   ld c,a
   ex de,hl
   
loop:

   ld a,(hl)
   out (VDPDataPort),a
   
   cpi                         ; hl++, bc--
   jp pe, loop
   
   ret
