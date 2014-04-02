
; int mtx_timedlock(mtx_t *m, struct timespec *ts)

XDEF _mtx_timedlock

_mtx_timedlock:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   INCLUDE "threads/mutex/z80/asm_mtx_timedlock.asm"
