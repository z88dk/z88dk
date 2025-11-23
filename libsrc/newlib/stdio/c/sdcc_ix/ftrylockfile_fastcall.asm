
; int ftrylockfile_fastcall(FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _ftrylockfile_fastcall

EXTERN asm_ftrylockfile

_ftrylockfile_fastcall:
   
   push hl
   ex (sp),ix
   
   call asm_ftrylockfile
   
   pop ix
   ret
