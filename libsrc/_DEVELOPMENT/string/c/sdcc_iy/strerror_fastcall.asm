
; char *strerror_fastcall(int errnum)

SECTION code_string

PUBLIC _strerror_fastcall

_strerror_fastcall:
   
   INCLUDE "string/z80/asm_strerror.asm"
