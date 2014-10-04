
; void *zx_saddrpright(void *saddr, uint bitmask)

SECTION seg_code_arch

PUBLIC zx_saddrpright_callee

zx_saddrpright_callee:

   pop hl
   pop de
   ex (sp),hl
   
   INCLUDE "arch/zx/display/z80/asm_zx_saddrpright.asm"
