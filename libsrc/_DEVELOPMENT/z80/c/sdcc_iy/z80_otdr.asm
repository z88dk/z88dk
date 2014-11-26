
; void *z80_otdr(void *src, uint16_t port)

SECTION seg_code_z80

PUBLIC _z80_otdr

_z80_otdr:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   INCLUDE "z80/z80/asm_z80_otdr.asm"
