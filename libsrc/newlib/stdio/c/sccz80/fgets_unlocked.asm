
; char *fgets(char *s, int n, FILE *stream)

SECTION code_clib
SECTION code_stdio

PUBLIC fgets_unlocked

EXTERN asm_fgets_unlocked

fgets_unlocked:

   pop af
   pop ix
   pop bc
   pop de
   
   push de
   push bc
   push hl
   push af
   
   jp asm_fgets_unlocked
