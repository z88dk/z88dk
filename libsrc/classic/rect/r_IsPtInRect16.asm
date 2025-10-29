
; Rectangle, Intervals and Points
; 05.2006 aralbrec

SECTION code_clib
PUBLIC r_IsPtInRect16
PUBLIC _r_IsPtInRect16
EXTERN RIsPtInRect16

; int r_IsPtInRect16(uint x, uint y, struct r_Rect16 *r)

.r_IsPtInRect16
._r_IsPtInRect16

   ld hl,2
   add hl,sp
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   push hl
   ex de,hl
   ld c,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   push hl
   exx
   pop hl
   ld c,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   pop hl
   ld a,(hl)
   inc hl
   push hl
   ld h,(hl)
   ld l,a
   exx
   pop hl
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   call RIsPtInRect16
   ld hl,0
   ret nc
   inc l
   ret
