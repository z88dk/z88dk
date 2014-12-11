
; int mtx_lock(mtx_t *m)

SECTION code_threads_mutex

PUBLIC mtx_lock

mtx_lock:

   INCLUDE "threads/mutex/z80/asm_mtx_lock.asm"
