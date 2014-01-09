
XLIB __mutex_acquire_spinlock

LIB __thread_context_switch

__mutex_acquire_spinlock:

   ; enter : hl = & spinlock
   ;
   ; exit  : hl = & spinlock
   ;         carry reset
   ;         spinlock acquired
   ;
   ; uses  : f

   scf
   rr (hl)                     ; atomic operation
   
   ret nc                      ; if acquisition succeeded

acquisition_failed:

   call __thread_context_switch
   jr __mutex_acquire_spinlock
