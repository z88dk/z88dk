; void tshc_scroll_wc_up(struct r_Rect8 *r, uchar rows, uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_scroll_wc_up_callee

EXTERN asm0_tshc_scroll_wc_up

_tshc_scroll_wc_up_callee:

   pop hl
   pop ix
   ex (sp),hl
   
   ld e,l
   ld l,h
   jp asm0_tshc_scroll_wc_up
