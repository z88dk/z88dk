
; void zx_scroll_up_callee(uchar rows, uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_scroll_up_callee

EXTERN asm0_zx_scroll_up

_zx_scroll_up_callee:

   pop hl
   ex (sp),hl
   
   ld e,l
   ld d,0
   ld l,h

   jp asm0_zx_scroll_up
