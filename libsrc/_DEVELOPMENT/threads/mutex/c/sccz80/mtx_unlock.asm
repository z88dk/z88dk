
; int mtx_unlock(mtx_t *m)

SECTION seg_code_mutex

PUBLIC mtx_unlock

mtx_unlock:

   INCLUDE "threads/mutex/z80/asm_mtx_unlock.asm"
