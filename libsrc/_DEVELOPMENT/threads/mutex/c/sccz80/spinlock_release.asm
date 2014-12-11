
; void spinlock_release(char *spinlock)

SECTION code_threads_mutex

PUBLIC spinlock_release

spinlock_release:

   INCLUDE "threads/mutex/z80/asm_spinlock_release.asm"
