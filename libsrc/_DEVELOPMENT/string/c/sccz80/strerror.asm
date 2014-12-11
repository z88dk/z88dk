
; char *strerror(int errnum)

SECTION code_string

PUBLIC strerror

strerror:

   INCLUDE "string/z80/asm_strerror.asm"
