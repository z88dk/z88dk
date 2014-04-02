
; int mtx_trylock(mtx_t *m)

XDEF _mtx_trylock

_mtx_trylock:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "threads/mutex/z80/asm_mtx_trylock.asm"
