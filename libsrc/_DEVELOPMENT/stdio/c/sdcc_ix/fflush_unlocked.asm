
; int fflush_unlocked(FILE *stream)

SECTION code_stdio

PUBLIC _fflush_unlocked

_fflush_unlocked:

   pop af
   pop bc
   
   push bc
   push af
   
   push bc
   ex (sp),ix
   
   call asm_fflush_unlocked
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_fflush_unlocked.asm"
