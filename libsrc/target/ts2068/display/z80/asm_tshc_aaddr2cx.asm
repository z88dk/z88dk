; ===============================================================
; May 2017
; ===============================================================
;
; uchar tshc_aaddr2cx(void *aaddr)
;
; Character x coordinate corresponding to attribute address.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshc_aaddr2cx

EXTERN asm_zx_saddr2cx

defc asm_tshc_aaddr2cx = asm_zx_saddr2cx
