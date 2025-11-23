
; int mtx_timedlock_callee(mtx_t *m, struct timespec *ts)

SECTION code_clib
SECTION code_threads_mutex

PUBLIC _mtx_timedlock_callee

EXTERN asm_mtx_timedlock

_mtx_timedlock_callee:

   pop af
   pop hl
   pop bc
   push af
   
   jp asm_mtx_timedlock
