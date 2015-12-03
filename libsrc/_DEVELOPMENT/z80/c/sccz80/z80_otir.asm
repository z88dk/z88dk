
; void *z80_otir(void *src, uint16_t port)

SECTION code_clib
SECTION code_z80

PUBLIC z80_otir

EXTERN asm_z80_otir

z80_otir:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_z80_otir
