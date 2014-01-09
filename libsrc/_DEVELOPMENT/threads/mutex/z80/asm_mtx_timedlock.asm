
*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_MTX_LOCK


; ===============================================================
; Jan 2014
; ===============================================================
; 
; int mtx_timedlock(mtx_t *m, struct timespec *ts)
;
; Block until the mutex is acquired or timeout occurs.
;
; ===============================================================

asm_mtx_timedlock:

   ; enter : hl = mtx_t *m
   ;         bc = struct timespec *ts (0 means no timeout)
   ;
   ; exit  : success
   ;
   ;            hl = thrd_success
   ;            carry reset
   ;
   ;         fail if mutex could not be acquired
   ;
   ;            hl = thrd_error
   ;            carry set
   ;
   ; uses  : af, bc, de, hl
