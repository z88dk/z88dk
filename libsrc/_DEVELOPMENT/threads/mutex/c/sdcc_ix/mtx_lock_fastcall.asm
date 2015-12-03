
; int mtx_lock_fastcall(mtx_t *m)

SECTION code_clib
SECTION code_threads_mutex

PUBLIC _mtx_lock_fastcall

EXTERN asm_mtx_lock

defc _mtx_lock_fastcall = asm_mtx_lock
