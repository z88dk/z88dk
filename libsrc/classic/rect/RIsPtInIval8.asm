
; Rectangle, Intervals and Points
; 05.2006 aralbrec

SECTION code_clib
PUBLIC RIsPtInIval8

; Determine if 8-bit point lies in an 8-bit interval.
; Interval bounds wrap across 0-255 boundaries.
;
; enter :  a = coordinate of point
;          d = interval start coordinate
;          e = width of interval
; exit  : carry flag set = in interval
; used  : af

.RIsPtInIval8

   sub d
   cp e
   ret
