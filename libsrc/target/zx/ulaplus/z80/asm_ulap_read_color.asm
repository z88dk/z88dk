; unsigned char ulap_read_color(unsigned char pent)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_arch

PUBLIC asm_ulap_read_color

asm_ulap_read_color:

   ; enter : l = unsigned char pent 0-63
   ;
   ; exit  : l = colour at that pent
   ;
   ; uses  : f, bc, l

   ld bc,__IO_ULAP_REGISTER
   out (c),l
   
   ld b,__IO_ULAP_DATA / 256
   in l,(c)
   
   ret
