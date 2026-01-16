
; char* strset_callee(char *s, int c)

SECTION code_clib
SECTION code_string

PUBLIC _strset_callee

EXTERN asm_strset

_strset_callee:

   pop af
   pop hl
   pop de
   push af
   
   jp asm_strset
