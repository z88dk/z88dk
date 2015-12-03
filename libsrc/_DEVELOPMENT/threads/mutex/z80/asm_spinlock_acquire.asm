
SECTION code_clib
SECTION code_threads_mutex

PUBLIC asm_spinlock_acquire

EXTERN __thread_context_switch

asm_spinlock_acquire:

   ; enter : hl = & spinlock
   ;
   ; exit  : hl = & spinlock
   ;         carry reset
   ;
   ;         spinlock acquired
   ;
   ; uses  : f

   scf
   rr (hl)                     ; atomic operation
   
   ret nc                      ; if acquisition succeeded

acquisition_failed:

   call __thread_context_switch
   jr asm_spinlock_acquire
