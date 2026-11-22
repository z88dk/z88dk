; void zx_scroll_wc_up_pix_callee(struct r_Rect8 *r, uchar rows, uchar pix)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_scroll_wc_up_pix_callee, l0_zx_scroll_wc_up_pix_callee

EXTERN asm0_zx_scroll_wc_up_pix

_zx_scroll_wc_up_pix_callee:

   pop hl
   pop bc
   ex (sp),hl

l0_zx_scroll_wc_up_pix_callee:

   ld e,l
   ld d,0
   ld l,h

   push bc
   ex (sp),ix
   
   call asm0_zx_scroll_wc_up_pix
   
   pop ix
   ret
