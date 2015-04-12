
; int mtx_trylock_fastcall(mtx_t *m)

SECTION code_threads_mutex

PUBLIC _mtx_trylock_fastcall

_mtx_trylock_fastcall:

   INCLUDE "threads/mutex/z80/asm_mtx_trylock.asm"
