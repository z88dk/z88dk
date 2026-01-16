
; void mtx_destroy_fastcall(mtx_t *m)

SECTION code_clib
SECTION code_threads_mutex

PUBLIC _mtx_destroy_fastcall

EXTERN asm_mtx_destroy

defc _mtx_destroy_fastcall = asm_mtx_destroy
