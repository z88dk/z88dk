
; int spinlock_tryacquire(char *spinlock)

SECTION seg_code_mutex

PUBLIC _spinlock_tryacquire

_spinlock_tryacquire:

   pop af
   pop hl
   
   push hl
   push af

   scf
   rr (hl)
    
   ld hl,1
   ret nc
    
   dec l
   ret
    
   INCLUDE "threads/mutex/z80/asm_spinlock_tryacquire.asm"
