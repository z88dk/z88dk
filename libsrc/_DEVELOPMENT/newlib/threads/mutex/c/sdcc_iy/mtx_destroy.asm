
; void mtx_destroy(mtx_t *m)

SECTION code_clib
SECTION code_threads_mutex

PUBLIC _mtx_destroy

EXTERN asm_mtx_destroy

_mtx_destroy:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_mtx_destroy
