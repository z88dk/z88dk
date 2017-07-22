; void zx_visit_wc_pix(struct r_Rect8 *r, void *function)

SECTION code_clib
SECTION code_arch

PUBLIC _zx_visit_wc_pix

EXTERN asm_zx_visit_wc_pix

_zx_visit_wc_pix:

   pop hl
	pop ix
	pop de
	
	push de
	push ix
	push hl

   jp asm_zx_visit_wc_pix
