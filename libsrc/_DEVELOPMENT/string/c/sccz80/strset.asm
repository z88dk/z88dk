
; char* strset(char *s, int c)

SECTION code_clib
SECTION code_string

PUBLIC strset

EXTERN asm_strset

strset:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_strset
