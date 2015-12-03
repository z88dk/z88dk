
; void zx_scroll_wc_up_callee(struct r_Rect8 *r, uchar rows, uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_scroll_wc_up_callee, l0_zx_scroll_wc_up_callee

EXTERN asm_zx_scroll_wc_up

_zx_scroll_wc_up_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl

l0_zx_scroll_wc_up_callee:

   push bc
   ex (sp),ix
   
   call asm_zx_scroll_wc_up
   
   pop ix
   ret
