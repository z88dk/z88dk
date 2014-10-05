
; int mtx_trylock(mtx_t *m)

SECTION seg_code_mutex

PUBLIC mtx_trylock

mtx_trylock:

   INCLUDE "threads/mutex/z80/asm_mtx_trylock.asm"
