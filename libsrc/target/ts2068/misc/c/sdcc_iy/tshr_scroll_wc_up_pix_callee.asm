; void tshr_scroll_wc_up_pix(struct r_Rect8 *r, uchar rows, uchar pix)

SECTION code_clib
SECTION code_arch

PUBLIC _tshr_scroll_wc_up_pix_callee

EXTERN asm0_tshr_scroll_wc_up_pix

_tshr_scroll_wc_up_pix_callee:

   pop hl
   pop ix
   ex (sp),hl
   
   ld e,l
   ld l,h
   
   jp asm0_tshr_scroll_wc_up_pix
