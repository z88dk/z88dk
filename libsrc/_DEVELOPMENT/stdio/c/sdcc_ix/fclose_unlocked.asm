
; int fclose_unlocked(FILE *stream)

SECTION code_stdio

PUBLIC _fclose_unlocked

_fclose_unlocked:

   pop af
   pop bc
   
   push bc
   push af
   
   push bc
   ex (sp),ix
   
   call asm_fclose_unlocked
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_fclose_unlocked.asm"
