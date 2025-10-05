; void tshc_cls_wc_pix(struct r_Rect8 *r, uchar pix)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_cls_wc_pix_callee

EXTERN asm_tshc_cls_wc_pix

_tshc_cls_wc_pix_callee:

   pop hl
   pop ix
   dec sp
   ex (sp),hl
   
   ld l,h
   jp asm_tshc_cls_wc_pix
