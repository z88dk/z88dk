
; Rectangle, Intervals and Points
; 05.2006 aralbrec

SECTION code_clib
PUBLIC r_IsRectInRect8
PUBLIC _r_IsRectInRect8
EXTERN RIsRectInRect8

; int r_IsRectInRect8(struct r_Rect8 *r1, struct r_Rect8 *r2)

.r_IsRectInRect8
._r_IsRectInRect8

   ld hl,2
   add hl,sp
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ex de,hl
   ld b,(hl)
   inc hl
   ld c,(hl)
   inc hl
   push hl
   ex de,hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   ld d,(hl)
   inc hl
   ld e,(hl)
   inc hl
   push hl
   exx
   pop hl
   ld d,(hl)
   inc hl
   ld e,(hl)
   pop hl
   ld b,(hl)
   inc hl
   ld c,(hl)
   exx
   call RIsRectInRect8
   ld hl,0
   ret nc
   inc l
   ret
