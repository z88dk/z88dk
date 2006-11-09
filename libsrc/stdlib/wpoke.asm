; void wpoke(void *addr, uint word)
; 11.2006 aralbrec

XLIB wpoke

.wpoke

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
   ld (hl),e
   inc hl
   ld (hl),d
   ret
