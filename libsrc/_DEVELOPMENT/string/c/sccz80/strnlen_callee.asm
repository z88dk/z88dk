
; size_t strnlen(const char *s, size_t maxlen)

SECTION code_string

PUBLIC strnlen_callee

strnlen_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   INCLUDE "string/z80/asm_strnlen.asm"
