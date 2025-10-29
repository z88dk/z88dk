; ===============================================================
; 2017
; ===============================================================
; 
; void tshc_cls_wc_attr(struct r_Rect8 *r, uchar attr)
;
; Clear the rectangular area on screen.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshc_cls_wc_attr

EXTERN asm_tshc_cxy2aaddr
EXTERN asm0_zx_cls_wc_pix

asm_tshc_cls_wc_attr:

   ; enter :  l = attr byte
   ;         ix = rect *
   ;
   ; uses  : af, bc, de, hl

   ld c,l                      ; save attr byte

   ld l,(ix+0)                 ; l = rect.x
   ld h,(ix+2)                 ; h = rect.y
   
   call asm_tshc_cxy2aaddr     ; hl = attr address
   jp asm0_zx_cls_wc_pix
