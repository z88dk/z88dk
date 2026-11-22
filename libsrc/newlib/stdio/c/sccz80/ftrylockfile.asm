
; int ftrylockfile (FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC ftrylockfile

EXTERN asm_ftrylockfile

ftrylockfile:

   push hl
   ex (sp),ix

   call asm_ftrylockfile
   pop ix
   ret
