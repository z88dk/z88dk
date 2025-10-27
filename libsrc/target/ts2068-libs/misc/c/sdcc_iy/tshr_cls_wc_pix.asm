; void tshr_cls_wc_pix(struct r_Rect8 *r, uchar pix)

SECTION code_clib
SECTION code_arch

PUBLIC _tshr_cls_wc_pix

EXTERN asm_tshr_cls_wc_pix

_tshr_cls_wc_pix:

   pop af
   pop ix
   pop hl
   
   push hl
   push hl
   push af

   jp asm_tshr_cls_wc_pix
