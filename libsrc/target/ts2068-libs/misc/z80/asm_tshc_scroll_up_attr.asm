; ===============================================================
; 2017
; ===============================================================
; 
; void tshc_scroll_up_attr(uchar prows, uchar attr)
;
; Scroll attr upward by number of pixels.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshc_scroll_up_attr
PUBLIC asm0_tshc_scroll_up_attr

EXTERN asm1_zx_scroll_up_pix
EXTERN asm_tshc_cls_attr, asm_tshc_py2aaddr

asm_tshc_scroll_up_attr:

   ; enter : de = number of attr prows to scroll upward by
   ;          l = attr byte
   ;
   ; uses  : af, bc, de, hl

   inc d
   dec d
   jp nz, asm_tshc_cls_attr

asm0_tshc_scroll_up_attr:

   inc e
   dec e
   ret z
   
   ld a,191
   sub e
   jp c, asm_tshc_cls_attr

   inc a
   
   ; e = number of prows to scroll upward
   ; l = attr byte
   ; a = loop count
   
   ld b,a                      ; b = loop count
   
   push hl                     ; save attr byte
   push de                     ; save scroll amount
   
   ;; copy upward
   
   ex de,hl
   call asm_tshc_py2aaddr      ; hl = attr address corresponding to first scroll row L

IF __USE_SPECTRUM_128_SECOND_DFILE
   ld de,$e000
ELSE
   ld de,$6000                 ; de = destination address of first scroll row
ENDIF

   jp asm1_zx_scroll_up_pix
