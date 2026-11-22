
; int mtx_unlock_fastcall(mtx_t *m)

SECTION code_clib
SECTION code_threads_mutex

PUBLIC _mtx_unlock_fastcall

EXTERN asm_mtx_unlock

defc _mtx_unlock_fastcall = asm_mtx_unlock
