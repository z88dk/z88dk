
; void spinlock_acquire(char *spinlock)

SECTION code_clib
SECTION code_threads_mutex

PUBLIC spinlock_acquire

EXTERN asm_spinlock_acquire

defc spinlock_acquire = asm_spinlock_acquire
