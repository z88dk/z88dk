
; size_t strlcat(char * restrict s1, const char * restrict s2, size_t n)

SECTION seg_code_string

PUBLIC strlcat_callee

strlcat_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   INCLUDE "string/z80/asm_strlcat.asm"
