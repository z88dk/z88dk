
; void mtx_destroy(mtx_t *m)

SECTION code_threads_mutex

PUBLIC mtx_destroy

defc mtx_destroy = asm_mtx_destroy

INCLUDE "threads/mutex/z80/asm_mtx_destroy.asm"
