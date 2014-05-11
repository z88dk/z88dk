
; FILE *fopen(const char *filename, const char *mode);

PUBLIC fopen

EXTERN asm_fopen

fopen:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_fopen
