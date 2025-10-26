
; int mtx_lock(mtx_t *m)

SECTION code_clib
SECTION code_threads_mutex

PUBLIC mtx_lock

EXTERN asm_mtx_lock

defc mtx_lock = asm_mtx_lock
