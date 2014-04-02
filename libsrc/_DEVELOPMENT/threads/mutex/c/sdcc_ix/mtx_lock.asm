
; int mtx_lock(mtx_t *m)

XDEF _mtx_lock

_mtx_lock:

   pop af
   pop hl
   
   push hl
   push af
   
   INCLUDE "threads/mutex/z80/asm_mtx_lock.asm"
