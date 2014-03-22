
; int mtx_timedlock(mtx_t *m, struct timespec *ts)

XDEF mtx_timedlock

mtx_timedlock:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   INCLUDE "../../z80/asm_mtx_timedlock.asm"
