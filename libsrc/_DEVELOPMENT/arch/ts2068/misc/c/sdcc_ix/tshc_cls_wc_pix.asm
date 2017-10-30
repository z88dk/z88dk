; void tshc_cls_wc_pix(struct r_Rect8 *r, uchar pix)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_cls_wc_pix

EXTERN l0_tshc_cls_wc_pix_callee

_tshc_cls_wc_pix:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp l0_tshc_cls_wc_pix_callee
