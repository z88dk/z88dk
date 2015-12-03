
; int mtx_timedlock(mtx_t *m, struct timespec *ts)

SECTION code_clib
SECTION code_threads_mutex

PUBLIC _mtx_timedlock

EXTERN asm_mtx_timedlock

_mtx_timedlock:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   jp asm_mtx_timedlock
