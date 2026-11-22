; ===============================================================
; May 2017
; ===============================================================
;
; void *tshc_pxy2saddr(uchar x, uchar y)
;
; Screen address of byte containing pixel at coordinate x, y.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshc_pxy2saddr

EXTERN asm_zx_pxy2saddr

defc asm_tshc_pxy2saddr = asm_zx_pxy2saddr
