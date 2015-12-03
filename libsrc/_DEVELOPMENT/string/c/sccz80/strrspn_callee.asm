
; size_t strrspn(const char *str, const char *cset)

SECTION code_clib
SECTION code_string

PUBLIC strrspn_callee

EXTERN asm_strrspn

strrspn_callee:

   pop hl
   pop de
   ex (sp),hl
   
   jp asm_strrspn
