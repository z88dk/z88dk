
; int mtx_timedlock(mtx_t *m, struct timespec *ts)

PUBLIC mtx_timedlock

EXTERN asm_mtx_timedlock

mtx_timedlock:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_mtx_timedlock
