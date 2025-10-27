
; void spinlock_release(char *spinlock)

SECTION code_clib
SECTION code_threads_mutex

PUBLIC spinlock_release

EXTERN asm_spinlock_release

defc spinlock_release = asm_spinlock_release
