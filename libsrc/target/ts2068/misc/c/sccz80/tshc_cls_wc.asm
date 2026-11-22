; void tshc_cls_wc(struct r_Rect8 *r, uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_cls_wc

EXTERN asm_tshc_cls_wc

tshc_cls_wc:

   pop af
   pop hl
   pop ix
   
   push hl
   push hl
   push af
   
   jp asm_tshc_cls_wc

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshc_cls_wc
defc _tshc_cls_wc = tshc_cls_wc
ENDIF

