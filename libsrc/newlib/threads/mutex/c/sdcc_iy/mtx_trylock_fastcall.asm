
; int mtx_trylock_fastcall(mtx_t *m)

SECTION code_clib
SECTION code_threads_mutex

PUBLIC _mtx_trylock_fastcall

EXTERN asm_mtx_trylock

defc _mtx_trylock_fastcall = asm_mtx_trylock
