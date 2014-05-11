
; void spinlock_acquire(char *spinlock)

PUBLIC spinlock_acquire

spinlock_acquire:

   INCLUDE "threads/mutex/z80/asm_spinlock_acquire.asm"
