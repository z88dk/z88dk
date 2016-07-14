
; SP1IsRectInRect
; 05.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version
; uses rectangles library

PUBLIC SP1IsRectInRect
EXTERN RIsRectInRect8

; Determines if two 8-bit rectangles overlap.
;
; enter : de = & sp1_Rect #1
;         hl = & sp1_Rect #2
; exit  : carry flag set = overlap detected
; uses  : af,bc,de,hl,af',bc',de',hl'

.SP1IsRectInRect

   ld a,(de)
   inc de
   push de
   ex af,af                  ; a' = rect #1 y coord
   ld a,(hl)                 ; a = rect #2 y coord
   inc hl
   ld d,(hl)
   inc hl
   ld e,(hl)
   inc hl
   ex (sp),hl
   ld b,(hl)
   inc hl
   ld c,(hl)
   inc hl
   push hl
   exx
   pop hl
   ld c,(hl)
   ld d,a
   ex af,af
   ld b,a
   pop hl
   ld e,(hl)
   exx
   jp RIsRectInRect8
