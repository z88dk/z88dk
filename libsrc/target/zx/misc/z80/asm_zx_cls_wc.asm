
; ===============================================================
; 2014
; ===============================================================
; 
; void zx_cls_wc(struct r_Rect8 *r, uchar attr)
;
; Clear the rectangular area on screen.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_cls_wc

EXTERN asm_zx_cls_wc_pix
EXTERN asm_zx_cls_wc_attr

asm_zx_cls_wc:

   ; enter :  l = attr
   ;         ix = rect *
   ;
   ; uses  : af, bc, de, hl

   push hl                     ; save attribute

   ld l,0
   call asm_zx_cls_wc_pix
   
   pop hl
   jp asm_zx_cls_wc_attr
