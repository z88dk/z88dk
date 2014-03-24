
; void spinlock_release(char *spinlock)

XDEF spinlock_release

spinlock_release:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "threads/mutex/z80/asm_spinlock_release.asm"
