
; Rectangle, Intervals and Points
; 05.2006 aralbrec

XLIB r_IsIvalInIval8
LIB RIsIvalInIval8

; int r_IsIvalInIval8(struct r_Ival8 *i1, struct r_Ival8 *i2)

.r_IsIvalInIval8

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
   ex de,hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   ex de,hl
   ld d,(hl)
   inc hl
   ld e,(hl)
   call RIsIvalInIval8
   ld hl,0
   ret nc
   inc l
   ret
