
; ===============================================================
; Jun 2007
; ===============================================================
;
; void *zx_saddrpdown(void *saddr)
;
; Modify screen address to move down one pixel.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC old_zx_saddrpdown
PUBLIC old0_zx_saddrpdown

old_zx_saddrpdown:

   ; enter : hl = screen address
   ;
   ; exit  : hl = screen address moved down one pixel
   ;         carry set of new screen address is off screen
   ;
   ; uses  : af, hl

   inc h

old0_zx_saddrpdown:

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

   and $18
   cp $18

   ccf
   ret
