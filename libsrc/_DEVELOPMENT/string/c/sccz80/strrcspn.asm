
; size_t strrcspn(const char *str, const char *cset)

SECTION code_clib
SECTION code_string

PUBLIC strrcspn

EXTERN asm_strrcspn

strrcspn:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_strrcspn
