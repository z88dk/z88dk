
; void zx_scroll_callee(uchar rows, uchar attr)

SECTION seg_code_arch

PUBLIC zx_scroll_callee

zx_scroll_callee:

   pop af
   pop hl
   pop de
   push af
   
   INCLUDE "arch/zx/misc/z80/asm_zx_scroll.asm"
