
; int mtx_init(mtx_t *mtx, int type)

SECTION seg_code_mutex

PUBLIC mtx_init_callee

mtx_init_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   INCLUDE "threads/mutex/z80/asm_mtx_init.asm"
