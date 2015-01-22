
; void flockfile(FILE *file)

SECTION code_stdio

PUBLIC _flockfile

_flockfile:

   pop af
   pop bc
   
   push bc
   push af
   
   push bc
   ex (sp),ix
   
   call asm_flockfile
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_flockfile.asm"
