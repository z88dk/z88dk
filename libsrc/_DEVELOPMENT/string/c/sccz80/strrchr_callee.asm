
; char *strrchr(const char *s, int c)

SECTION code_clib
SECTION code_string

PUBLIC strrchr_callee

EXTERN asm_strrchr

strrchr_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   jp asm_strrchr
