
; ===============================================================
; Jun 2007
; ===============================================================
;
; void *zx_saddrpleft(void *saddr, uchar bitmask)
;
; Modify screen address and mask to move left one pixel.
; Indicates error if pixel at leftmost edge.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_saddrpleft

asm_zx_saddrpleft:

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

   ld a,l
   dec l
   and $1f
   ret nz

   inc l
   ld e,$80
   
   scf 
   ret
