
; void flockfile(FILE *file)

XDEF flockfile

flockfile:

   push hl
   pop ix
   
   INCLUDE "../../z80/__stdio_lock_acquire.asm"
