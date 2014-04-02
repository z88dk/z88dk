
; void mtx_destroy(mtx_t *m)

XDEF _mtx_destroy

_mtx_destroy:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "threads/mutex/z80/asm_mtx_destroy.asm"
