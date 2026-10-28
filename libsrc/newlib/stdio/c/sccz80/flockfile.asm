
; void flockfile(FILE *file)

SECTION code_clib
SECTION code_stdio

PUBLIC flockfile

EXTERN asm_flockfile

flockfile:

   push hl
   ex (sp),ix

   call asm_flockfile
   pop ix
   ret
