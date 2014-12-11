
; int mtx_unlock(mtx_t *m)

SECTION code_threads_mutex

PUBLIC mtx_unlock

mtx_unlock:

   INCLUDE "threads/mutex/z80/asm_mtx_unlock.asm"
