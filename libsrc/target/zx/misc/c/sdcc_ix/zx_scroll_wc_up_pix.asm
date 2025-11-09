; void zx_scroll_wc_up_pix(struct r_Rect8 *r, uchar rows, uchar pix)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_scroll_wc_up_pix

EXTERN l0_zx_scroll_wc_up_pix_callee

_zx_scroll_wc_up_pix:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af

   jp l0_zx_scroll_wc_up_pix_callee
