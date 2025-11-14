
; unsigned long ftell_unlocked(FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC ftell_unlocked

EXTERN asm_ftell_unlocked

ftell_unlocked:

   push hl
   pop ix
   
   jp asm_ftell_unlocked
