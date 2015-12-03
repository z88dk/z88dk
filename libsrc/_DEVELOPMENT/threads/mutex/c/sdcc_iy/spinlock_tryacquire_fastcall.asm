
; int spinlock_tryacquire_fastcall(char *spinlock)

SECTION code_clib
SECTION code_threads_mutex

PUBLIC _spinlock_tryacquire_fastcall

_spinlock_tryacquire_fastcall:

   scf
   rr (hl)
    
   ld hl,1
   ret nc
    
   dec l
   ret
