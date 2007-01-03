; uint __FASTCALL__ wpeek(void *addr)
; 11.2006 aralbrec

XLIB wpeek
XDEF ASMDISP_WPEEK

.wpeek

   ld e,(hl)
   inc hl
   ld d,(hl)
   ex de,hl
   ret

DEFC ASMDISP_WPEEK = 0
