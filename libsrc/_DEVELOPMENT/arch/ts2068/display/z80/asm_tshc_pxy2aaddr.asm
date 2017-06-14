; ===============================================================
; May 2017
; ===============================================================
;
; void *tshc_pxy2aaddr(uchar x, uchar y)
;
; Attribute address of byte containing pixel at coordinate x, y.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshc_pxy2aaddr

EXTERN asm0_zx_pxy2saddr

asm_tshc_pxy2aaddr:

   ld a,h
   and $07
   or $60

   jp asm0_zx_pxy2saddr
