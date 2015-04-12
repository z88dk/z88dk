
; int mtx_lock_fastcall(mtx_t *m)

SECTION code_threads_mutex

PUBLIC _mtx_lock_fastcall

_mtx_lock_fastcall:
   
   INCLUDE "threads/mutex/z80/asm_mtx_lock.asm"
