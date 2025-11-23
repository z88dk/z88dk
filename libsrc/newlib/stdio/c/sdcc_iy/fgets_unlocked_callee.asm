
; char *fgets_unlocked_callee(char *s, int n, FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _fgets_unlocked_callee

EXTERN asm_fgets_unlocked

_fgets_unlocked_callee:

   pop af
   pop de
   pop bc
   pop ix
   push af
   
   jp asm_fgets_unlocked
