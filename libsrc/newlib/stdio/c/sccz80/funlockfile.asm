
; void funlockfile(FILE *file)

SECTION code_clib
SECTION code_stdio

PUBLIC funlockfile

EXTERN asm_funlockfile

funlockfile:

   push hl
   ex (sp),ix

   call asm_funlockfile
   pop ix
   ret
