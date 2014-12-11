
; void spinlock_acquire(char *spinlock)

SECTION code_threads_mutex

PUBLIC spinlock_acquire

spinlock_acquire:

   INCLUDE "threads/mutex/z80/asm_spinlock_acquire.asm"
