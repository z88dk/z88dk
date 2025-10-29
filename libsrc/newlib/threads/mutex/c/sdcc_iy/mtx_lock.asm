
; int mtx_lock(mtx_t *m)

SECTION code_clib
SECTION code_threads_mutex

PUBLIC _mtx_lock

EXTERN asm_mtx_lock

_mtx_lock:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_mtx_lock
