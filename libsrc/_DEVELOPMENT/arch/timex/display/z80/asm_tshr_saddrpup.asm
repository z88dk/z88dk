; ===============================================================
; May 2107
; ===============================================================
;
; void *tshr_saddrpup(void *saddr)
;
; Modify screen address to move up one pixel.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshr_saddrpup

asm_tshr_saddrpup:

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
   
   and $18
   cp $18
   
   ccf
   ret
