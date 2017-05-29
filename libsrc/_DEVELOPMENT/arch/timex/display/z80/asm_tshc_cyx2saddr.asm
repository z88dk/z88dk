; ===============================================================
; May 2017
; ===============================================================
;
; void *tshc_cyx2saddr(uchar row, uchar col)
;
; Screen address of top pixel row of character square at row, col.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshc_cyx2saddr

EXTERN asm_zx_cyx2saddr

defc asm_tshc_cyx2saddr = asm_zx_cyx2saddr
