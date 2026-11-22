; void ulap_write_color(unsigned char pent,unsigned char color)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_arch

PUBLIC asm_ulap_write_color

asm_ulap_write_color:

   ; enter : l = unsigned char pent 0-63
   ;         h = unsigned char color
   ;
   ; uses  : f, bc

   ld bc,__IO_ULAP_REGISTER
   out (c),l
   
   ld b,__IO_ULAP_DATA / 256
   out (c),h
   
   ret
