; void sms_tiles_clear_area(struct r_Rect8 *r, unsigned int background)
;
; Clear the rectangular area on screen

SECTION code_clib
SECTION code_arch

PUBLIC asm_sms_tiles_clear_area

EXTERN asm_sms_cls_wc

defc asm_sms_tiles_clear_area = asm_sms_cls_wc

   ; enter : hl = background character
   ;         ix = rect *
   ;
   ; uses  : af, bc, de, hl
