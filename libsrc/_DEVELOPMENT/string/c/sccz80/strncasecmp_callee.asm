
; int strncasecmp(const char *s1, const char *s2, size_t n)

SECTION seg_code_string

PUBLIC strncasecmp_callee

strncasecmp_callee:

   pop af
   pop bc
   pop hl
   pop de
   push af
   
   INCLUDE "string/z80/asm_strncasecmp.asm"
