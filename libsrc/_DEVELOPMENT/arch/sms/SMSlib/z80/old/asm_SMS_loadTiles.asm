; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION code_lib
PUBLIC asm_SMS_loadTiles

include "../SMSlib_private.inc"

asm_SMS_loadTiles:

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
   
   rst SMS_crt0_RST08          ; SMS_crt0_RST08(hl)
   
   ex de,hl
   
   ;; SMS_byte_array_to_VDP_data(src,size)
   
 loop:
   
   ld a,(hl)
   out (VDPDataPort),a
   
   cpi                         ; hl++, bc--
   jp pe, loop
   
   ret
