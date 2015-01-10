
; BSD
; char *index(const char *s, int c)

SECTION code_string

PUBLIC _index

EXTERN _strchr

defc _index = _strchr

INCLUDE "string/z80/asm_index.asm"
