; void ldiv(ldiv_t *d, long num, long denom)
; 12.2006 aralbrec

XLIB ldiv
LIB l_long_div

.ldiv

   ; setup: dehl = denom, stack = num
   
   ld hl,9
   add hl,sp
   ld d,(hl)
   dec hl
   ld e,(hl)
   dec hl
   push de
   ld d,(hl)
   dec hl
   ld e,(hl)
   dec hl
   push de
   ld d,(hl)
   dec hl
   ld e,(hl)
   dec hl
   ld a,(hl)
   dec hl
   ld l,(hl)
   ld h,a
   call l_long_div           ; dehl = q, de'hl' = r
   ex de,hl
   push hl
   ld hl,12
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
   inc hl
   push hl
   exx
   ex de,hl
   ex (sp),hl
   ld (hl),e
   inc hl
   ld (hl),d
   inc hl
   pop de
   ld (hl),e
   inc hl
   ld (hl),d
   ret

