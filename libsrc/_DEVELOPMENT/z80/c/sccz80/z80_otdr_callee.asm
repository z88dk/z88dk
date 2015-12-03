
; void *z80_otdr(void *src, uint16_t port)

SECTION code_clib
SECTION code_z80

PUBLIC z80_otdr_callee

EXTERN asm_z80_otdr

z80_otdr_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   jp asm_z80_otdr
