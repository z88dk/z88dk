
; char *strnset(char *s, int c, size_t n)

SECTION code_string

PUBLIC strnset_callee

strnset_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   INCLUDE "string/z80/asm_strnset.asm"
