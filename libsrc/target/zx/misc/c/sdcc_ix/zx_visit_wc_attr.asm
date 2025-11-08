; void zx_visit_wc_attr(struct r_Rect8 *r, void *function)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_visit_wc_attr

EXTERN l0_zx_visit_wc_attr_callee

_zx_visit_wc_attr:

   pop hl
	pop bc
	pop de
	
	push de
	push bc
	push hl

   jp l0_zx_visit_wc_attr_callee
