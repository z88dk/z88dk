
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int mtx_unlock(mtx_t *m)
;
; Unlock the mutex.
;
; ===============================================================

SECTION code_clib
SECTION code_threads_mutex

PUBLIC asm_mtx_unlock

EXTERN __thrd_id, thrd_success, thrd_error
EXTERN asm_spinlock_acquire, __thread_unblock, error_einval_mc

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
   ;         fail if mutex invalid
   ;
   ;            hl = -1
   ;            carry set, errno = EINVAL
   ;
   ; uses  : af, bc, de, hl

   inc hl
   ld a,(hl)                   ; a = mutex_type
   dec hl
   
   or a
   jp z, error_einval_mc       ; if mutex invalid

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
   
   call asm_spinlock_acquire
   
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
