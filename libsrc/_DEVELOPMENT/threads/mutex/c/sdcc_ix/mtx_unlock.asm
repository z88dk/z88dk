
; int mtx_unlock(mtx_t *m)

SECTION seg_code_mutex

PUBLIC _mtx_unlock

_mtx_unlock:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "threads/mutex/z80/asm_mtx_unlock.asm"
