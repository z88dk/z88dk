; void zx_scroll_wc_up_attr(struct r_Rect8 *r, uchar rows, uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_scroll_wc_up_attr

EXTERN asm0_zx_scroll_wc_up_attr

_zx_scroll_wc_up_attr:

   pop af
   pop ix
   pop de
   
   push de
   push hl
   push af
   
   ld l,d
   ld d,0
   jp asm0_zx_scroll_wc_up_attr
