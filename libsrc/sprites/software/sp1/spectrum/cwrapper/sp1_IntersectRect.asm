
; C Wrapper
; 05.2006 aralbrec, Sprite Pack v3.0
; Sinclair Spectrum version

; int sp1_IntersectRect(struct sp1_Rect *r1, struct sp1_Rect *r2, struct sp1_Rect *result)

XLIB sp1_IntersectRect
LIB SP1IntersectRect

.sp1_IntersectRect

   ld hl,7
   add hl,sp
   ld d,(hl)
   dec hl
   ld e,(hl)
   dec hl
   ld a,(hl)
   dec hl
   push hl
   ld l,(hl)
   ld h,a
   call SP1IntersectRect
   pop hl
   jr nc, no
   dec hl
   ld d,(hl)
   dec hl
   ld e,(hl)
   ex de,hl
   exx
   push bc
   exx
   pop de
   ld (hl),d
   inc hl
   ld (hl),b
   inc hl
   ld (hl),c
   inc hl
   ld (hl),e
   ld hl,1
   ret

.no

   ld hl,0
   ret
