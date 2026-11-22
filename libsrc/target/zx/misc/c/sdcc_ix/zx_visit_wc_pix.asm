; void zx_visit_wc_pix(struct r_Rect8 *r, void *function)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_visit_wc_pix

EXTERN l0_zx_visit_wc_pix_callee

_zx_visit_wc_pix:

   pop hl
	pop bc
	pop de
	
	push de
	push bc
	push hl

   jp l0_zx_visit_wc_pix_callee
