
; Rectangle, Intervals and Points
; 05.2006 aralbrec

SECTION code_clib
PUBLIC RIsPtInRect8

; Determine if 8-bit (x,y) point lies in an 8-bit bounding
; rectangle.  Rectangle bounds wrap across 0-255 boundaries.
;
; enter :  a = x coordinate of point
;          l = y coordinate of point
;          b = x coordinate of rect
;          c = width of rect
;          d = y coordinate of rect
;          e = height of rect
; exit  : carry flag set = in rectangle
; uses  : af

.RIsPtInRect8

   sub b
   cp c
   ret nc
   
   ld a,l
   sub d
   cp e
   ret
