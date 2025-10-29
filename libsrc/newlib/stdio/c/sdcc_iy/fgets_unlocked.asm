
; char *fgets(char *s, int n, FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC _fgets_unlocked

EXTERN asm_fgets_unlocked

_fgets_unlocked:

   pop af
   pop de
   pop bc
   pop ix
   
   push hl
   push bc
   push de
   push af
   
   jp asm_fgets_unlocked
