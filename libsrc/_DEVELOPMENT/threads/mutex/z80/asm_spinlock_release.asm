
SECTION code_clib
SECTION code_threads_mutex

PUBLIC asm_spinlock_release

asm_spinlock_release:

   ; enter : hl = & spinlock
   ;
   ; exit  : hl = & spinlock
   ;
   ; uses  : none
   
   ld (hl),$fe                 ; atomic operation
   ret
