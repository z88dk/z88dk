
; Rectangle, Intervals and Points
; 05.2006 aralbrec

SECTION code_clib
PUBLIC r_IntersectRect8
PUBLIC _r_IntersectRect8
EXTERN RIntersectRect8

; int r_IntersectRect8(struct r_Rect8 *r1, struct r_Rect8 *r2, struct r_Rect8 *result)

.r_IntersectRect8
._r_IntersectRect8

   ld hl,7
   add hl,sp
   ld d,(hl)
   dec hl
   ld e,(hl)
   dec hl
   push hl
   ex de,hl
   ld b,(hl)
   inc hl
   ld c,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld e,(hl)
   pop hl
   push de
   ld d,(hl)
   dec hl
   ld e,(hl)
   dec hl
   push hl
   ex de,hl
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
   pop bc
   push hl
   exx
   
   call RIntersectRect8
   pop hl
   jr nc, no
   
   ld d,(hl)
   dec hl
   ld e,(hl)
   ex de,hl
   ld (hl),b
   inc hl
   ld (hl),c
   inc hl
   push hl
   exx
   pop hl
   ld (hl),b
   inc hl
   ld (hl),c
   ld hl,1
   ret

.no

   ld hl,0
   ret
