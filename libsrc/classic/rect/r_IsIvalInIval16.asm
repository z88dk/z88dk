
; Rectangle, Intervals and Points
; 05.2006 aralbrec

SECTION code_clib
PUBLIC r_IsIvalInIval16
PUBLIC _r_IsIvalInIval16
EXTERN RIsIvalInIval16

; int r_IsIvalInIval16(struct r_Ival16 *i1, struct r_Ival16 *i2)

.r_IsIvalInIval16
._r_IsIvalInIval16

   ld hl,2
   add hl,sp
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
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
   ld a,(hl)
   inc hl
   push hl
   ld h,(hl)
   ld l,a
   exx
   pop hl
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   exx
   call RIsIvalInIval16
   ld hl,0
   ret nc
   inc l
   ret
