; ===============================================================
; May 2017
; ===============================================================
;
; void *tshc_saddrcup(void *saddr)
;
; Modify screen address to move up one character (eight pixels)
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshc_saddrcup

EXTERN asm_zx_saddrcup

defc asm_tshc_saddrcup = asm_zx_saddrcup
