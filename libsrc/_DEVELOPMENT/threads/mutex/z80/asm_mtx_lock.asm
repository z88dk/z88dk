
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int mtx_lock(mtx_t *m)
;
; Block until the mutex is acquired.
;
; ===============================================================

INCLUDE "../mutex.inc"

XLIB asm_mtx_lock
XDEF asm_mtx_timedlock

LIB __mutex_acquire_spinlock, __thread_block_timeout

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
   ; uses  : af, bc, de, hl
   
   ld bc,0                     ; no timeout

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

   ld a,(__thrd_id)            ; thread id
   
   cp (hl)                     ; compare against current mutex owner
   inc hl                      ; hl = & mutex_type
   
   jr z, mutex_owned           ; if thread owns mutex already
   
   inc hl
   inc hl                      ; hl = & m->spinlock
   
   call __mutex_acquire_spinlock
   
   dec hl
   dec hl
   dec hl                      ; hl = mtx_t *m
   
   ld a,(hl)
   or a
   jr z, mutex_acquired        ; if mutex not currently owned
   
failed_acquire:

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
   jr nz, lock_failed          ; if hl = thrd_error
   
   ; this thread now owns the mutex and spinlock is acquired
   
   pop hl                      ; hl = & m->spinlock
   
   dec hl
   dec hl
   dec hl                      ; hl = mtx_t *m

mutex_acquired:

   ld a,(__thrd_id)
   
   ld (hl),a                   ; claim ownership
   
   inc hl
   inc hl
   
   ld (hl),1                   ; m->lock_count = 1
   
   inc hl
   ld (hl),$fe                 ; unlock(m->spinlock)
   
lock_success:

   ld hl,thrd_success
   ret

lock_failed:

   pop bc                      ; junk item
   
   scf
   ret

mutex_owned:

   ; hl = & m->mutex_type
   ; carry reset

   bit 0,(hl)                  ; test recursive bit on type
   jr z, lock_success

recursive:

   inc hl                      ; hl = & m->lock_count
   
   inc (hl)                    ; m->lock_count++
   jr nz, lock_success
   
   ; lock count limit exceeded
   
   dec (hl)                    ; m->lock_count = 255

   ld hl,thrd_error
   scf
   ret
