
; int spinlock_tryacquire(char *spinlock)

SECTION code_clib
SECTION code_threads_mutex

PUBLIC _spinlock_tryacquire

EXTERN _spinlock_tryacquire_fastcall

_spinlock_tryacquire:

   pop af
   pop hl
   
   push hl
   push af

   jp _spinlock_tryacquire_fastcall
