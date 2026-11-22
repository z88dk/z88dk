
; Rectangle, Intervals and Points
; 05.2006 aralbrec

SECTION code_clib
PUBLIC RIsIvalInIval8

; Determine if two 8-bit intervals intersect.  Intervals
; can wrap across 0-255 boundary.  Amazingly this test
; reduces to detecting whether either of the start points
; of each interval lie in the other interval.
;
; enter  :  b = interval 1 start coordinate
;           c = interval 1 width
;           d = interval 2 start coordinate
;           e = interval 2 width
; exit   : carry flag set = intersection detected
; uses   : af

.RIsIvalInIval8

   ld a,b
   sub d
   cp e
   ret c

   ld a,d
   sub b
   cp c
   ret
   
