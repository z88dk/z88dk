
; void zx_scroll_up_callee(uchar rows, uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_scroll_up_callee

EXTERN asm_zx_scroll_up

_zx_scroll_up_callee:

   pop hl
   pop de
   ex (sp),hl
   
   jp asm_zx_scroll_up
