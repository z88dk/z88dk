; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION code_lib
PUBLIC asm_SMS_loadTileMapArea

include "../SMSlib_private.inc"

asm_SMS_loadTileMapArea:

   ; void SMS_loadTileMap(SMS_loadTileMapArea (unsigned char x, unsigned char y,  void *src, unsigned char width, unsigned char height)
   ;
   ; enter :  b = unsigned char width
   ;          c = unsigned char height
   ;         de = void *src
   ;          l = unsigned char y
   ;          h = unsigned char x
   ;
   ; uses  : af, bc, de, hl

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
   
   pop de
   
   sla b

loop_y:

   ;; SMS_setAddr(SMS_PNTAddress+(cur_y*32+x)*2)
   
   ; de = void *src
   ; hl = tile address
   ;  b = unsigned int width*2
   ;  c = remaining height

   rst SMS_crt0_RST08          ; SMS_crt0_RST08(hl)
   
   ;; SMS_byte_brief_array_to_VDP_data(src,width*2)
   ;; src=(unsigned char*)src+width*2
   
   ; de = void *src
   ; hl = tile address
   ;  b = unsigned int width*2
   ;  c = remaining height
   
   push bc
   
loop:
   
   ld a,(de)
   inc de
   
   out (VDPDataPort),a

   djnz loop
   
   ld c,64
   add hl,bc
   
   pop bc
   
   dec c
   jp nz, loop_y
   
   ret
