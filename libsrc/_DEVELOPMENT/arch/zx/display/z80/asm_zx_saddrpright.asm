
; ===============================================================
; Jun 2007
; ===============================================================
;
; void *zx_saddrpright(void *saddr, uint bitmask)
;
; Modify screen address and bitmask to move right one pixel.
; Indicate error if pixel is at the rightmost edge.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_saddrpright

asm_zx_saddrpright:

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
   
   inc l
   ld a,l
   and $1f
   ret nz
   
   dec l
   ld e,$01
   
   scf
   ret
