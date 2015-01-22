
; void funlockfile(FILE *file)

SECTION code_stdio

PUBLIC _funlockfile

_funlockfile:

   pop af
   pop bc
   
   push bc
   push af
   
   push bc
   ex (sp),ix

   call asm_funlockfile
   
   pop ix
   ret
      
   INCLUDE "stdio/z80/asm_funlockfile.asm"
