
; void zx_scroll_up(uchar rows, uchar attr)

SECTION code_arch

PUBLIC _zx_scroll_up

_zx_scroll_up:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   INCLUDE "arch/zx/misc/z80/asm_zx_scroll_up.asm"
