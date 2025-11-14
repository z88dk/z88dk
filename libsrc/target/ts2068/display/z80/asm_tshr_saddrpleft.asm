
; ===============================================================
; May 2017
; ===============================================================
;
; void *tshr_saddrpleft(void *saddr, uchar bitmask)
;
; Modify screen address and mask to move left one pixel.
; Indicates error if pixel at leftmost edge.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshr_saddrpleft

asm_tshr_saddrpleft:

   ; enter : hl = screen address
   ;          e = bitmask
   ;
   ; exit  : hl = screen address moved left one pixel
   ;          e = bitmask moved left one pixel
   ;         carry set if pixel at leftmost edge
   ;
   ; uses  : af, e, hl

   rlc e
   ret nc

   bit 5,h
   res 5,h
   ret nz
   set 5,h
   
   ld a,l
   dec l
   and $1f
   ret nz
   
   inc l
   ld e,$80
   res 5,h
   
   scf
   ret
