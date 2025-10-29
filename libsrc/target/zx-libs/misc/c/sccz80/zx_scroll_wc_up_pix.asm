; void zx_scroll_wc_up_pix(struct r_Rect8 *r, uchar rows, uchar pix)

SECTION code_clib
SECTION code_arch

PUBLIC zx_scroll_wc_up_pix

EXTERN asm0_zx_scroll_wc_up_pix

zx_scroll_wc_up_pix:

   pop af
   pop hl
   pop de
   pop ix
   
   push de
   push de
   push hl
   push af

   jp asm0_zx_scroll_wc_up_pix
