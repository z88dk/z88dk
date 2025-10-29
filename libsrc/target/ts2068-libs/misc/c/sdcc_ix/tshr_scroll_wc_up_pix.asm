; void tshr_scroll_wc_up_pix(struct r_Rect8 *r, uchar rows, uchar pix)

SECTION code_clib
SECTION code_arch

PUBLIC _tshr_scroll_wc_up_pix

EXTERN l0_tshr_scroll_wc_up_pix_callee

_tshr_scroll_wc_up_pix:

   pop af
   pop bc
   pop de
   
   push de
   push bc
   push af
   
   ld l,d
   jp l0_tshr_scroll_wc_up_pix_callee
