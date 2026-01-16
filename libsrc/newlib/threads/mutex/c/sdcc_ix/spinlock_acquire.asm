
; void spinlock_acquire(char *spinlock)

SECTION code_clib
SECTION code_threads_mutex

PUBLIC _spinlock_acquire

EXTERN asm_spinlock_acquire

_spinlock_acquire:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_spinlock_acquire
