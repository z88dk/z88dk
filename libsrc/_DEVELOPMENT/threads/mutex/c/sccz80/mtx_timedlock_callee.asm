
; int mtx_timedlock(mtx_t *m, struct timespec *ts)

SECTION code_threads_mutex

PUBLIC mtx_timedlock_callee

mtx_timedlock_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   INCLUDE "threads/mutex/z80/asm_mtx_timedlock.asm"
