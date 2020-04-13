; void tshc_cls_wc(struct r_Rect8 *r, uchar attr)

SECTION code_clib
SECTION code_arch

PUBLIC tshc_cls_wc_callee

EXTERN asm_tshc_cls_wc

tshc_cls_wc_callee:

   pop af
	pop hl
	pop ix
	push af

   jp asm_tshc_cls_wc

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshc_cls_wc_callee
defc _tshc_cls_wc_callee = tshc_cls_wc_callee
ENDIF

