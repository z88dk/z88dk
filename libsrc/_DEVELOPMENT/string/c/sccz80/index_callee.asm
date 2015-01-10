
; BSD
; char *index(const char *s, int c)

SECTION code_string

PUBLIC index_callee

EXTERN strchr_callee

defc index_callee = strchr_callee

INCLUDE "string/z80/asm_index.asm"
