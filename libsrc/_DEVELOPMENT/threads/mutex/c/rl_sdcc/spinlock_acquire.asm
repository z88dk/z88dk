
; void spinlock_acquire(char *spinlock)

XDEF spinlock_acquire

spinlock_acquire:

   pop af
   pop hl
   
   push hl
   push af
   
   INCLUDE "../../z80/asm_spinlock_acquire.asm"
