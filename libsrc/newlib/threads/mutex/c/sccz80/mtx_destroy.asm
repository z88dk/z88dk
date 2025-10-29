
; void mtx_destroy(mtx_t *m)

SECTION code_clib
SECTION code_threads_mutex

PUBLIC mtx_destroy

EXTERN asm_mtx_destroy

defc mtx_destroy = asm_mtx_destroy
