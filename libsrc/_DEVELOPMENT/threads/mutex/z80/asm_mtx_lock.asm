
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int mtx_lock(mtx_t *m)
;
; Block until the mutex is acquired.
;
; ===============================================================

SECTION code_clib
SECTION code_threads_mutex

PUBLIC asm_mtx_lock

EXTERN asm_mtx_timedlock

asm_mtx_lock:

   ; enter : hl = mtx_t *m
   ;
   ; exit  : success
   ;
   ;            hl = thrd_success
   ;            carry reset
   ;
   ;         fail if recursive lock count exceeded
   ;         or scheduler unblocks thread (unusual)
   ;
   ;            hl = thrd_error
   ;            carry set
   ;
   ;         fail if mutex invalid
   ;
   ;            hl = -1
   ;            carry set, errno = EINVAL
   ;
   ; uses  : af, bc, de, hl
   
   ld bc,0                     ; no timeout
   jp asm_mtx_timedlock
