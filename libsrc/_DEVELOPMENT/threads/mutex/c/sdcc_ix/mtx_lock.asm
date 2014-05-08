
; int mtx_lock(mtx_t *m)

PUBLIC _mtx_lock

_mtx_lock:

   pop af
   pop hl
   
   push hl
   push af
   
   INCLUDE "threads/mutex/z80/asm_mtx_lock.asm"
