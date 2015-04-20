
; int mtx_init_callee(mtx_t *mtx, int type)

SECTION code_threads_mutex

PUBLIC _mtx_init_callee

_mtx_init_callee:

   pop af
   pop hl
   pop bc
   push af
   
   INCLUDE "threads/mutex/z80/asm_mtx_init.asm"
