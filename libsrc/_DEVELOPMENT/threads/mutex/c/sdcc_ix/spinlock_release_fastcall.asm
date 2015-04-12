
; void spinlock_release_fastcall(char *spinlock)

SECTION code_threads_mutex

PUBLIC _spinlock_release_fastcall

_spinlock_release_fastcall:

   INCLUDE "threads/mutex/z80/asm_spinlock_release.asm"
