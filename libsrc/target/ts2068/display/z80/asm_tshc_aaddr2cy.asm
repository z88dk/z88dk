; ===============================================================
; May 2017
; ===============================================================
;
; uchar tshc_aaddr2cy(void *aaddr)
;
; Character y coordinate corresponding to attribute address.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshc_aaddr2cy

EXTERN asm_zx_saddr2cy

defc asm_tshc_aaddr2cy = asm_zx_saddr2cy
