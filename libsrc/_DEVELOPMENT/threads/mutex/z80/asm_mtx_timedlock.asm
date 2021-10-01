
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int mtx_timedlock(mtx_t *m, struct timespec *ts)
;
; Block until the mutex is acquired or timeout occurs.
;
; ===============================================================

SECTION code_clib
SECTION code_threads_mutex

PUBLIC asm_mtx_timedlock

EXTERN __thrd_id, thrd_success, thrd_error
EXTERN asm_spinlock_acquire, __thread_block_timeout, error_einval_mc

.asm_mtx_timedlock

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
   jp Z, error_einval_mc       ; if mutex invalid

   ld a,(__thrd_id)            ; thread id
   
   cp (hl)                     ; compare against current mutex owner
   inc hl                      ; hl = & mutex_type
   
   jr Z, mutex_owned           ; if thread owns mutex already
   
   inc hl
   inc hl                      ; hl = & m->spinlock
   
   call asm_spinlock_acquire
   
   dec hl
   dec hl
   dec hl                      ; hl = mtx_t *m
   
   ld a,(hl)
   or a
   jr Z, mutex_acquired        ; if mutex not currently owned
   
.failed_acquire

   inc hl
   inc hl
   inc hl
   
   push hl
   
   ; hl = & m->spinlock
   ; bc = timeout
   ; stack = & m->spinlock
   
   call __thread_block_timeout
   
   ; hl = thrd_error or thrd_success
   ; stack = & m->spinlock
   
   ld a,h
   or l
   jr NZ, lock_failed          ; if hl = thrd_error
   
   ; this thread now owns the mutex and spinlock is acquired
   
   pop hl                      ; hl = & m->spinlock
   
   dec hl
   dec hl
   dec hl                      ; hl = mtx_t *m

.mutex_acquired

   ld a,(__thrd_id)
   
   ld (hl),a                   ; claim ownership
   
   inc hl
   inc hl
   
   ld (hl),1                   ; m->lock_count = 1
   
   inc hl
IF __CPU_INTEL__
   dec (hl)                    ; unlock(m->spinlock)
ELSE
   ld (hl),$fe                 ; unlock(m->spinlock)
ENDIF
   
.lock_success

   ld hl,thrd_success
   ret

.lock_failed

   pop bc                      ; junk item
   
   scf
   ret

.mutex_owned

   ; hl = & m->mutex_type
   ; carry reset
   
IF __CPU_INTEL__
   ld a,(hl)                  ; test recursive bit on type
   rrca
   rrca
   jr NC, lock_success
ELSE
   bit 1,(hl)                  ; test recursive bit on type
   jr Z, lock_success
ENDIF

.recursive

   inc hl                      ; hl = & m->lock_count
   
   inc (hl)                    ; m->lock_count++
   jr NZ, lock_success
   
   ; lock count limit exceeded
   
   dec (hl)                    ; m->lock_count = 255

   ld hl,thrd_error
   scf
   ret
