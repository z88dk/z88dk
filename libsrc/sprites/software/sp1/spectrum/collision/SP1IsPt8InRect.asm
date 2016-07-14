
; SP1IsPt8InRect
; 05.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version
; uses rectangles library

PUBLIC SP1IsPt8InRect
EXTERN RIsPtInRect8

; Determines if a pixel coordinate lies within an 8-bit
; rectangle described using character coordinates.  The
; pixel coordinate is divided by 8 to change to character
; coordinates in this subroutine.
;
; enter : bc = x coordinate of pixel
;         de = y coordinate of pixel
;         hl = & struct sp1_Rect
; exit  : carry flag set = in rectangle
; uses  : af,af',bc,de,hl

.SP1IsPt8InRect

   ld a,c
   srl b
   rra
   srl b
   rra
   srl b
   rra
   ex af,af                  ; a' = 8-bit x coord
   ld a,e
   srl d
   rra
   srl d
   rra
   srl d
   rra                       ; a = 8-bit y coord
   ld d,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld c,(hl)
   inc hl
   ld e,(hl)
   ld l,a
   ex af,af
   jp RIsPtInRect8
