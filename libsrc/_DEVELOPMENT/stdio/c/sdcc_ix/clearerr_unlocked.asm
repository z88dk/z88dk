
; void clearerr_unlocked(FILE *stream)

SECTION code_stdio

PUBLIC _clearerr_unlocked

_clearerr_unlocked:

   pop af
   pop bc
   
   push bc
   push af
   
   push bc
   ex (sp),ix
   
   call asm_clearerr_unlocked
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_clearerr_unlocked.asm"
