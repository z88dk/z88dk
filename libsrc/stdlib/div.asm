; void div(div_t *d, int num, int denom)
; 12.2006 aralbrec

XLIB div
LIB l_div

.div

   ld hl,5
   add hl,sp
   ld d,(hl)
   dec hl
   ld e,(hl)
   dec hl
   ld a,(hl)
   dec hl
   ld l,(hl)
   ld h,a
   call l_div                ; hl = q, de = r
   ex de,hl
   push hl
   ld hl,8
   add hl,sp
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   ld (hl),e
   inc hl
   ld (hl),d
   inc hl
   pop de
   ld (hl),e
   inc hl
   ld (hl),d
   ret
