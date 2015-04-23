
; void zx_scroll_up_callee(uchar rows, uchar attr)

SECTION code_arch

PUBLIC _zx_scroll_up_callee

_zx_scroll_up_callee:

   pop hl
   pop de
   ex (sp),hl
   
   INCLUDE "arch/zx/misc/z80/asm_zx_scroll_up.asm"
