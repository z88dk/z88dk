
; int mtx_init_callee(mtx_t *mtx, int type)

SECTION code_clib
SECTION code_threads_mutex

PUBLIC _mtx_init_callee

EXTERN asm_mtx_init

_mtx_init_callee:

   pop af
   pop hl
   pop bc
   push af
   
   jp asm_mtx_init
