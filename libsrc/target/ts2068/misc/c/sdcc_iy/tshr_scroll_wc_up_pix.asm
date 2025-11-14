; void tshr_scroll_wc_up_pix(struct r_Rect8 *r, uchar rows, uchar pix)

SECTION code_clib
SECTION code_arch

PUBLIC _tshr_scroll_wc_up_pix

EXTERN asm0_tshr_scroll_wc_up_pix

_tshr_scroll_wc_up_pix:

   pop af
   pop ix
   pop de
   
   push de
   push de
   push af
   
   ld l,d
   jp asm0_tshr_scroll_wc_up_pix
