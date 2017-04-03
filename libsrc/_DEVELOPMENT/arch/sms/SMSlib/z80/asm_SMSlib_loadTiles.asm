; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC asm_SMSlib_loadTiles

asm_SMSlib_loadTiles:

   ; void SMS_loadTiles (void *src, unsigned int tilefrom, unsigned int size)
   ;
   ; enter : de = void *src
   ;         hl = unsigned int tilefrom
   ;         bc = unsigned int size
   ;
   ; uses  : af, bc, de, hl
   
   ;; SMS_setAddr(0x4000|(tilefrom*32))
   
   add hl,hl
   add hl,hl
   add hl,hl
   add hl,hl
   add hl,hl
   set 6,h
   
	ld a,c
   INCLUDE "SMS_CRT0_RST08.inc"
	ld c,a
   
   ex de,hl
   
   ;; SMS_byte_array_to_VDP_data(src,size)
   
 loop:
   
   ld a,(hl)
   out (VDPDataPort),a
   
   cpi                         ; hl++, bc--
   jp pe, loop
   
   ret
