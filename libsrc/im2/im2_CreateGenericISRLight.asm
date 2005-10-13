; 10.2005 aralbrec

XLIB im2_CreateGenericISRLight
LIB IM2CreateGenericISRLight

.im2_CreateGenericISRLight
   ld hl,2
   add hl,sp
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld a,(hl)
   call IM2CreateGenericISRLight
   ex de,hl
   ret
