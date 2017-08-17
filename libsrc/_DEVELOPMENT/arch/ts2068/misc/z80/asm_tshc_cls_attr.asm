
; ===============================================================
; 2017
; ===============================================================
; 
; void tshc_cls_attr(unsigned char attr)
;
; Clear attributes.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshc_cls_attr

EXTERN asm0_zx_cls_pix

asm_tshc_cls_attr:

   ; enter : l = attr
   ;
   ; uses  : af, bc, de, hl

	ld a,l
	
	ld hl,$6000
	ld de,$6001
	
	jp asm0_zx_cls_pix
