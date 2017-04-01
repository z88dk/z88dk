; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION code_lib
PUBLIC asm_SMS_loadTileMap

include "../SMSlib_private.inc"

asm_SMS_loadTileMap:

   ; void SMS_loadTileMap(unsigned char x, unsigned char y, void *src, unsigned int size)
   ;
   ; enter : bc = unsigned int size
   ;         de = void *src
   ;          l = unsigned char y
   ;          h = unsigned char x
   ;
   ; uses  : af, bc, de, hl

   ;; SMS_setAddr(SMS_PNTAddress+(y*32+x)*2)

   push de
   
   ld e,h
   ld d,0
   ld h,d
   add hl,hl
   add hl,hl
   add hl,hl
   add hl,hl
   add hl,hl
   add hl,de
   add hl,hl                   ; hl = (y*32+x)*2

   ld de,SMS_PNTAddress
   add hl,de                   ; hl = SMS_PNTAddress+(y*32+x)*2
   
   rst SMS_crt0_RST08          ; SMS_crt0_RST08(hl)

   pop hl
   
   ;; SMS_byte_array_to_VDP_data(src,size)

   ; bc = unsigned int size
   ; hl = void *src
   
loop:
   
   ld a,(hl)
   out (VDPDataPort),a
   
   cpi                         ; hl++, bc--
   jp pe, loop
   
   ret
