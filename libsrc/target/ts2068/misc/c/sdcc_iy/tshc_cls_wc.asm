; void tshc_cls_wc(struct r_Rect8 *r, uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC _tshc_cls_wc

EXTERN asm_tshc_cls_wc

_tshc_cls_wc:

   pop af
   pop ix
   pop hl
   
   push hl
   push hl
   push af
   
   jp asm_tshc_cls_wc
