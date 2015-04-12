
; int ftrylockfile_fastcall(FILE *stream)

SECTION code_stdio

PUBLIC _ftrylockfile_fastcall

_ftrylockfile_fastcall:
   
   push hl
   ex (sp),ix
   
   call asm_ftrylockfile
   
   pop ix
   ret
   
   INCLUDE "stdio/z80/asm_ftrylockfile.asm"
