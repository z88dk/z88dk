
; int mtx_timedlock(mtx_t *m, struct timespec *ts)

XDEF mtx_timedlock_callee

mtx_timedlock_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   INCLUDE "threads/mutex/z80/asm_mtx_timedlock.asm"
