
; void flockfile(FILE *file)

XDEF flockfile

flockfile:

   pop af
   pop bc
   
   push bc
   push af
   
   push ix
   
   ld ixl,c
   ld ixh,b
   
   call __stdio_lock_acquire
   
   pop ix
   ret

   INCLUDE "../../z80/__stdio_lock_acquire.asm"
