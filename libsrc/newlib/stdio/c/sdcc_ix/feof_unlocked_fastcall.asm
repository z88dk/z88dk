
; int feof_unlocked(FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _feof_unlocked_fastcall

EXTERN asm_feof_unlocked

_feof_unlocked_fastcall:

   push hl
   ex (sp),ix
   
   call asm_feof_unlocked
   
   pop ix
   ret
