
; unsigned long ftell_unlocked(FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _ftell_unlocked

EXTERN asm_ftell_unlocked

_ftell_unlocked:

   pop af
   pop ix
   
   push hl
   push af
   
   jp asm_ftell_unlocked
