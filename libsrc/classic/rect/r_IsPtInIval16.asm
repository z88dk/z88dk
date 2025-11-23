
; Rectangle, Intervals and Points
; 05.2006 aralbrec

SECTION code_clib
PUBLIC r_IsPtInIval16
PUBLIC _r_IsPtInIval16
EXTERN RIsPtInIval16

; int r_IsPtInIval16(uint x, struct r_Ival16 *i)

.r_IsPtInIval16
._r_IsPtInIval16

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
   pop hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   call RIsPtInIval16
   ld hl,0
   ret nc
   inc l
   ret
