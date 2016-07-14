
; SP1IsPtInRect
; 05.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version
; uses rectangles library

PUBLIC SP1IsPtInRect
EXTERN RIsPtInRect8

; Determines if a pixel coordinate lies within an 8-bit
; rectangle described using character coordinates.  The
; pixel coordinate is divided by 8 to change to character
; coordinates in this subroutine.
;
; enter : a = x coordinate
;         e = y coordinate
;         hl = & struct sp1_Rect
; exit  : carry flag set = in rectangle
; uses  : af,af',bc,de,hl

.SP1IsPtInRect

   ld d,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld c,(hl)
   inc hl
   ld l,(hl)
   ld h,e
   ld e,l
   ld l,h
   jp RIsPtInRect8
