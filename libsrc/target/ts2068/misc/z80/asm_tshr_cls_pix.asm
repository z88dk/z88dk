; ===============================================================
; 2017
; ===============================================================
; 
; void tshr_cls_pix(unsigned char pix)
;
; Clear screen.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshr_cls_pix

EXTERN asm_tshc_cls_pix, asm_tshc_cls_attr

asm_tshr_cls_pix:

   ; enter : l = pix
   ;
   ; uses  : af, bc, de, hl

   ; should this be done per line for a cleaner cls?

   push hl

   call asm_tshc_cls_pix

   pop hl
   jp asm_tshc_cls_attr
