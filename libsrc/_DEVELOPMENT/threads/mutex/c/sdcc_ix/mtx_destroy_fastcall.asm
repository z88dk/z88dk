
; void mtx_destroy_fastcall(mtx_t *m)

SECTION code_threads_mutex

PUBLIC _mtx_destroy_fastcall

_mtx_destroy_fastcall:

   INCLUDE "threads/mutex/z80/asm_mtx_destroy.asm"
