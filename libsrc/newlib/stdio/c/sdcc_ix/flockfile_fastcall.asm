
; void flockfile_fastcall(FILE *file)

SECTION code_clib
SECTION code_stdio

PUBLIC _flockfile_fastcall

EXTERN asm_flockfile

_flockfile_fastcall:

   push hl
   ex (sp),ix
   
   call asm_flockfile
   
   pop ix
   ret
