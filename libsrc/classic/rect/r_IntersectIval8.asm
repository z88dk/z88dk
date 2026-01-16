
; Rectangle, Intervals and Points
; 05.2006 aralbrec

SECTION code_clib
PUBLIC r_IntersectIval8
PUBLIC _r_IntersectIval8
EXTERN RIntersectIval8

; int r_IntersectIval8(struct r_Ival8 *i1, struct r_Ival8 *i2, struct r_Ival8 *result)

.r_IntersectIval8
._r_IntersectIval8

   ld hl,7
   add hl,sp
   ld d,(hl)
   dec hl
   ld e,(hl)
   dec hl
   ex de,hl
   ld b,(hl)
   inc hl
   ld c,(hl)
   ex de,hl
   ld d,(hl)
   dec hl
   ld e,(hl)
   dec hl
   push hl
   ex de,hl
   ld d,(hl)
   inc hl
   ld e,(hl)
   
   call RIntersectIval8
   jr nc, no
   
   pop hl
   ld d,(hl)
   dec hl
   ld e,(hl)
   ex de,hl
   ld (hl),b
   inc hl
   ld (hl),c
   ld hl,1
   ret
   
.no

   pop hl
   ld hl,0
   ret
