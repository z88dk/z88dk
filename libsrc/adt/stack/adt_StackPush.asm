; int adt_StackPush(struct adt_Stack **s, void *item)
; 09.2005 aralbrec

XLIB adt_StackPush
LIB ADTStackPush

.adt_StackPush
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
   call ADTStackPush
   ret nc
   ld hl,1
   ret
