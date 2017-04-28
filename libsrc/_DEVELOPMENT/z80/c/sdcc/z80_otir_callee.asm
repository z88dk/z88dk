
; void *z80_otir_callee(void *src, uint8_t port, uint8_t num)

SECTION code_clib
SECTION code_z80

PUBLIC _z80_otir_callee

EXTERN asm_z80_otir

_z80_otir_callee:

   pop af
   pop hl
   pop bc
   push af
   
  jp asm_z80_otir
