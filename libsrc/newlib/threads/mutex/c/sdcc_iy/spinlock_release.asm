
; void spinlock_release(char *spinlock)

SECTION code_clib
SECTION code_threads_mutex

PUBLIC _spinlock_release

EXTERN asm_spinlock_release

_spinlock_release:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_spinlock_release
