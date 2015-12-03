
; void *z80_inir_callee(void *dst, uint16_t port)

SECTION code_clib
SECTION code_z80

PUBLIC _z80_inir_callee

EXTERN asm_z80_inir

_z80_inir_callee:

   pop af
   pop hl
   pop bc
   push af
   
   jp asm_z80_inir
