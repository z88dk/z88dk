
; void mtx_destroy(mtx_t *m)

XDEF mtx_destroy

mtx_destroy:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_mtx_destroy

   INCLUDE "../../z80/asm_mtx_destroy.asm"
