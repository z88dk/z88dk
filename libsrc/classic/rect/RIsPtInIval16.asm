
; Rectangle, Intervals and Points
; 05.2006 aralbrec

SECTION code_clib
PUBLIC RIsPtInIval16

; Determine if 16-bit point lies in a 16-bit interval.
; Interval bounds wrap across 0-65535 boundaries.
;
; enter : hl = coordinate of point
;         bc = interval start coordinate
;         de = width of interval
; exit  : carry flag set = in interval
; used  : f, hl

.RIsPtInIval16

   or a
   sbc hl,bc
   or a
   sbc hl,de
   ret
