
; void clearerr_unlocked_fastcall(FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _clearerr_unlocked_fastcall

EXTERN asm_clearerr_unlocked

_clearerr_unlocked_fastcall:
   
   push hl
   ex (sp),ix
   
   call asm_clearerr_unlocked
   
   pop ix
   ret
