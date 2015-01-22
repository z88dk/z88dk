
; void rewind_unlocked(FILE *stream)

SECTION code_stdio

PUBLIC rewind_unlocked

rewind_unlocked:

   pop af
   pop bc
   
   push bc
   push af
   
   push bc
   ex (sp),ix
   
   call asm_rewind_unlocked
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_rewind_unlocked.asm"
