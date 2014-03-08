
; void *zx_saddrpright(void *saddr, uint bitmask)

XDEF zx_saddrpright_callee

zx_saddrpright_callee:

   pop hl
   pop de
   ex (sp),hl
   
   INCLUDE "../../z80/asm_zx_saddrpright.asm"
