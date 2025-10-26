
; Rectangle, Intervals and Points
; 05.2006 aralbrec

SECTION code_clib
PUBLIC r_IntersectIval16
PUBLIC _r_IntersectIval16
EXTERN RIntersectIval16

; int r_IntersectIval16(struct r_Ival16 *i1, struct r_Ival16 *i2, struct r_Ival16 *result)

.r_IntersectIval16
._r_IntersectIval16

   ld hl,7
   add hl,sp
   ld d,(hl)
   dec hl
   ld e,(hl)
   dec hl
   push hl
   ex de,hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld c,(hl)
   inc hl
   ld b,(hl)
   push bc
   exx
   pop de
   exx
   pop hl
   push de
   ld d,(hl)
   dec hl
   ld e,(hl)
   dec hl
   push hl
   ex de,hl
   ld c,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   pop hl
   ex (sp),hl
   
   call RIntersectIval16
   jr nc, no

   pop hl
   ld a,(hl)
   dec hl
   ld l,(hl)
   ld h,a
   ld (hl),c
   inc hl
   ld (hl),b
   inc hl
   ld (hl),e
   inc hl
   ld (hl),d
   ld hl,1
   ret
   
.no

   pop hl
   ld hl,0
   ret
