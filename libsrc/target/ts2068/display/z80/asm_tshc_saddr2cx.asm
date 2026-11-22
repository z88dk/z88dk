; ===============================================================
; May 2017
; ===============================================================
;
; uchar tshc_saddr2cx(void *saddr)
;
; Character x coordinate corresponding to screen address.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshc_saddr2cx

EXTERN asm_zx_saddr2cx

defc asm_tshc_saddr2cx = asm_zx_saddr2cx
