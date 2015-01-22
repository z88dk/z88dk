
; int ferror_unlocked(FILE *stream)

SECTION code_stdio

PUBLIC _ferror_unlocked

_ferror_unlocked:

   pop af
   pop bc
   
   push bc
   push af
   
   push bc
   ex (sp),ix
   
   call asm_ferror_unlocked
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_ferror_unlocked.asm"
