
; int fgetc_unlocked_fastcall(FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _fgetc_unlocked_fastcall

EXTERN asm_fgetc_unlocked

_fgetc_unlocked_fastcall:

   push hl
   ex (sp),ix

   call asm_fgetc_unlocked
   
   pop ix
   ret
