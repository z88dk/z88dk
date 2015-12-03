
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int mtx_trylock(mtx_t *m)
;
; Attempt to acquire the mutex but does not block if unsuccessful.
;
; ===============================================================

SECTION code_clib
SECTION code_threads_mutex

PUBLIC asm_mtx_trylock

EXTERN __thrd_id, thrd_success, thrd_error, thrd_busy
EXTERN asm_spinlock_acquire, error_einval_mc

asm_mtx_trylock:

   ; enter : hl = mtx_t *m
   ;
   ; exit  : success
   ;
   ;            hl = thrd_success
   ;            carry reset
   ;
   ;         fail if lock would block
   ;
   ;            hl = thrd_busy
   ;            carry set
   ;
   ;         fail if recursive lock count exceeded
   ;
   ;            hl = thrd_error
   ;            carry set
   ;
   ;         fail if mutex invalid
   ;
   ;            hl = -1
   ;            carry set, errno = EINVAL
   ;
   ; uses  : af, hl
   
   inc hl
   ld a,(hl)                   ; a = mutex_type
   dec hl
   
   or a
   jp z, error_einval_mc       ; if mutex is invalid
   
   ld a,(__thrd_id)            ; thread id
   
   cp (hl)                     ; compare against current mutex owner
   inc hl                      ; hl = & mutex_type

   jr z, mutex_owned           ; if thread owns mutex already

   inc hl
   inc hl                      ; hl = & m->spinlock

   call asm_spinlock_acquire

   dec hl
   dec hl
   dec hl                      ; hl = mtx_t *m
   
   ld a,(hl)
   or a
   jr z, mutex_acquired        ; if mutex not currently owned

trylock_failed:

   inc hl
   inc hl
   inc hl                      ; hl = & m->spinlock
   
   ld (hl),$fe                 ; unlock(m->spinlock)

   ld hl,thrd_busy
   scf
   ret

mutex_acquired:

   ld a,(__thrd_id)            ; thread id
   
   ld (hl),a                   ; m->owner = thread id
   
   inc hl
   inc hl
   
   ld (hl),1                   ; m->lock_count = 1
   
   inc hl
   ld (hl),$fe                 ; unlock(m->spinlock)
   
   jr trylock_success

mutex_owned:

   ; hl = & m->mutex_type
   ; carry reset

   bit 1,(hl)                  ; test recursive bit on type
   jr z, trylock_success

recursive:

   inc hl                      ; hl = & m->lock_count
   
   inc (hl)                    ; m->lock_count++
   jr nz, trylock_success
   
   ; lock count limit exceeded
   
   dec (hl)                    ; m->lock_count = 255

   ld hl,thrd_error
   scf
   ret

trylock_success:

   ld hl,thrd_success
   ret
