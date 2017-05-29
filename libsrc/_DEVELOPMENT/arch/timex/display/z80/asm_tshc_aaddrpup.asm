; ===============================================================
; May 2017
; ===============================================================
;
; void *tshc_aaddrpup(void *aaddr)
;
; Modify attribute address to move up one pixel.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshc_aaddrpup

   ; enter : hl = attibute address
   ;
   ; exit  : hl = attribute address moved up one pixel
   ;         carry set if new attribute address is off screen
   ;
   ; uses  : af, hl

   ld a,h
   dec h
   and $07
   ret nz
   
   ld a,$08
   add a,h
   ld h,a
   
   ld a,l
   sub $20
   ld l,a
   ret nc
   
   ld a,h
   sub $08
   ld h,a
   
   cp $60
   ret
