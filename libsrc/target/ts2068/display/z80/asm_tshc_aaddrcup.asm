; ===============================================================
; May 2017
; ===============================================================
;
; void *tshc_aaddrcup(void *saddr)
;
; Modify attribute address to move up one character (eight pixels)
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshc_aaddrcup

EXTERN asm_zx_saddrcup

defc asm_tshc_aaddrcup = asm_zx_saddrcup
