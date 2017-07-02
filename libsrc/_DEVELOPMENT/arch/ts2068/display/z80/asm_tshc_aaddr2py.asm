; ===============================================================
; May 2017
; ===============================================================
;
; uchar tshc_aaddr2py(void *aaddr)
;
; Pixel y coordinate corresponding to attribute address.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshc_aaddr2py

EXTERN asm_zx_saddr2py

defc asm_tshc_aaddr2py = asm_zx_saddr2py
