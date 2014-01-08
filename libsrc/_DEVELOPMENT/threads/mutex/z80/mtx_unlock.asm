
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int mtx_unlock(mtx_t *m)
;
; Unlock the mutex.
;
; ===============================================================

INCLUDE "../mutex.inc"

XLIB mtx_unlock

LIB __mutex_acquire_spinlock, __thread_unblock

mtx_unlock:

   ; enter : hl = mtx_t *m
   ;
   ; exit  : success
   ;
   ;            hl = thrd_success
   ;            carry reset
   ;
   ;         fail thread does not own lock
   ;
   ;            hl = thrd_error
   ;            carry set
   ;
   ; uses  : af, bc, de, hl

   ld a,(thrd_id)              ; thread id
   
   cp (hl)                     ; compare against current mutex owner
   jr nz, fail_not_owner

reduce_lock_count:

   inc hl
   inc hl
   
   dec (hl)                    ; m->lock_count--
   jr nz, success              ; if lock_count remains > 0

relinquish_ownership:

   inc hl                      ; hl = & m->spinlock
   
   call __mutex_acquire_spinlock
   call __thread_unblock
   
   ;  a = unblocked thread id (maybe 0)
   ; hl = & m->spinlock
   
   dec hl
   dec hl
   dec hl                      ; hl = mtx_t *m
   
   ld (hl),a                   ; m->thread_owner = unblocked thread
   
   inc hl
   inc hl
   
   ld (hl),1                   ; m->lock_count = 1
   
   inc hl
   ld (hl),$fe                 ; unlock(m->spinlock)
   
   or a

success:

   ld hl,thrd_success
   ret

fail_not_owner:

   ld hl,thrd_error
   scf
   ret
