
; char *strndup(const char *s, size_t n)

SECTION code_string

PUBLIC strndup_callee

strndup_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   INCLUDE "string/z80/asm_strndup.asm"
