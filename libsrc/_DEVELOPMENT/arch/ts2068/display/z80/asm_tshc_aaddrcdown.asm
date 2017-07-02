; ===============================================================
; May 2017
; ===============================================================
;
; void *tshc_aaddrcdown(void *aaddr)
;
; Modify attribute address to move down one character (eight pixels)
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshc_aaddrcdown

EXTERN asm_zx_saddrcdown

defc asm_tshc_aaddrcdown = asm_zx_saddrcdown
