
; char *strupr(char *s)

SECTION seg_code_string

PUBLIC strupr

strupr:

   INCLUDE "string/z80/asm_strupr.asm"
