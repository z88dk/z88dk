
; int fileno_unlocked_fastcall(FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _fileno_unlocked_fastcall

EXTERN asm_fileno_unlocked

_fileno_unlocked_fastcall:
   
   push hl
   ex (sp),ix
   
   call asm_fileno_unlocked
   
   pop ix
   ret
