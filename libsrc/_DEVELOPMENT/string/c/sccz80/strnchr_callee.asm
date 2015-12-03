
; char *strnchr(const char *s, size_t n, int c)

SECTION code_clib
SECTION code_string

PUBLIC strnchr_callee

EXTERN asm_strnchr

strnchr_callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl
   
   jp asm_strnchr
