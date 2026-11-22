; ===============================================================
; 2017
; ===============================================================
; 
; void tshr_cls(uchar paper)
;
; Clear screen using paper colour.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshr_cls

EXTERN asm_tshr_cls_attr
EXTERN asm_tshr_cls_pix

asm_tshr_cls:

   ; enter : l = attr
   ;
   ; uses  : af, bc, de, hl

   push hl
   
   ld l,0
   call asm_tshr_cls_pix
   
   pop hl
   jp asm_tshr_cls_attr
