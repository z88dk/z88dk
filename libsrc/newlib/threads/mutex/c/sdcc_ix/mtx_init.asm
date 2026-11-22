
; int mtx_init(mtx_t *mtx, int type)

SECTION code_clib
SECTION code_threads_mutex

PUBLIC _mtx_init

EXTERN asm_mtx_init

_mtx_init:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   jp asm_mtx_init
