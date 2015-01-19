; uchar __FASTCALL__ bpeek(void *addr)
; 11.2006 aralbrec

PUBLIC bpeek

.bpeek

   ld l,(hl)
   ld h,0
   ret
