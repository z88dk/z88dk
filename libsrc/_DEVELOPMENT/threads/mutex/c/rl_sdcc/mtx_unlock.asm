
; int mtx_unlock(mtx_t *m)

XDEF mtx_unlock

mtx_unlock:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "../../z80/asm_mtx_unlock.asm"
