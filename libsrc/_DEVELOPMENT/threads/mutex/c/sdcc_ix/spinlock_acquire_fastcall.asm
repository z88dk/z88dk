
; void spinlock_acquire_fastcall(char *spinlock)

SECTION code_threads_mutex

PUBLIC _spinlock_acquire_fastcall

_spinlock_acquire_fastcall:
   
   INCLUDE "threads/mutex/z80/asm_spinlock_acquire.asm"
