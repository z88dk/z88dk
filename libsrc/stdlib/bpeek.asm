; uchar __FASTCALL__ bpeek(void *addr)
; 11.2006 aralbrec

XLIB bpeek
XDEF ASMDISP_BPEEK

.bpeek

   ld l,(hl)
   ld h,0
   ret

DEFC ASMDISP_BPEEK = 0
