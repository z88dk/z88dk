
; ===============================================================
; Jun 2007
; ===============================================================
;
; void *zx_saddrpup(void *saddr)
;
; Modify screen address to move up one pixel.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_saddrpup

asm_zx_saddrpup:

   ; enter : hl = screen address
   ;
   ; exit  : hl = screen address moved up one pixel
   ;         carry set if new screen address is off screen
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
   
   cp $40
   ret
