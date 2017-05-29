; ===============================================================
; May 2017
; ===============================================================
;
; uint tshr_saddr2py(void *saddr)
;
; Pixel y coordinate corresponding to screen address.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshr_saddr2py

EXTERN asm_zx_saddr2py

defc asm_tshr_saddr2py = asm_zx_saddr2py
