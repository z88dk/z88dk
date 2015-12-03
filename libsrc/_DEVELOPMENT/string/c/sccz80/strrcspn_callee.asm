
; size_t strrcspn(const char *str, const char *cset)

SECTION code_clib
SECTION code_string

PUBLIC strrcspn_callee

EXTERN asm_strrcspn

strrcspn_callee:

   pop hl
   pop de
   ex (sp),hl
   
   jp asm_strrcspn
