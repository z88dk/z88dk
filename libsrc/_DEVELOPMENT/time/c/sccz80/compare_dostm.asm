; int compare_dostm(struct dos_tm *a, struct dos_tm *b)

SECTION code_time

PUBLIC compare_dostm

EXTERN asm_compare_dostm

compare_dostm:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_compare_dostm
