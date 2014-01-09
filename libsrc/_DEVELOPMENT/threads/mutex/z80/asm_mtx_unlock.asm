
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

XLIB asm_mtx_unlock

LIB __mutex_acquire_spinlock, __thread_unblock

asm_mtx_unlock:

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

   ld a,(__thrd_id)            ; thread id
   
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
   
   dec hl
   dec hl
   dec hl
   
   ld (hl),0                   ; m->thread_owner = 0
   
   inc hl
   inc hl
   inc hl
   
   call __thread_unblock
   jr c, success               ; another thread was unblocked
   
   ; no waiting threads
   
   ld (hl),$fe                 ; unlock(m->spinlock)

success:

   or a
   ld hl,thrd_success
   ret

fail_not_owner:

   ld hl,thrd_error
   scf
   ret
