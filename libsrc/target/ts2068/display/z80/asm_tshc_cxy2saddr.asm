; ===============================================================
; May 2017
; ===============================================================
;
; void *tshc_cxy2saddr(uchar x, uchar y)
;
; Screen address of top pixel row of character square at x,y.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshc_cxy2saddr

EXTERN asm_zx_cxy2saddr

defc asm_tshc_cxy2saddr = asm_zx_cxy2saddr
