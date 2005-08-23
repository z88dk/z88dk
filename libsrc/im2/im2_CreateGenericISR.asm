; 05.2005 aralbrec

XLIB im2_CreateGenericISR
LIB IM2CreateGenericISR

.im2_CreateGenericISR
   ld hl,2
   add hl,sp
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld a,(hl)
   call IM2CreateGenericISR
   ex de,hl
   ret
