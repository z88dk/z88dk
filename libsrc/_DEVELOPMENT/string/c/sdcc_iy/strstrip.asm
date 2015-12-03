
; char *strstrip(const char *s)

SECTION code_clib
SECTION code_string

PUBLIC _strstrip

EXTERN asm_strstrip

_strstrip:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_strstrip
