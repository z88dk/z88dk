
; void rewind_unlocked_fastcall(FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC rewind_unlocked_fastcall

EXTERN asm_rewind_unlocked

rewind_unlocked_fastcall:
   
   push hl
   pop ix
   
   jp asm_rewind_unlocked
