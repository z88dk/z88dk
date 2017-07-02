; ===============================================================
; May 2017
; ===============================================================
;
; uchar tshc_saddr2py(void *saddr)
;
; Pixel y coordinate corresponding to screen address.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshc_saddr2py

EXTERN asm_zx_saddr2py

defc asm_tshc_saddr2py = asm_zx_saddr2py
