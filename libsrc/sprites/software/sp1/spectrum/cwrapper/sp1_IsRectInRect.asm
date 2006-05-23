
; C Wrapper
; 05.2006 aralbrec, Sprite Pack v3.0
; Sinclair Spectrum version

XLIB sp1_IsRectInRect
LIB SP1IsRectInRect

; int sp1_IsRectInRect(struct sp1_Rect *r1, struct sp1_Rect *r2)

.sp1_IsRectInRect

   ld hl,5
   add hl,sp
   ld d,(hl)
   dec hl
   ld e,(hl)
   dec hl
   ld a,(hl)
   dec hl
   ld l,(hl)
   ld h,a
   call SP1IsRectInRect
   ld hl,0
   ret nc
   inc l
   ret
