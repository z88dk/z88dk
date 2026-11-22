
; Rectangle, Intervals and Points
; 05.2006 aralbrec

SECTION code_clib
PUBLIC RIntersectIval8

; Returns the intersection of two 8-bit intervals.
; Since intervals can wrap across the 0-255 boundary,
; the result of the intersection can be the empty
; interval (no intersection), a single interval or
; two intervals.  This routine will return one
; intersected interval.
;
; enter  :  b = interval 1 start coordinate
;           c = interval 1 width
;           d = interval 2 start coordinate
;           e = interval 2 width
; exit   : carry flag set = intersection detected and
;          b = start coord, c = width of intersection
; uses   : af, bc

.RIntersectIval8

   ld a,b
   sub d
   sub e
   jr c, i1ini2
   
   ld a,d
   sub b
   sub c
   ret nc
   
.i2ini1

   ld b,d
   neg
   cp e
   ld c,a
   jr c, min
   ld c,e

.min

   scf
   ret

.i1ini2

   neg
   cp c
   jr nc, max
   ld c,a

.max

   scf
   ret
