
; void *z80_indr(void *dst, uint16_t port)

SECTION code_clib
SECTION code_z80

PUBLIC z80_indr_callee

EXTERN asm_z80_indr

z80_indr_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   jp asm_z80_indr
