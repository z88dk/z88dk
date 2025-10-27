
; int mtx_unlock(mtx_t *m)

SECTION code_clib
SECTION code_threads_mutex

PUBLIC mtx_unlock

EXTERN asm_mtx_unlock

defc mtx_unlock = asm_mtx_unlock
