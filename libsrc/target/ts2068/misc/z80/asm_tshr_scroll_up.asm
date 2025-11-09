; ===============================================================
; 2017
; ===============================================================
; 
; void tshr_scroll_up(uchar prows, uchar attr)
;
; Scroll screen upward by rows pixels and clear vacated area
; using attribute.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshr_scroll_up

EXTERN asm_tshr_scroll_up_pix
EXTERN asm_tshr_cls_attr

asm_tshr_scroll_up:

   ; enter : de = number of pixel rows to scroll upward by
   ;          l = attr
   ;
   ; uses  : af, bc, de, hl

   push hl
   
   ld l,0
   call asm_tshr_scroll_up_pix
   
   pop hl
   jp asm_tshr_cls_attr
