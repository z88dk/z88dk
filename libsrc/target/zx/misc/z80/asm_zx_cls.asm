
; ===============================================================
; 2014
; ===============================================================
; 
; void zx_cls(uchar attr)
;
; Clear screen using attibute.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_cls

EXTERN asm_zx_cls_attr
EXTERN asm_zx_cls_pix

asm_zx_cls:

   ; enter : l = attr
   ;
   ; uses  : af, bc, de, hl

   push hl
   
   ld l,0
   call asm_zx_cls_pix

   pop hl
   jp asm_zx_cls_attr
