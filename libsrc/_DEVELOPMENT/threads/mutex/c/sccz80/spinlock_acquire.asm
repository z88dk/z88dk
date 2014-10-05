
; void spinlock_acquire(char *spinlock)

SECTION seg_code_mutex

PUBLIC spinlock_acquire

spinlock_acquire:

   INCLUDE "threads/mutex/z80/asm_spinlock_acquire.asm"
