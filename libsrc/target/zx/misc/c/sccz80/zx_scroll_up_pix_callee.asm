; void zx_scroll_up_pix(uchar rows, uchar pix)

SECTION code_clib
SECTION code_arch

PUBLIC zx_scroll_up_pix_callee

EXTERN asm0_zx_scroll_up_pix

zx_scroll_up_pix_callee:

   pop af
   pop hl
   pop de
   push af

   jp asm0_zx_scroll_up_pix
