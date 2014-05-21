
; void cons_scroll_00(uint16_t rows)

PUBLIC _cons_scroll_00

_cons_scroll_00:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "target/zx/driver/z80/asm_cons_scroll_00.asm"
