; void *ulap_read_palette(void *dst,unsigned char pent,unsigned char num)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_arch

PUBLIC asm_ulap_read_palette

asm_ulap_read_palette:

   ; enter : hl = void *dst
   ;          e = unsigned char pent
   ;          d = unsigned char num > 0
   ;
   ; exit  : hl = void *dst after last byte written
   ;
   ; uses  : f, bc, de, hl

   ld c,__IO_ULAP_REGISTER & 0xff
   
loop:

   ld b,__IO_ULAP_REGISTER / 256
   out (c),e
   
   ld b,__IO_ULAP_DATA / 256
   ini
   inc e
   
   dec d
   jr nz, loop
   
   ret
