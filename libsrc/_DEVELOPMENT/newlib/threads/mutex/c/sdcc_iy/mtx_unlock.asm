
; int mtx_unlock(mtx_t *m)

SECTION code_clib
SECTION code_threads_mutex

PUBLIC _mtx_unlock

EXTERN asm_mtx_unlock

_mtx_unlock:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_mtx_unlock
