
; void funlockfile_fastcall(FILE *file)

SECTION code_stdio

PUBLIC _funlockfile_fastcall

_funlockfile_fastcall:
   
   push hl
   ex (sp),ix

   call asm_funlockfile
   
   pop ix
   ret
      
   INCLUDE "stdio/z80/asm_funlockfile.asm"
