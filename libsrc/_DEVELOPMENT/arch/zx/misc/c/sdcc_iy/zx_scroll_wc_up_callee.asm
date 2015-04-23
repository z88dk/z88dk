
; void zx_scroll_wc_up_callee(struct r_Rect8 *r, uchar rows, uchar attr)

SECTION code_arch

PUBLIC _zx_scroll_wc_up_callee

_zx_scroll_wc_up_callee:

   pop hl
   pop ix
   pop de
   ex (sp),hl
   
   INCLUDE "arch/zx/misc/z80/asm_zx_scroll_wc_up.asm"
