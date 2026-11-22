; ===============================================================
; 2017
; ===============================================================
; 
; void tshc_cls(uchar attr)
;
; Clear screen using attibute.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshc_cls

EXTERN asm_tshc_cls_pix, asm_tshc_cls_attr

asm_tshc_cls:

   ; enter : l = attr
   ;
   ; uses  : af, bc, de, hl

   push hl
   
   ld l,0
   call asm_tshc_cls_pix

   pop hl
   jp asm_tshc_cls_attr
