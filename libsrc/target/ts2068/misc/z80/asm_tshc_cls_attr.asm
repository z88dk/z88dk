
; ===============================================================
; 2017
; ===============================================================
; 
; void tshc_cls_attr(unsigned char attr)
;
; Clear attributes.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshc_cls_attr

EXTERN asm0_zx_cls_pix

asm_tshc_cls_attr:

   ; enter : l = attr
   ;
   ; uses  : af, bc, de, hl

   ld a,l

IF __USE_SPECTRUM_128_SECOND_DFILE
   ld hl,$e000
   ld de,$e001
ELSE
   ld hl,$6000
   ld de,$6001
ENDIF

   jp asm0_zx_cls_pix
