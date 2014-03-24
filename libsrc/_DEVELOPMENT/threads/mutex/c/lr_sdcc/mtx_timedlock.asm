
; int mtx_timedlock(mtx_t *m, struct timespec *ts)

XDEF mtx_timedlock

mtx_timedlock:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   INCLUDE "threads/mutex/z80/asm_mtx_timedlock.asm"
