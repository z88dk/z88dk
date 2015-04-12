
; char *strupr_fastcall(char *s)

SECTION code_string

PUBLIC _strupr_fastcall

_strupr_fastcall:

   INCLUDE "string/z80/asm_strupr.asm"
