; void tshr_cls_wc_pix(struct r_Rect8 *r, uchar pix)

SECTION code_clib
SECTION code_arch

PUBLIC tshr_cls_wc_pix

EXTERN asm_tshr_cls_wc_pix

tshr_cls_wc_pix:

   pop af
   pop hl
   pop ix
   
   push hl
   push hl
   push af

   jp asm_tshr_cls_wc_pix

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshr_cls_wc_pix
defc _tshr_cls_wc_pix = tshr_cls_wc_pix
ENDIF

