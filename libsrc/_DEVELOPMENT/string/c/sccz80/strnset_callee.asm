
; char *strnset(char *s, int c, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC strnset_callee

EXTERN asm_strnset

strnset_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   jp asm_strnset
