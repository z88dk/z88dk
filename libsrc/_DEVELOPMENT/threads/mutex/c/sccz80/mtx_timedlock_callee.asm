
; int mtx_timedlock(mtx_t *m, struct timespec *ts)

SECTION code_clib
SECTION code_threads_mutex

PUBLIC mtx_timedlock_callee

EXTERN asm_mtx_timedlock

mtx_timedlock_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   jp asm_mtx_timedlock
