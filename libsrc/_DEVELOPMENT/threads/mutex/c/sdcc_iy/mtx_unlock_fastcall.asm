
; int mtx_unlock_fastcall(mtx_t *m)

SECTION code_threads_mutex

PUBLIC _mtx_unlock_fastcall

_mtx_unlock_fastcall:

   INCLUDE "threads/mutex/z80/asm_mtx_unlock.asm"
