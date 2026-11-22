
; size_t strrcspn_callee(const char *str, const char *cset)

SECTION code_clib
SECTION code_string

PUBLIC _strrcspn_callee

EXTERN asm_strrcspn

_strrcspn_callee:

   pop af
   pop hl
   pop de
   push af
   
   jp asm_strrcspn
