
; char *strdup(const char * s)

SECTION code_clib
SECTION code_string

PUBLIC _strdup

EXTERN asm_strdup

_strdup:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_strdup
