
; int spinlock_tryacquire(char *spinlock)

SECTION code_clib
SECTION code_threads_mutex

PUBLIC spinlock_tryacquire

spinlock_tryacquire:

   scf
   rr (hl)
    
   ld hl,1
   ret nc
    
   dec l
   ret
