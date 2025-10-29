
; char *strrev(char *s)

SECTION code_clib
SECTION code_string

PUBLIC _strrev

EXTERN asm_strrev

_strrev:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_strrev
