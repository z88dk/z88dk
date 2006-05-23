
; C Wrapper
; 05.2006 aralbrec, Sprite Pack v3.0
; Sinclair Spectrum version

XLIB sp1_IsPtInRect
LIB SP1IsPtInRect

; int sp1_IsPtInRect(uchar x, uchar y, struct sp1_Rect *r)

.sp1_IsPtInRect

   ld hl,6
   add hl,sp
   ld d,(hl)
   dec hl
   dec hl
   ld e,(hl)
   dec hl
   ld a,(hl)
   dec hl
   ld l,(hl)
   ld h,a
   ld a,d
   call SP1IsPtInRect
   ld hl,0
   ret nc
   inc l
   ret
