
; void *z80_inir(void *dst, uint16_t port)

SECTION seg_code_z80

PUBLIC z80_inir

EXTERN asm_z80_inir

z80_inir:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_z80_inir
