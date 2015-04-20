
; int mtx_timedlock_callee(mtx_t *m, struct timespec *ts)

SECTION code_threads_mutex

PUBLIC _mtx_timedlock_callee

_mtx_timedlock_callee:

   pop af
   pop hl
   pop bc
   push af
   
   INCLUDE "threads/mutex/z80/asm_mtx_timedlock.asm"
