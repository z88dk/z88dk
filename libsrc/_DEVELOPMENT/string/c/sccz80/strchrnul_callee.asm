
; char *strchrnul(const char *s, int c)

SECTION code_clib
SECTION code_string

PUBLIC strchrnul_callee

EXTERN asm_strchrnul

strchrnul_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   jp asm_strchrnul
