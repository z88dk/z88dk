
; int mtx_trylock(mtx_t *m)

SECTION code_clib
SECTION code_threads_mutex

PUBLIC mtx_trylock

EXTERN asm_mtx_trylock

defc mtx_trylock = asm_mtx_trylock
