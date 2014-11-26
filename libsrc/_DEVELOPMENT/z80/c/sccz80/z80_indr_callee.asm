
; void *z80_indr(void *dst, uint16_t port)

SECTION seg_code_z80

PUBLIC z80_indr_callee

z80_indr_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   INCLUDE "z80/z80/asm_z80_indr.asm"
