
; int mtx_init(mtx_t *mtx, int type)

PUBLIC mtx_init_callee

mtx_init_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   INCLUDE "threads/mutex/z80/asm_mtx_init.asm"
