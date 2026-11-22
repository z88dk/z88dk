; void tshc_cls_wc_attr(struct r_Rect8 *r, uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_cls_wc_attr

EXTERN asm_tshc_cls_wc_attr

tshc_cls_wc_attr:

   pop af
   pop hl
   pop ix
   
   push hl
   push hl
   push af
   
   jp asm_tshc_cls_wc_attr

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshc_cls_wc_attr
defc _tshc_cls_wc_attr = tshc_cls_wc_attr
ENDIF

