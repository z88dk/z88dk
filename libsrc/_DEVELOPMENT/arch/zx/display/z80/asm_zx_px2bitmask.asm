
; ===============================================================
; Jun 2007
; ===============================================================
;
; uint zx_px2bitmask(uchar x)
;
; Return bitmask corresponding to pixel x coordinate.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_px2bitmask

asm_zx_px2bitmask:

   ; enter :  l = pixel x coordinate
   ;
   ; exit  : hl = 8-bit bitmask
   ;
   ; uses  : af, b, hl
   
   ld h,0
   
   ld a,l
   and $07
   ld b,a
   
   ld a,$80
   ld l,a
   ret z
   
loop:

   rra
   djnz loop
   
   ld l,a
   ret
