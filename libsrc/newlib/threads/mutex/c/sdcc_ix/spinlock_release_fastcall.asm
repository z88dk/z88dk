
; void spinlock_release_fastcall(char *spinlock)

SECTION code_clib
SECTION code_threads_mutex

PUBLIC _spinlock_release_fastcall

EXTERN asm_spinlock_release

defc _spinlock_release_fastcall = asm_spinlock_release
