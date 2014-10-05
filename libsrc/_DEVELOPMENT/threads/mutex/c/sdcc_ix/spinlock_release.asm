
; void spinlock_release(char *spinlock)

SECTION seg_code_mutex

PUBLIC _spinlock_release

_spinlock_release:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "threads/mutex/z80/asm_spinlock_release.asm"
