
SECTION code_clib
SECTION code_threads_mutex

PUBLIC asm_spinlock_tryacquire

.asm_spinlock_tryacquire

   ; enter : hl = & spinlock
   ;
   ; exit  : hl = & spinlock
   ;         carry reset if spinlock acquired
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
   ret

ELSE

   scf
   rr (hl)                      ; atomic operation

   ret
ENDIF
