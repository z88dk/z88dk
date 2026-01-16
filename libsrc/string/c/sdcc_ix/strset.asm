
; char* strset(char *s, int c)

SECTION code_clib
SECTION code_string

PUBLIC _strset

EXTERN asm_strset

_strset:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_strset
