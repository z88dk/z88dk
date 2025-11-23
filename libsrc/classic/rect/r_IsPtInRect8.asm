
; Rectangle, Intervals and Points
; 05.2006 aralbrec

SECTION code_clib
PUBLIC r_IsPtInRect8
PUBLIC _r_IsPtInRect8
EXTERN RIsPtInRect8

; int r_IsPtInRect8(uchar x, uchar y, struct r_Rect8 *r)

.r_IsPtInRect8
._r_IsPtInRect8

   ld hl,2
   add hl,sp
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   push hl
   ld b,(hl)
   inc hl
   ld c,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld e,(hl)
   pop hl
   ld a,(hl)
   inc hl
   inc hl
   ld h,(hl)
   ld l,a
   ld a,h
   call RIsPtInRect8
   ld hl,0
   ret nc
   inc l
   ret
