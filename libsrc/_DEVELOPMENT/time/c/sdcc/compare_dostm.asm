; int compare_dostm(struct dos_tm *a, struct dos_tm *b)

SECTION code_time

PUBLIC _compare_dostm

EXTERN asm_compare_dostm

_compare_dostm:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   jp asm_compare_dostm
