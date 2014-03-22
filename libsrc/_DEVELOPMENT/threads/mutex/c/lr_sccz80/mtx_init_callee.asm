
; int mtx_init(mtx_t *mtx, int type)

XDEF mtx_init_callee

mtx_init_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   INCLUDE "../../z80/asm_mtx_init.asm"
