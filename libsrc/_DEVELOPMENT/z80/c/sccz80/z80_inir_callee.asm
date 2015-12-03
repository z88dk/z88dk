
; void *z80_inir(void *dst, uint16_t port)

SECTION code_clib
SECTION code_z80

PUBLIC z80_inir_callee

EXTERN asm_z80_inir

z80_inir_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   jp asm_z80_inir
