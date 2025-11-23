
; void spinlock_acquire_fastcall(char *spinlock)

SECTION code_clib
SECTION code_threads_mutex

PUBLIC _spinlock_acquire_fastcall

EXTERN asm_spinlock_acquire

defc _spinlock_acquire_fastcall = asm_spinlock_acquire
