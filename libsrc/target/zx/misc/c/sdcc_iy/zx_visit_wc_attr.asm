; void zx_visit_wc_attr(struct r_Rect8 *r, void *function)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_visit_wc_attr

EXTERN asm_zx_visit_wc_attr

_zx_visit_wc_attr:

   pop hl
	pop ix
	pop de
	
	push de
	push ix
	push hl

   jp asm_zx_visit_wc_attr
