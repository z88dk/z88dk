; void tshc_cls_wc_pix(struct r_Rect8 *r, uchar pix)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_cls_wc_pix

EXTERN asm_tshc_cls_wc_pix

tshc_cls_wc_pix:

   pop af
   pop hl
   pop ix
   
   push hl
   push hl
   push af
   
   jp asm_tshc_cls_wc_pix

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshc_cls_wc_pix
defc _tshc_cls_wc_pix = tshc_cls_wc_pix
ENDIF

