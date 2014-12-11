
; void zx_scroll_wc_up(struct r_Rect8 *r, uchar rows, uchar attr)

SECTION code_arch

PUBLIC zx_scroll_wc_up_callee

zx_scroll_wc_up_callee:

   pop af
   pop hl
   pop de
   pop ix
   push af
   
   INCLUDE "arch/zx/misc/z80/asm_zx_scroll_wc_up.asm"
