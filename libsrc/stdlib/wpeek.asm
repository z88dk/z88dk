; uint __FASTCALL__ wpeek(void *addr)
; 11.2006 aralbrec

XLIB wpeek

.wpeek

   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   ret
