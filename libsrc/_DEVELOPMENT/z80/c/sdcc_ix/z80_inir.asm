
; void *z80_inir(void *dst, uint16_t port)

SECTION code_clib
SECTION code_z80

PUBLIC _z80_inir

EXTERN asm_z80_inir

_z80_inir:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   jp asm_z80_inir
