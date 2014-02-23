
; void funlockfile(FILE *file)

XDEF funlockfile

funlockfile:

   push hl
   pop ix
   
   INCLUDE "../../z80/__stdio_lock_release.asm"
