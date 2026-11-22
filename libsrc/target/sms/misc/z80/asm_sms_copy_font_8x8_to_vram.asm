; ===============================================================
; 2017
; ===============================================================
; 
; void *sms_copy_font_8x8_to_vram(void *font, unsigned char num, unsigned char cbgnd, unsigned char cfgnd)
;
; Copy 1-bit 8x8 font to vram, colouring along the way.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_arch

PUBLIC asm_sms_copy_font_8x8_to_vram

asm_sms_copy_font_8x8_to_vram:

   ; enter : hl = void *font
   ;          e = background colour (4 bits)
   ;          d = foreground colour (4 bits)
   ;          c = number of font characters to copy
   ;
   ;         VDP DESTINATION ADDRESS ALREADY SET!
   ;
   ; exit  : hl = void *font, one byte past last char read
   ;
   ; uses  : af, bc, de, hl

char_loop:

   ld b,8
   
row_loop:

   push bc
   push de
   
   ld b,4

one_pixel_row_loop:

   ;  b = colour bit count
   ;  e = background colour
   ;  d = foreground colour
   ; hl = void *src
   
   ; background bits
   
   ld a,(hl)
   cpl
   ld c,a
   rrc e
   sbc a,a
   and c
   ld c,a
   
   ; foreground bits
   
   rrc d
   sbc a,a
   and (hl)
   
   ; combine background and foreground bits
   
   or c
   out (__IO_VDP_DATA),a
   
   djnz one_pixel_row_loop
   
   pop de
   pop bc
   
   inc hl
   djnz row_loop
   
   dec c
   jr nz, char_loop
   
   ret
