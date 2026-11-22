; void *ulap_write_palette(void *src,unsigned char pent,unsigned char num)

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_arch

PUBLIC asm_ulap_write_palette

asm_ulap_write_palette:

   ; enter : hl = void *src
   ;          e = unsigned char pent
   ;          d = unsigned char num > 0
   ;
   ; exit  : hl = void *src after last byte read
   ;
   ; uses  : f, bc, de, hl

   ld c,__IO_ULAP_REGISTER & 0xff
   
loop:

   ld b,__IO_ULAP_REGISTER / 256
   out (c),e
   
   ld b,0xff & ((__IO_ULAP_DATA / 256) + 1)
   outi
   inc e
   
   dec d
   jr nz, loop
   
   ret
