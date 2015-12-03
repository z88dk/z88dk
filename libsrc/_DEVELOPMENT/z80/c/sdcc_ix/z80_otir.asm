
; void *z80_otir(void *src, uint16_t port)

SECTION code_clib
SECTION code_z80

PUBLIC _z80_otir

EXTERN asm_z80_otir

_z80_otir:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   jp asm_z80_otir
