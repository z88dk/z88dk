
; size_t strrcspn(const char *str, const char *cset)

SECTION code_clib
SECTION code_string

PUBLIC _strrcspn

EXTERN asm_strrcspn

_strrcspn:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_strrcspn
