
; void rewind_unlocked_fastcall(FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _rewind_unlocked_fastcall

EXTERN asm_rewind_unlocked

_rewind_unlocked_fastcall:
   
   push hl
   ex (sp),ix
   
   call asm_rewind_unlocked
   
   pop ix
   ret
