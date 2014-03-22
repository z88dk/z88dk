
; int spinlock_tryacquire(char *spinlock)

XDEF spinlock_tryacquire

spinlock_tryacquire:

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
    
   INCLUDE "../../z80/asm_spinlock_tryacquire.asm"
