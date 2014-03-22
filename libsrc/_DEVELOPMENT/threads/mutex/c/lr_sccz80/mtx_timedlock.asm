
; int mtx_timedlock(mtx_t *m, struct timespec *ts)

XLIB mtx_timedlock

LIB asm_mtx_timedlock

mtx_timedlock:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_mtx_timedlock
