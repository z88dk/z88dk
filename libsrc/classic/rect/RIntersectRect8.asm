
; Rectangle, Intervals and Points
; 05.2006 aralbrec

SECTION code_clib
PUBLIC RIntersectRect8

; Returns the intersection of two 8-bit rectangles.
; Since rectangles can wrap across their 0-255
; boundaries, the result of the intersection can be
; 0, 1, 2 or 3 rectangles.  This routine will return
; one result only.
;
; enter  :  b = rect #1 x-interval start coordinate
;           c = rect #1 x-interval width
;           d = rect #2 x-interval start coordinate
;           e = rect #2 x-interval width
;          b' = rect #1 y-interval start coordinate
;          c' = rect #1 y-interval width
;          d' = rect #2 y-interval start coordinate
;          e' = rect #2 y-interval width
; exit   : carry flag set = intersection detected and
;          b = rect x coord, c = rect width
;          b' = rect y coord, c' = rect height
; uses   : af, bc, bc'

.RIntersectRect8

   ld a,b
   sub d
   sub e
   jr c, xr1inr2
   
   ld a,d
   sub b
   sub c
   ret nc
   
.xr2inr1

   ld b,d
   neg
   cp e
   ld c,a
   jr c, doy
   ld c,e

.doy

   exx
   
   ld a,b
   sub d
   sub e
   jr c, yr1inr2
   
   ld a,d
   sub b
   sub c
   jr c, yr2inr1
   
   exx
   ret

.xr1inr2

   neg
   cp c
   jr nc, doy
   ld c,a
   jp doy

.yr1inr2

   neg
   cp c
   jr nc, done
   ld c,a
   exx
   ret
   
.done

   scf
   exx
   ret

.yr2inr1

   ld b,d
   neg
   cp e
   ld c,a
   jr c, done+1
   ld c,e
   exx
   scf
   ret
