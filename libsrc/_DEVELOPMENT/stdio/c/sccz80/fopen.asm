
; FILE *fopen(const char *filename, const char *mode)

SECTION seg_code_stdio

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
