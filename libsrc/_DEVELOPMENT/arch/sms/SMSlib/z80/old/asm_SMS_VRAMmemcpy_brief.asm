; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION code_lib
PUBLIC asm_SMS_VRAMmemcpy_brief

include "../SMSlib_private.inc"

asm_SMS_VRAMmemcpy_brief:

   ; void SMS_VRAMmemcpy_brief (unsigned int dst, void *src, unsigned char size)
   ;
   ; enter : hl = unsigned int dst
   ;         de = void *src
   ;         b  = unsigned char size
   ;
   ; uses  : af, bc, de, hl
   
   set 7,h
   rst SMS_crt0_RST08

   ex de,hl
   
loop:

   ld a,(hl)
   inc hl
   
   out (VDPDataPort),a
   
   djnz loop
   ret
