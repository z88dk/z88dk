
XDEF ba_bestfit_callee

ba_bestfit_callee:

   pop hl
   pop de
   ex (sp),hl
   ld a,e

INCLUDE "../../z80/asm_ba_bestfit.asm"
