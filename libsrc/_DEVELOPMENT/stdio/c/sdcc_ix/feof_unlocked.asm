
; int feof_unlocked(FILE *stream)

SECTION code_stdio

PUBLIC _feof_unlocked

_feof_unlocked:

   pop af
   pop bc
   
   push bc
   push af
   
   push bc
   ex (sp),ix
   
   call asm_feof_unlocked
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_feof_unlocked.asm"
