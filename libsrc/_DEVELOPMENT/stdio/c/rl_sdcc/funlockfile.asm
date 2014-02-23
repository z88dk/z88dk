
; void funlockfile(FILE *file)

XDEF funlockfile

funlockfile:

   pop af
   pop bc
   
   push bc
   push af
   
   push ix
   
   ld ixl,c
   ld ixh,b
   
   call __stdio_lock_release
   
   pop ix
   ret
   
   INCLUDE "../../z80/__stdio_lock_release.asm"
