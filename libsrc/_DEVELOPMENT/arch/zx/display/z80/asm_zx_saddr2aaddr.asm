
; ===============================================================
; Jun 2007
; ===============================================================
;
; void *zx_saddr2aaddr(void *saddr)
;
; Attribute address corresponding to screen address.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_saddr2aaddr

asm_zx_saddr2aaddr:

   ld a,h
   rra
   rra
   rra
   and $03
   or $58
   ld h,a
   
   ret
