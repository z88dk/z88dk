; void zx_cls_wc_pix(struct r_Rect8 *r, uchar pix)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_cls_wc_pix

EXTERN l0_zx_cls_wc_pix

_zx_cls_wc_pix:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp l0_zx_cls_wc_pix
