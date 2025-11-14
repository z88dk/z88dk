; ===============================================================
; May 2017
; ===============================================================
;
; void *tshr_saddrpright(void *saddr, uchar bitmask)
;
; Modify screen address and bitmask to move right one pixel.
; Indicate error if pixel is at the rightmost edge.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshr_saddrpright

asm_tshr_saddrpright:

   ; enter : hl = screen address
   ;          e = bitmask
   ;
   ; exit  : hl = screen address moved right one pixel
   ;          e = bitmask moved right one pixel
   ;         carry set if pixel was at rightmost edge
   ;
   ; uses  : af, e, hl

   rrc e
   ret nc
   
   bit 5,h
   set 5,h
   ret z
   res 5,h

   inc l
   ld a,l
   and $1f
   ret nz
   
   dec l
   ld e,$01
   set 5,h
   
   scf
   ret
