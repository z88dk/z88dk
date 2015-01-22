
; int ftrylockfile (FILE *stream)

SECTION code_stdio

PUBLIC _ftrylockfile

_ftrylockfile:

   pop af
   pop bc
   
   push bc
   push af
   
   push bc
   ex (sp),ix
   
   call asm_ftrylockfile
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_ftrylockfile.asm"
