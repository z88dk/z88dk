
; char *fgets(char *s, int n, FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC fgets_unlocked_callee

EXTERN asm_fgets_unlocked

fgets_unlocked_callee:

   pop af
   pop ix
   pop bc
   pop de
   push af
   
   jp asm_fgets_unlocked
