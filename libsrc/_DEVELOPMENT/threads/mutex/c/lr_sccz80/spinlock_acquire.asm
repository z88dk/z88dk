
; void spinlock_acquire(char *spinlock)

XDEF spinlock_acquire

spinlock_acquire:

   INCLUDE "../../z80/asm_spinlock_acquire.asm"
