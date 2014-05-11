
; char *fgets(char *s, int n, FILE *stream)

PUBLIC fgets_unlocked

EXTERN asm_fgets_unlocked

fgets_unlocked:

   pop af
   pop ix
   pop bc
   pop de
   
   push de
   push bc
   push ix
   push af
   
   jp asm_fgets_unlocked
