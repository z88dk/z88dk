
; int ferror_unlocked_fastcall(FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _ferror_unlocked_fastcall

EXTERN asm_ferror_unlocked

_ferror_unlocked_fastcall:
   
   push hl
   ex (sp),ix
   
   call asm_ferror_unlocked
   
   pop ix
   ret
