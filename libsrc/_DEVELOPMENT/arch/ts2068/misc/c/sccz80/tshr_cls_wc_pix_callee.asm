; void tshr_cls_wc_pix(struct r_Rect8 *r, uchar pix)

SECTION code_clib
SECTION code_arch

PUBLIC tshr_cls_wc_pix_callee

EXTERN asm_tshr_cls_wc_pix

tshr_cls_wc_pix_callee:

   pop af
   pop hl
   pop ix
   push af

   jp asm_tshr_cls_wc_pix
