
; Rectangle, Intervals and Points
; 05.2006 aralbrec

SECTION code_clib
PUBLIC RIsRectInRect8

; Determine if two 8-bit rectangles intersect.  Rectangles
; can wrap across 0-255 boundaries.
;
; enter  :  b = rect #1 x-interval start coordinate
;           c = rect #1 x-interval width
;           d = rect #2 x-interval start coordinate
;           e = rect #2 x-interval width
;          b' = rect #1 y-interval start coordinate
;          c' = rect #1 y-interval width
;          d' = rect #2 y-interval start coordinate
;          e' = rect #2 y-interval width
; exit   : carry flag set = intersection detected
; uses   : af

.RIsRectInRect8

   ld a,b
   sub d
   cp e
   jr c, intersect1
   
   ld a,d
   sub b
   cp c
   ret nc
   
.intersect1

   exx
   
   ld a,b
   sub d
   cp e
   jr c, intersect2
   
   ld a,d
   sub b
   cp c
   
.intersect2

   exx
   
   ret
