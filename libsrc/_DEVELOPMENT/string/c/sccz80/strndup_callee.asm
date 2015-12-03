
; char *strndup(const char *s, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC strndup_callee

EXTERN asm_strndup

strndup_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   jp asm_strndup
