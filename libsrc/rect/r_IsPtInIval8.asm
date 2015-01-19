
; Rectangle, Intervals and Points
; 05.2006 aralbrec

PUBLIC r_IsPtInIval8
EXTERN RIsPtInIval8

; int r_IsPtInIval8(uchar x, struct r_Ival8 *i)

.r_IsPtInIval8

   ld hl,4
   add hl,sp
   ld a,(hl)
   dec hl
   ld d,(hl)
   dec hl
   ld e,(hl)
   ex de,hl
   ld d,(hl)
   inc hl
   ld e,(hl)
   call RIsPtInIval8
   ld hl,0
   ret nc
   inc l
   ret
