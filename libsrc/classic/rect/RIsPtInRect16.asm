
; Rectangle, Intervals and Points
; 05.2006 aralbrec

SECTION code_clib
PUBLIC RIsPtInRect16

; Determine if 16-bit (x,y) point lies in a 16-bit bounding
; rectangle.  Rectangle bounds wrap across 0-65535 boundaries.
;
; enter :  hl = x coord of point
;          bc = x coord of rectangle
;          de = width of rectangle
;         hl' = y coord of point
;         bc' = y coord of rectangle
;         de' = height of rectangle
;
; exit  : carry flag set = in rectangle
; uses  : f, hl, hl'

.RIsPtInRect16

   or a
   sbc hl,bc
   or a
   sbc hl,de
   ret nc
   
   exx
   
   or a
   sbc hl,bc
   or a
   sbc hl,de
   
   exx
   
   ret
