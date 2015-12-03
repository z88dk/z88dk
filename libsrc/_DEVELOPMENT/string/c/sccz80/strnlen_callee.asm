
; size_t strnlen(const char *s, size_t maxlen)

SECTION code_clib
SECTION code_string

PUBLIC strnlen_callee

EXTERN asm_strnlen

strnlen_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   jp asm_strnlen
