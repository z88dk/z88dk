
SECTION code_clib
SECTION code_threads_mutex

PUBLIC asm_spinlock_tryacquire

asm_spinlock_tryacquire:

   ; enter : hl = & spinlock
   ;
   ; exit  : hl = & spinlock
   ;         carry reset if spinlock acquired
   ;
   ; uses  : f

   scf
   rr (hl)                     ; atomic operation
   
   ret
