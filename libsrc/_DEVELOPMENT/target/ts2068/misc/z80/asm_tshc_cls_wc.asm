; ===============================================================
; 2017
; ===============================================================
; 
; void tshc_cls_wc(struct r_Rect8 *r, uchar attr)
;
; Clear the rectangular area on screen.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshc_cls_wc

EXTERN asm_tshc_cls_wc_pix
EXTERN asm_tshc_cls_wc_attr

asm_tshc_cls_wc:

   ; enter :  l = attr
   ;         ix = rect *
   ;
   ; uses  : af, bc, de, hl

   push hl                     ; save attribute

   ld l,0
   call asm_tshc_cls_wc_pix
   
   pop hl
   jp asm_tshc_cls_wc_attr
