; uint __FASTCALL__ wpeek(void *addr)
; 11.2006 aralbrec

XLIB wpeek

.wpeek

   ld e,(hl)
   inc hl
   ld d,(hl)
   ex de,hl
   ret
