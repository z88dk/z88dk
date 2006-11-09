; void bpoke(void *addr, uchar byte)
; 11.2006 aralbrec

XLIB bpoke

.bpoke

   ld hl,2
   add hl,sp
   ld e,(hl)
   inc hl
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   ld (hl),e
   ret
