; void tshc_cls_wc_attr(struct r_Rect8 *r, uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_cls_wc_attr_callee

EXTERN asm_tshc_cls_wc_attr

tshc_cls_wc_attr_callee:

   pop af
   pop hl
   pop ix
   push af

   jp asm_tshc_cls_wc_attr

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshc_cls_wc_attr_callee
defc _tshc_cls_wc_attr_callee = tshc_cls_wc_attr_callee
ENDIF

