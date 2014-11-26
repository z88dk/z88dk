
; void *z80_indr(void *dst, uint16_t port)

SECTION seg_code_z80

PUBLIC _z80_indr

_z80_indr:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   INCLUDE "z80/z80/asm_z80_indr.asm"
