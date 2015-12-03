
; size_t strspn(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

PUBLIC strspn_callee

EXTERN asm_strspn

strspn_callee:

   pop hl
   pop de
   ex (sp),hl
   
   jp asm_strspn
