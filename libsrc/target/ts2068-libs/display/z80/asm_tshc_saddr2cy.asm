; ===============================================================
; May 2017
; ===============================================================
;
; uchar tshc_saddr2cy(void *saddr)
;
; Character y coordinate corresponding to screen address.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshc_saddr2cy

EXTERN asm_zx_saddr2cy

defc asm_tshc_saddr2cy = asm_zx_saddr2cy
