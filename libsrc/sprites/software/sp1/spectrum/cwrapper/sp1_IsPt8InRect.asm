
; C Wrapper
; 05.2006 aralbrec, Sprite Pack v3.0
; Sinclair Spectrum version

XLIB sp1_IsPt8InRect
LIB SP1IsPt8InRect

; int sp1_IsPt8InRect(uint x, uint y, struct sp1_Rect *r)

.sp1_IsPt8InRect

   ld hl,7
   add hl,sp
   ld b,(hl)
   dec hl
   ld c,(hl)
   dec hl
   ld d,(hl)
   dec hl
   ld e,(hl)
   dec hl
   ld a,(hl)
   dec hl
   ld l,(hl)
   ld h,a
   call SP1IsPt8InRect
   ld hl,0
   ret nc
   inc l
   ret
