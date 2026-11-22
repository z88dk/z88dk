; void zx_scroll_up_pix(uchar rows, uchar pix)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_scroll_up_pix_callee

EXTERN asm0_zx_scroll_up_pix

_zx_scroll_up_pix_callee:

   pop hl
   ex (sp),hl
   
   ld e,l
   ld d,0
   ld l,h

   jp asm0_zx_scroll_up_pix
