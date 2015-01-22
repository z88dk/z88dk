
; int fgetc_unlocked(FILE *stream)

SECTION code_stdio

PUBLIC _fgetc_unlocked

_fgetc_unlocked:

   pop af
   pop bc
   
   push bc
   push af
   
   push bc
   ex (sp),ix

   call asm_fgetc_unlocked
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_fgetc_unlocked.asm"
