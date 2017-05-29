; ===============================================================
; May 2017
; ===============================================================
;
; void *tshc_aaddrpdown(void *saddr)
;
; Modify attribute address to move down one pixel.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshc_aaddrpdown
PUBLIC asm0_tshc_aaddrpdown

asm_tshc_aaddrpdown:

   ; enter : hl = attribute address
   ;
   ; exit  : hl = attribute address moved down one pixel
   ;         carry set of new attribute address is off screen
   ;
   ; uses  : af, hl

   inc h

asm0_tshc_aaddrpdown:

   ld a,h
   and $07
   ret nz

   ld a,h
   sub $08
   ld h,a
   
   ld a,l
   add a,$20
   ld l,a
   ret nc
   
   ld a,h
   add a,$08
   ld h,a
   
   cp $78
   ccf
   ret
