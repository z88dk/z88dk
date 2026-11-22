
SECTION code_clib
SECTION code_threads_mutex

PUBLIC asm_spinlock_acquire

EXTERN __thread_context_switch

.asm_spinlock_acquire

   ; enter : hl = & spinlock
   ;
   ; exit  : hl = & spinlock
   ;         carry reset
   ;
   ;         spinlock acquired
   ;
   ; uses  : f

IF __CPU_INTEL__

   scf
   inc (hl)                     ; atomic operation
   jp NZ,acquisition_failed

   ccf                          ; if acquisition succeeded
   ret

.acquisition_failed
   dec (hl)

ELSE

   scf
   rr (hl)                     ; atomic operation
   ret NC                      ; if acquisition succeeded

.acquisition_failed

ENDIF

   call __thread_context_switch
   jr asm_spinlock_acquire
