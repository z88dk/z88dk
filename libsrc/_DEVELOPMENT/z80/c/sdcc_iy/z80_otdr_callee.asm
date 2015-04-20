
; void *z80_otdr_callee(void *src, uint16_t port)

SECTION code_z80

PUBLIC _z80_otdr_callee

_z80_otdr_callee:

   pop af
   pop hl
   pop bc
   push af
   
   INCLUDE "z80/z80/asm_z80_otdr.asm"
